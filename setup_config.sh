# $1 is the location of the configs folder
ln -s $1/vim/.vim .vim
ln -s $1/vim/.vimrc .vimrc
ln -s $1/git/.gitconfig .gitconfig
ln -s $1/git/.gitshrc .gitshrc
ln -s $1/.zshrc .zshrc
ln -s $1/.oh-my-sh zsh

git clone https://github.com/robbyrussell/oh-my-zsh.git .oh-my-zsh
