/*
*   $Id: sort.h,v 1.2 2002/02/17 06:04:32 darren Exp $
*
*   Copyright (c) 1998-2002, Darren Hiebert
*
*   This source code is released for free distribution under the terms of the
*   GNU General Public License.
*
*   External interface to sort.c
*/
#ifndef _SORT_H
#define _SORT_H

/*
*   INCLUDE FILES
*/
#include "general.h"	/* must always come first */

/*
*   FUNCTION PROTOTYPES
*/
extern void catFile (const char *const name);

#ifdef EXTERNAL_SORT
extern void externalSortTags (const boolean toStdout);
#else
extern void internalSortTags (const boolean toStdout);
#endif

#endif	/* _SORT_H */

/* vi:set tabstop=8 shiftwidth=4: */
