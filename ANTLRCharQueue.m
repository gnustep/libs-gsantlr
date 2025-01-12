/* ANTLRCharQueue.m
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
#include "ANTLRCharQueue.h"

@implementation ANTLRCharQueue

//--------------------------------------------------------------------
+(id)charQueueWithCapacity:(unsigned)_capacity
{
  return AUTORELEASE([[self alloc] initWithCapacity:_capacity]);
}

//--------------------------------------------------------------------
-(id)initWithCapacity:(unsigned)_capacity
{
  LOGObjectFnStart();
  if ((self = [super init]))
	{
	  int size;

	  // Find first power of 2 >= to requested size
	  for (size = 2; size < _capacity; size *= 2);

	  buffer = ANTLR_ALLOC_ATOMIC(sizeof(unichar) * size);
	  bufLen = size;
	  memset(buffer, 0, sizeof(unichar) * size);
	  
	  sizeLessOne = bufLen - 1;
	  offset      = 0;
	  count  = 0;
	};
  LOGObjectFnStop();
  return self;
};

//--------------------------------------------------------------------
#if !ANTLR_GC
- (void)dealloc
{
  ANTLR_FREE(buffer);
  [super dealloc];
};
#endif

// growing

//--------------------------------------------------------------------
-(void)grow
{
  register int i;
  unichar *newBuffer = NULL;
  LOGObjectFnStart();

  newBuffer = ANTLR_ALLOC_ATOMIC(sizeof(unichar) * bufLen * 2);
  memset(newBuffer, 0, sizeof(unichar) * bufLen * 2);

  // Copy the contents to the new buffer
  // Note that this will store the first logical item in the 
  // first physical array element.
  for (i = 0; i < bufLen; i++)
    // newBuffer[i] = [self characterAtIndex:i]
    newBuffer[i] = buffer[(offset + i) & sizeLessOne];

  ANTLR_FREE(buffer);
  buffer      =  newBuffer;
  bufLen      *= 2;
  sizeLessOne =  bufLen - 1;
  offset      =  0;
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
-(void)append:(unichar)_token
{
  LOGObjectFnStart();
  if (count == bufLen)
    [self grow];
  buffer[(offset + count) & sizeLessOne] = _token;
  count++;
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
-(void)removeFirst
{
  LOGObjectFnStart();
  offset = (offset + 1) & sizeLessOne;
  count--;
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
-(unichar)elementAt:(int)_idx
{
  // zero is the token at the front of the queue
  unichar c;
  LOGObjectFnStart();
  c=buffer[(offset + _idx) & sizeLessOne];
  LOGObjectFnStop();
  return c;
};

//--------------------------------------------------------------------
-(unsigned int)count
{
  return count;
};

@end
