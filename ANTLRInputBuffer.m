/* ANTLRInputBuffer.m
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

BOOL ANTLRInputBuffer_traceFlag_LA=NO;
@implementation ANTLRInputBuffer

//--------------------------------------------------------------------
+(void)setTraceFlag_LA:(BOOL)_trace
{
  ANTLRInputBuffer_traceFlag_LA=_trace;
};


#define METHOD(_obj, _sel) [(NSObject *)_obj methodForSelector:@selector(_sel)]

//--------------------------------------------------------------------
-(id)init
{
  LOGObjectFnStart();
  if ((self = [super init]))
	{
	  queue = [[ANTLRCharQueue alloc] initWithCapacity:1];
	  
	  if ([queue isKindOfClass:[NSObject class]])
		{
		  _queueAppend      = METHOD(queue, append:);
		  _queueCharAtIndex = METHOD(queue, elementAtIndex:);
		  _queueRemoveFirst = METHOD(queue, removeFirst);
		};
	};
  LOGObjectFnStop();
  return self;
}

//--------------------------------------------------------------------
#if !ANTLR_GC
- (void)dealloc
{
  ANTLR_DESTROY(queue);
  [super dealloc];
}
#endif

// consuming

//--------------------------------------------------------------------
-(void)syncConsume
{
  LOGObjectFnStart();
  // Sync up deferred consumption
  while (numToConsume > 0)
	{
	  if (nMarkers > 0)
		  // guess mode -- leave leading characters and bump offset.
		  markerOffset++;
	  else
		  // normal mode -- remove first character
		  [queue removeFirst];
	  numToConsume--;
	};
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
-(void)commit
{
  LOGObjectFnStart();
  nMarkers--;
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
-(void)fill:(int)_amount //throws IOException;
{
  [self subclassResponsibility:_cmd];
};

//--------------------------------------------------------------------
-(void)consume
{
  numToConsume++;
}

//--------------------------------------------------------------------
// lookahead
-(unichar)LA:(int)_i
{ // throws IOException
  unichar c;
  LOGObjectFnStart();
  [self fill:_i];
  c=[queue elementAt:(markerOffset + _i -1)];
  if (ANTLRInputBuffer_traceFlag_LA)
	{
	  NSLog(@"%@ CharBuffer LA:%d=%u (%c)",ANTLRTIDInfo(),
			_i,
			(unsigned)c,
			(char)c);
	};
  LOGObjectFnStop();
  return c;
};

//--------------------------------------------------------------------
-(NSString*)getLAChars
{
  NSMutableString* la = nil;
  int i=0;
  LOGObjectFnStart();
  la=AUTORELEASE([NSMutableString new]);
  for(i=markerOffset;i<[queue count];i++)
	{
	  unichar c=[queue elementAt:i];
	  [la appendString:[NSString stringWithCharacters:&c
									 length:1]];
	};
  LOGObjectFnStop();
  return la;
};

// marking

//--------------------------------------------------------------------
-(int)mark
{
  LOGObjectFnStart();
  [self syncConsume];
  nMarkers++;
  LOGObjectFnStop();
  return markerOffset;
};

//--------------------------------------------------------------------
-(void)rewind:(int)_mark
{
  LOGObjectFnStart();
  [self syncConsume];
  markerOffset = _mark;
  LOGObjectFnStop();
  nMarkers--;
};

//--------------------------------------------------------------------
-(NSString*)markedChars
{
  int i=0;
  NSMutableString* marked = nil;
  LOGObjectFnStart();
  marked=AUTORELEASE([NSMutableString new]);
  for(i=0;i<markerOffset;i++)
	{
	  unichar c=[queue elementAt:i];
	  [marked appendString:[NSString stringWithCharacters:&c
									 length:1]];
	};
  LOGObjectFnStop();
  return marked;
};

//--------------------------------------------------------------------
-(BOOL)isMarked
{
  return (nMarkers != 0);
};
@end
