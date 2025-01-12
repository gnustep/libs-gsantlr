/* ANTLRTokenQueue.h
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

#include "ANTLRCommon.h"
#include "ANTLRTokenQueue.h"

@implementation ANTLRTokenQueue

//--------------------------------------------------------------------
static inline
ANTLRDefToken _ANTLRTokenQueue_elementAtIndex(ANTLRTokenQueue *self, int _idx)
{
  //	Fetch a token from the queue by index
  //		@param idx The index of the token to fetch,
  //		where zero is the token at the front of the queue
  return self->buffer[(self->offset + _idx) & (self->sizeLessOne)];
};

//--------------------------------------------------------------------
static inline
void _ANTLRTokenQueue_grow(ANTLRTokenQueue *self)
{
  ANTLRDefToken *newBuffer = NULL;
  register int pos, size = self->sizeLessOne + 1;
  
  newBuffer = ANTLR_ALLOC(sizeof(id) * size * 2);
  memset(newBuffer, 0, sizeof(id) * size * 2);
  
  for (pos = 0; pos < size; pos++)
    newBuffer[pos] = _ANTLRTokenQueue_elementAtIndex(self, pos);
  
  if (self->buffer)
    ANTLR_FREE(self->buffer);
  
  self->buffer      = newBuffer;
  self->sizeLessOne = (size * 2) - 1;
  self->offset      = 0;
}

//--------------------------------------------------------------------
// init
- (id)initWithMinimumSize:(int)_minSize
{
  LOGObjectFnStart();
  if ((self = [super init]))
	{
	  int size;
	  for (size = 2; size < _minSize; size *= 2) ;

	  buffer = ANTLR_ALLOC(sizeof(id) * size);
	  memset(buffer, 0, size);

	  sizeLessOne = size - 1;
	  offset      = 0;
	  nbrEntries  = 0;
	};
  LOGObjectFnStop();
  return self;
};

//--------------------------------------------------------------------
#if !LIB_FOUNDATION_BOEHM_GC
- (void)dealloc
{
  ANTLR_FREE(buffer);
  [super dealloc];
};
#endif

//--------------------------------------------------------------------
// modifying
-(void)append:(ANTLRDefToken)_token
{
  LOGObjectFnStart();
  // Add token to end of the queue

  if (nbrEntries == (sizeLessOne + 1))
    _ANTLRTokenQueue_grow(self);

  buffer[(offset + nbrEntries) & sizeLessOne] = RETAIN(_token);
  nbrEntries++;
  LOGObjectFnStop();
}

//--------------------------------------------------------------------
-(void)removeFirst
{
  LOGObjectFnStart();
  // Remove token from front of queue
  if (nbrEntries > 0)
	{
	  RELEASE(buffer[(offset + 0) & sizeLessOne]);
	  buffer[(offset + 0) & sizeLessOne] = nil;
	  offset = (offset + 1) & sizeLessOne;
	  nbrEntries--;
	};
  LOGObjectFnStop();
}

//--------------------------------------------------------------------
-(ANTLRDefToken)elementAtIndex:(int)_idx
{
  /** Fetch a token from the queue by index
    * @param idx The index of the token to fetch,
    * where zero is the token at the front of the queue
    */
  return _ANTLRTokenQueue_elementAtIndex(self, _idx);
}

//--------------------------------------------------------------------
-(unsigned int)count
{
  return nbrEntries;
}

@end
