"=============================================================================
" 	     File: packages.vim
"      Author: Mikolaj Machowski
"     Created: Tue Apr 23 06:00 PM 2002 PST
" 
"  Description: handling packages from within vim
"=============================================================================

" avoid reinclusion.
if !g:Tex_PackagesMenu || exists('s:doneOnce')
	finish
endif
let s:doneOnce = 1

let s:path = expand("<sfile>:p:h")

let s:menu_div = 20

com! -nargs=* TPackage let s:retVal = Tex_pack_one(<f-args>) <bar> normal! i<C-r>=s:retVal<CR>
com! -nargs=0 TPackageUpdate :silent! call Tex_pack_updateall(1)
com! -nargs=0 TPackageUpdateAll :silent! call Tex_pack_updateall(1)

imap <silent> <plug> <Nop>
nmap <silent> <plug> i

let g:Tex_package_supported = ''
let g:Tex_package_detected = ''
" Remember the defaults because we want g:Tex_PromptedEnvironments to contain
" in addition to the default, \newenvironments, and the \newenvironments might
" change...
let g:Tex_PromptedEnvironmentsDefault = g:Tex_PromptedEnvironments
let g:Tex_PromptedCommandsDefault = g:Tex_PromptedCommands


" Tex_pack_check: creates the package menu and adds to 'dict' setting. {{{
"
function! Tex_pack_check(package)
	if filereadable(s:path.'/packages/'.a:package)
		exe 'source ' . s:path . '/packages/' . a:package
		if has("gui_running")
			call Tex_pack(a:package)
		endif
		if g:Tex_package_supported !~ a:package
			let g:Tex_package_supported = g:Tex_package_supported.','.a:package
		endif
	endif
	if filereadable(s:path.'/dictionaries/'.a:package)
		exe 'setlocal dict+='.s:path.'/dictionaries/'.a:package
		if filereadable(s:path.'/dictionaries/'.a:package) && g:Tex_package_supported !~ a:package
			let g:Tex_package_supported = g:Tex_package_supported.','.a:package
		endif
	endif
	if g:Tex_package_detected !~ '\<'.a:package.'\>'
		let g:Tex_package_detected = g:Tex_package_detected.','.a:package
	endif
	let g:Tex_package_detected = substitute(g:Tex_package_detected, '^,', '', '')
	let g:Tex_package_supported = substitute(g:Tex_package_supported, '^,', '', '')
endfunction

" }}}
" Tex_pack_uncheck: removes package from menu and 'dict' settings. {{{
function! Tex_pack_uncheck(package)
	if has("gui_running") && filereadable(s:path.'/packages/'.a:package)
		exe 'silent! aunmenu '.g:Tex_PackagesMenuLocation.'-sep'.a:package.'-'
		exe 'silent! aunmenu '.g:Tex_PackagesMenuLocation.a:package.'\ Options'
		exe 'silent! aunmenu '.g:Tex_PackagesMenuLocation.a:package.'\ Commands'
	endif
	if filereadable(s:path.'/dictionaries/'.a:package)
		exe 'setlocal dict-='.s:path.'/dictionaries/'.a:package
	endif
endfunction

" }}}
" Tex_pack_updateall: updates the TeX-Packages menu {{{
" Description:
" 	This function first calls Tex_pack_all to scan for \usepackage's etc if
" 	necessary. After that, it 'supports' and 'unsupports' packages as needed
" 	in such a way as to not repeat work.
function! Tex_pack_updateall(force)
	call Tex_Debug('+Tex_pack_updateall')

	" Find out which file we need to scan.
	if Tex_GetMainFileName() != ''
		let fname = Tex_GetMainFileName(':p:r')
	else
		let fname = expand('%:p')
	endif
	" If this is the same as last time, don't repeat.
	if !a:force && exists('s:lastScannedFile') &&
				\ s:lastScannedFile == fname
		return
	endif
	" Remember which file we scanned for next time.
	let s:lastScannedFile = fname

	" Remember which packages we detected last time.
	if exists('g:Tex_package_detected')
		let oldpackages = g:Tex_package_detected
	else
		let oldpackages = ''
	endif

	" This sets up a global variable of all detected packages.
	let g:Tex_package_detected = ''
	call Tex_pack_all(fname)
	call Tex_Debug('updateall: detected = '.g:Tex_package_detected)

	" Now only support packages we didn't last time.
	" First remove packages which were used last time but are no longer used.
	let i = 1
	let oldPackName = Tex_Strntok(oldpackages, ',', i)
	while oldPackName != ''
		if g:Tex_package_detected !~ oldPackName
			call Tex_pack_uncheck(oldPackName)
		endif
		let i = i + 1
		let oldPackName = Tex_Strntok(oldpackages, ',', i)
	endwhile

	" Then support packages which are used this time but weren't used last
	" time.
	let i = 1
	let newPackName = Tex_Strntok(g:Tex_package_detected, ',', i)
	while newPackName != ''
		if oldpackages !~ newPackName
			call Tex_pack_one(newPackName)
		endif
		let i = i + 1
		let newPackName = Tex_Strntok(g:Tex_package_detected, ',', i)
	endwhile

	" Throw an event that we are done scanning packages. Some packages might
	" use this to change behavior based on which options have been used etc.
	silent! do LatexSuite User LatexSuiteScannedPackages
endfunction

" }}}
" Tex_pack_one: supports each package in the argument list.{{{
" Description:
"   If no arguments are supplied, then the user is asked to choose from the
"   packages found in the packages/ directory
function! Tex_pack_one(...)
	if a:0 == 0 || (a:0 > 0 && a:1 == '')
		let pwd = getcwd()
		exe 'cd '.s:path.'/packages'
		let packname = Tex_ChooseFromPrompt(
					\ "Choose a package: \n" . 
					\ Tex_CreatePrompt(glob('*'), 3, "\n") .
					\ "\nEnter number or filename :", 
					\ glob('*'), "\n")
		exe 'cd '.pwd
		if packname != ''
			return Tex_pack_one(packname)
		else
			return ''
		endif
	else
		" Support the packages supplied. This function can be called with
		" multiple arguments in which case, support each of them in turn.
		let retVal = ''
		let omega = 1
		while omega <= a:0
			let packname = a:{omega}
			if filereadable(s:path.'/packages/'.packname)
				call Tex_pack_check(packname)
				if exists('g:TeX_package_option_'.packname)
						\ && g:TeX_package_option_{packname} != ''
					let retVal = retVal.'\usepackage[<++>]{'.packname.'}<++>'
				else
					let retVal = retVal.'\usepackage{'.packname.'}'."\<CR>"
				endif
			else
				let retVal = retVal.'\usepackage{'.packname.'}'."\<CR>"
			endif
			let omega = omega + 1
		endwhile
		return IMAP_PutTextWithMovement(substitute(retVal, "\<CR>$", '', ''), '<+', '+>')
	endif
endfunction
" }}}
" Tex_pack_all: scans the current file for \usepackage{} lines {{{
"   and if supported, loads the options and commands found in the
"   corresponding package file. Also scans for \newenvironment and
"   \newcommand lines and adds names to g:Tex_Prompted variables, they can be
"   easy available through <F5> and <F7> shortcuts 
function! Tex_pack_all(fname)

	let pos = line('.').' | normal! '.virtcol('.').'|'
	let currfile = expand('%:p')

	let toquit = 0
	if a:fname != currfile
		exe 'split '.a:fname
		let toquit = 1
	endif

	0
	let beginline = search('\\begin{document}', 'W')
	let endline = search('\\end{document}', 'W')
	0

	" Scan
	while search('^\s*\\usepackage\_.\{-}{\_.\+}', 'W')
		if line('.') > beginline 
			break
		endif

		let saveA = @a

		" If there are options, then find those.
		if getline('.') =~ '\\usepackage\[.\{-}\]'
			let options = matchstr(getline('.'), '\\usepackage\[\zs.\{-}\ze\]')
		elseif getline('.') =~ '\\usepackage\['
			" Entering here means that the user has split the \usepackage
			" across newlines. Therefore, use yank.
			exec "normal! /{\<CR>\"ayi}"
			let options = @a
		else
			let options = ''
		endif

		" The following statement puts the stuff between the { }'s of a
		" \usepackage{stuff,foo} into @a. Do not use matchstr() and the like
		" because we can have things split across lines and such.
       	exec "normal! /{\<CR>\"ayi}"

		" now remove all whitespace from @a. We need to remove \n and \r
		" because we can encounter stuff like
		" \usepackage{pack1,
		"             newpackonanotherline}
		let @a = substitute(@a, "[ \t\n\r]", '', 'g')

		" Now we have something like pack1,pack2,pack3 with possibly commas
		" and stuff before the first package and after the last package name.
		" Remove those.
		let @a = substitute(@a, '\(^\W*\|\W*$\)', '', 'g')

		" This gets us a string like 'pack1,pack2,pack3'
		" TODO: This will contain duplicates if the user has duplicates.
		"       Should we bother taking care of this?
		let g:Tex_package_detected = g:Tex_package_detected.','.@a

		" For each package found, form a global variable of the form
		" g:Tex_{packagename}_options 
		" which contains a list of the options.
		let j = 1
		while Tex_Strntok(@a, ',', j) != ''
			let g:Tex_{Tex_Strntok(@a, ',', j)}_options = options
			let j = j + 1
		endwhile

		" Finally convert @a into something like '"pack1","pack2"'
		let @a = substitute(@a, '^\|$', '"', 'g')
		let @a = substitute(@a, ',', '","', 'g')

		" restore @a
		let @a = saveA

	endwhile

	" Because creating list of detected packages gives string
	" ',pack1,pack2,pack3' remove leading ,
	let g:Tex_package_detected = substitute(g:Tex_package_detected, '^,', '', '')

	" Scans whole file (up to \end{document}) for \newcommand and adds this
	" commands to g:Tex_PromptedCommands variable, it is easily available
	" through <F7>
	0 
	let s:Tex_LookForCommand = g:Tex_PromptedCommandsDefault 
	while search('^\s*\\newcommand\*\?{.\{-}}', 'W')

		if line('.') > endline 
			break
		endif

		let newcommand = matchstr(getline('.'), '\\newcommand\*\?{\\\zs.\{-}\ze}')
		let s:Tex_LookForCommand = s:Tex_LookForCommand . ',' . newcommand

	endwhile
	let g:Tex_PromptedCommands = s:Tex_LookForCommand

	" Scans whole file (up to \end{document}) for \newenvironment and adds this
	" environments to g:Tex_PromptedEnvironments variable, it is easily available
	" through <F5>
	0
	let s:Tex_LookForEnvironment = g:Tex_PromptedEnvironmentsDefault 
	while search('^\s*\\newenvironment\*\?{.\{-}}', 'W')

		if line('.') > endline 
			break
		endif

		let newenvironment = matchstr(getline('.'), '\\newenvironment\*\?{\zs.\{-}\ze}')
		let s:Tex_LookForEnvironment = s:Tex_LookForEnvironment . ',' . newenvironment

	endwhile
	let g:Tex_PromptedEnvironments = s:Tex_LookForEnvironment

	if toquit
		q	
	endif
	exe pos
endfunction
   
" }}}
" Tex_pack_supp_menu: sets up a menu for package files {{{
"   found in the packages directory groups the packages thus found into groups
"   of 20...
function! Tex_pack_supp_menu()

	let pwd = getcwd()
	exec 'cd '.s:path.'/packages'
	let suplist = glob("*")
	exec 'cd '.pwd

	let suplist = substitute(suplist, "\n", ',', 'g').','

	call Tex_MakeSubmenu(suplist, g:Tex_PackagesMenuLocation.'Supported.', 
		\ '<plug><C-r>=Tex_pack_one("', '")<CR>')
endfunction 

" }}}
" Tex_pack: loads the options (and commands) for the given package {{{
function! Tex_pack(pack)
	if exists('g:TeX_package_'.a:pack)

		let optionList = g:TeX_package_option_{a:pack}.','
		let commandList = g:TeX_package_{a:pack}.','

		" Don't create separator if in package file are only Vim commands. 
		" Rare but possible.
		if !(commandList == ',' && optionList == ',')
			exec 'amenu '.g:Tex_PackagesMenuLocation.'-sep'.a:pack.'- <Nop>'
		endif

		if optionList != ''

			let mainMenuName = g:Tex_PackagesMenuLocation.a:pack.'\ Options.'
			call s:GroupPackageMenuItems(optionList, mainMenuName, 
				\ '<plug><C-r>=IMAP_PutTextWithMovement("', ',")<CR>')

		endif

		if commandList != ''

			let mainMenuName = g:Tex_PackagesMenuLocation.a:pack.'\ Commands.'
			call s:GroupPackageMenuItems(commandList, mainMenuName, 
				\ '<plug><C-r>=Tex_ProcessPackageCommand("', '")<CR>',
				\ '<SID>FilterPackageMenuLHS')
		endif
	endif
endfunction 

" }}}

" ==============================================================================
" Menu Functions
" Creating menu items for the all the package files found in the packages/
" directory as well as creating menus for each supported package found in the
" preamble.
" ============================================================================== 
" Tex_MakeSubmenu: makes a submenu given a list of items {{{
" Description: 
"   This function takes a comma seperated list of menu items and creates a
"   'grouped' menu. i.e, it groups the items into s:menu_div items each and
"   puts them in submenus of the given mainMenu.
"   Each menu item is linked to the HandlerFunc.
"   If an additional argument is supplied, then it is used to filter each of
"   the menu items to generate better names for the menu display.
"
function! Tex_MakeSubmenu(menuList, mainMenuName, 
				\ handlerFuncLHS, handlerFuncRHS, ...)

	let extractFunction = (a:0 > 0 ? a:1 : '' )
	let menuList = substitute(a:menuList, '[^,]$', ',', '')

	let doneMenuSubmenu = 0

	while menuList != ''

		" Extract upto s:menu_div menus at once.
		let menuBunch = matchstr(menuList, '\v(.{-},){,'.s:menu_div.'}')

		" The remaining menus go into the list.
		let menuList = strpart(menuList, strlen(menuBunch))

		let submenu = ''
		" If there is something remaining, then we got s:menu_div items.
		" therefore put these menu items into a submenu.
		if strlen(menuList) || doneMenuSubmenu
			exec 'let firstMenu = '.extractFunction."(matchstr(menuBunch, '\\v^.{-}\\ze,'))"
			exec 'let lastMenu = '.extractFunction."(matchstr(menuBunch, '\\v[^,]{-}\\ze,$'))"

			let submenu = firstMenu.'\ \-\ '.lastMenu.'.'

			let doneMenuSubmenu = 1
		endif

		" Now for each menu create a menu under the submenu
		let i = 1
		let menuName = Tex_Strntok(menuBunch, ',', i)
		while menuName != ''
			exec 'let menuItem = '.extractFunction.'(menuName)'
			execute 'amenu '.a:mainMenuName.submenu.menuItem
				\ '       '.a:handlerFuncLHS.menuName.a:handlerFuncRHS

			let i = i + 1
			let menuName = Tex_Strntok(menuBunch, ',', i)
		endwhile
	endwhile
endfunction 

" }}}
" GroupPackageMenuItems: uses the sbr: to split menus into groups {{{
" Description: 
"   This function first splits up the menuList into groups based on the
"   special sbr: tag and then calls Tex_MakeSubmenu 
" 
function! <SID>GroupPackageMenuItems(menuList, menuName, 
					\ handlerFuncLHS, handlerFuncRHS,...)

	if a:0 > 0
		let extractFunction = a:1
	else
		let extractFunction = ''
	endif
	let menuList = a:menuList

	while matchstr(menuList, 'sbr:') != ''
		let groupName = matchstr(menuList, '\v^sbr:\zs.{-}\ze,')
		let menuList = strpart(menuList, strlen('sbr:'.groupName.','))
		if matchstr(menuList, 'sbr:') != ''
			let menuGroup = matchstr(menuList, '\v^.{-},\zesbr:')
		else
			let menuGroup = menuList
		endif

		call Tex_MakeSubmenu(menuGroup, a:menuName.groupName.'.', 
			\ a:handlerFuncLHS, a:handlerFuncRHS, extractFunction)

		let menuList = strpart(menuList, strlen(menuGroup))
	endwhile

	call Tex_MakeSubmenu(menuList, a:menuName,
		\ a:handlerFuncLHS, a:handlerFuncRHS, extractFunction)

endfunction " }}}
" Definition of what to do for various package commands {{{
let s:CommandSpec_bra = '\<+replace+>{<++>}<++>'
let s:CommandSpec_brs = '\<+replace+><++>'
let s:CommandSpec_brd = '\<+replace+>{<++>}{<++>}<++>'
let s:CommandSpec_env = '\begin{<+replace+>}'."\<CR><++>\<CR>".'\end{<+replace+>}<++>'
let s:CommandSpec_ens = '\begin{<+replace+>}<+extra+>'."\<CR><++>\<CR>".'\end{<+replace+>}<++>'
let s:CommandSpec_eno = '\begin[<++>]{<+replace+>}'."\<CR><++>\<CR>".'\end{<+replace+>}'
let s:CommandSpec_nor = '\<+replace+>'
let s:CommandSpec_noo = '\<+replace+>[<++>]'
let s:CommandSpec_nob = '\<+replace+>[<++>]{<++>}{<++>}<++>'
let s:CommandSpec_spe = '<+replace+>'
let s:CommandSpec_    = '\<+replace+>'

let s:MenuLHS_bra = '\\&<+replace+>{}'
let s:MenuLHS_brs = '\\&<+replace+>{}'
let s:MenuLHS_brd = '\\&<+replace+>{}{}'
let s:MenuLHS_env = '&<+replace+>\ (E)'
let s:MenuLHS_ens = '&<+replace+>\ (E)'
let s:MenuLHS_eno = '&<+replace+>\ (E)'
let s:MenuLHS_nor = '\\&<+replace+>'
let s:MenuLHS_noo = '\\&<+replace+>[]'
let s:MenuLHS_nob = '\\&<+replace+>[]{}{}'
let s:MenuLHS_spe = '&<+replace+>'
let s:MenuLHS_sep = '-sep<+replace+>-'
let s:MenuLHS_    = '\\&<+replace+>'
" }}}
" Tex_ProcessPackageCommand: processes a command from the package menu {{{
" Description: 
function! Tex_ProcessPackageCommand(command)
	if a:command =~ ':'
		let commandType = matchstr(a:command, '^\w\+\ze:')
		let commandName = matchstr(a:command, '^\w\+:\zs[^:]\+\ze:\?')
		let extrapart = strpart(a:command, strlen(commandType.':'.commandName.':'))
	else
		let commandType = ''
		let commandName = a:command
		let extrapart = ''
	endif

	let command = s:CommandSpec_{commandType}
	let command = substitute(command, '<+replace+>', commandName, 'g')
	let command = substitute(command, '<+extra+>', extrapart, 'g')
	return IMAP_PutTextWithMovement(command)
endfunction 
" }}}
" FilterPackageMenuLHS: filters the command description to provide a better menu item {{{
" Description: 
function! <SID>FilterPackageMenuLHS(command)
	let commandType = matchstr(a:command, '^\w\+\ze:')
	if commandType != ''
		let commandName = strpart(a:command, strlen(commandType.':'))
	else
		let commandName = a:command
	endif

	return substitute(s:MenuLHS_{commandType}, '<+replace+>', commandName, 'g')
endfunction " }}}

if g:Tex_Menus
	exe 'amenu '.g:Tex_PackagesMenuLocation.'&UpdatePackage :call Tex_pack(expand("<cword>"))<cr>'
	exe 'amenu '.g:Tex_PackagesMenuLocation.'&UpdateAll :call Tex_pack_updateall(1)<cr>'

 	call Tex_pack_supp_menu()
endif

augroup LatexSuite
	au LatexSuite User LatexSuiteFileType 
		\ call Tex_Debug('packages.vim: Catching LatexSuiteFileType event') | 
		\ call Tex_pack_updateall(0)
augroup END

" vim:fdm=marker:ts=4:sw=4:noet:ff=unix
