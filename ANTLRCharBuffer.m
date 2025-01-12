/* ANTLRCharBuffer.m
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
#include "ANTLRTextStreamProtocols.h"

@implementation ANTLRCharBuffer

#define METHOD(_obj, _sel) [(NSObject *)_obj methodForSelector:@selector(_sel)]

//--------------------------------------------------------------------
+(id)charBufferWithTextStream:(ANTLRDefTextInputStream)_stream
{
  return AUTORELEASE([(ANTLRCharBuffer *)[self alloc]
                       initWithTextStream:_stream]);
};

//--------------------------------------------------------------------
-(id)initWithTextStream:(ANTLRDefTextInputStream)_stream
{
  LOGObjectFnStart();
  if ((self = [super init]))
	{
	  input = RETAIN(_stream);
	  if ([input isKindOfClass:[NSObject class]])
		_inReadChar = METHOD(input, readCharacter);
	};
  LOGObjectFnStop();
  return self;
}

//--------------------------------------------------------------------
#if !ANTLR_GC
-(void)dealloc
{
  ANTLR_DESTROY(input);
  [super dealloc];
}
#endif

//--------------------------------------------------------------------
-(void)fill:(int)_amount
{
  LOGObjectFnStart();
  [self syncConsume];

  // Fill the buffer sufficiently to hold needed characters
  while (self->queue->count < _amount + self->markerOffset)
    {
      unichar nextChar;

      if (self->_inReadChar)
	nextChar =(unichar)(int)self->_inReadChar(self->input, @selector(readCharacter));
      else
	nextChar = [self->input readCharacter];

      // Append the next character
      self->_queueAppend(self->queue, @selector(append:), nextChar);
    };
  LOGObjectFnStop();
};


@end
