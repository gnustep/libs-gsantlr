/* ANTLRTokenBuffer.h
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
#include "ANTLRTokenBuffer.h"
#include "ANTLRTokenQueue.h"

BOOL ANTLRTokenBuffer_traceFlag_LA=NO;
@implementation ANTLRTokenBuffer

//--------------------------------------------------------------------
+(void)setTraceFlag_LA:(BOOL)_trace
{
  ANTLRTokenBuffer_traceFlag_LA=_trace;
};

//--------------------------------------------------------------------
+(id)tokenBufferWithTokenizer:(ANTLRDefTokenizer)_input
{
  return AUTORELEASE([[self alloc] initWithTokenizer:_input]);
}

//--------------------------------------------------------------------
-(id)initWithTokenizer:(ANTLRDefTokenizer)_input
{
  LOGObjectFnStart();
  if ((self = [super init]))
	{
	  ASSIGN(input, _input);
	  queue = [[ANTLRTokenQueue alloc] initWithMinimumSize:1];
	};
  LOGObjectFnStop();
  return self;
};

//--------------------------------------------------------------------
#if !ANTLR_GC
- (void)dealloc
{
  ANTLR_DESTROY(input);
  ANTLR_DESTROY(queue);
  [super dealloc];
}
#endif

//--------------------------------------------------------------------
static inline
void _ANTLRTokenBuffer_syncConsume(ANTLRTokenBuffer *self)
{
  while (self->numToConsume > 0)
	{
	  if (self->nMarkers > 0)
		// guess mode -- leave leading tokens and bump offset.
		self->markerOffset++;
	  else
		// normal mode -- remove first token
		[self->queue removeFirst];
	  self->numToConsume--;
	};
};

//--------------------------------------------------------------------
static inline
void _ANTLRTokenBuffer_fill(ANTLRTokenBuffer *self, int _amount)
{
  _ANTLRTokenBuffer_syncConsume(self);
  
  // Fill the buffer sufficiently to hold needed tokens
  while ([self->queue count] < (_amount + self->markerOffset))
	// Append the next token
	[self->queue append:[self->input nextToken]];
};

//--------------------------------------------------------------------
// consume
-(void)consume
{ // final
  LOGObjectFnStart();
  numToConsume++;
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
-(void)syncConsume
{ // final
  LOGObjectFnStart();
  _ANTLRTokenBuffer_syncConsume(self);
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
-(void)fill:(int)_amount
{ // final
  LOGObjectFnStart();
  _ANTLRTokenBuffer_fill(self, _amount);
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
// lookahead
-(int)LA:(int)_i
{
  int c;
  LOGObjectFnStart();
  _ANTLRTokenBuffer_fill(self, _i);
  c=[[queue elementAtIndex:markerOffset + _i - 1] tokenType];
  if (ANTLRTokenBuffer_traceFlag_LA)
	{
	  NSLog(@"%@ TokenBuffer LA:%d=%d",ANTLRTIDInfo(),_i,c);
	};
  LOGObjectFnStop();
  return c;
}

//--------------------------------------------------------------------
-(ANTLRDefToken)LT:(int)_i
{
  ANTLRDefToken t=nil;
  LOGObjectFnStart();
  _ANTLRTokenBuffer_fill(self, _i);
  t=[queue elementAtIndex:markerOffset + _i - 1];
  LOGObjectFnStop();
  return t;
}

//--------------------------------------------------------------------
// marking
-(int)mark
{
  LOGObjectFnStart();
  _ANTLRTokenBuffer_syncConsume(self);
  nMarkers++;
  LOGObjectFnStop();
  return markerOffset;
};

//--------------------------------------------------------------------
-(void)rewind:(int)_mark
{
  LOGObjectFnStart();
  _ANTLRTokenBuffer_syncConsume(self);
  markerOffset = _mark;
  nMarkers--;
  LOGObjectFnStop();
};

@end
