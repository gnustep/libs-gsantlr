/* TokenQueue.h
   Copyright (C) 1998, 1999  Helge Hess and Manuel Guesdon
   All rights reserved.

   Authors:	Helge Hess  	<helge@mdlink.de>
   			Manuel Guesdon	<mguesdon@sbuilders.com>

   This file is part of the ANTLR Objective-C Library.

   Permission to use, copy, modify, and distribute this software and its
   documentation for any purpose and without fee is hereby granted, provided
   that the above copyright notice appear in all copies and that both that
   copyright notice and this permission notice appear in supporting
   documentation.

   We disclaim all warranties with regard to this software, including all
   implied warranties of merchantability and fitness, in no event shall
   we be liable for any special, indirect or consequential damages or any
   damages whatsoever resulting from loss of use, data or profits, whether in
   an action of contract, negligence or other tortious action, arising out of
   or in connection with the use or performance of this software.

   ---------------------------------------------------------------------------
   This code is based on ANTLR toolkit (http://www.antlr.org)
   from MageLang Institute:
		"We encourage users to develop software with ANTLR. However,
		we do ask that credit is given to us for developing
		ANTLR. By "credit", we mean that if you use ANTLR or
		incorporate any source code into one of your programs
		(commercial product, research project, or otherwise) that
		you acknowledge this fact somewhere in the documentation,
		research report, etc... If you like ANTLR and have
		developed a nice tool with the output, please mention that
		you developed it using ANTLR."
*/

#ifndef _ANTLRTokenQueue_h_
	#define _ANTLRTokenQueue_h_

#include <ANTLRToken.h>

// A private circular buffer object used by the token buffer
@interface ANTLRTokenQueue : NSObject
{
  ANTLRDefToken*	buffer;			// Physical circular buffer of tokens
  int				sizeLessOne;	// buffer.length-1 for quick modulous
  int				offset;			// physical index of front token
  unsigned int 		nbrEntries;		// number of tokens in the queue
}

- (id)initWithMinimumSize:(int)_size;

- (void)append:(ANTLRDefToken)_token;	// Add token to end of the queue
- (void)removeFirst;               		// Remove token from front of queue

//	Fetch a token from the queue by index
//		idx The index of the token to fetch,
//		where zero is the token at the front of the queue
-(ANTLRDefToken)elementAtIndex:(int)_idx; // final
- (unsigned int)count;

@end

#endif //_ANTLRTokenQueue_h_
