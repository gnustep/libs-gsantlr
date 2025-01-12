/* ANTLRLLkParser.m
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
#include "ANTLRLLkParser.h"

BOOL ANTLRLLkParser_traceFlag_LA=NO;

@implementation ANTLRLLkParser

//--------------------------------------------------------------------
+(void)setTraceFlag_LA:(BOOL)_trace
{
  ANTLRLLkParser_traceFlag_LA=_trace;
};

//--------------------------------------------------------------------
-(id)initWithTokenBuffer:(ANTLRTokenBuffer*)_buffer
					maxK:(int)_k
{
  LOGObjectFnStart();
  if ((self = [super initWithTokenBuffer:_buffer]))
	  k = _k;
  LOGObjectFnStop();
  return self;
}

//--------------------------------------------------------------------
-(id)initWithMaxK:(int)_k
{
  return [self initWithTokenBuffer:nil
			   maxK:_k];
};

//--------------------------------------------------------------------
-(id)initWithTokenizer:(ANTLRDefTokenizer)_lexer
				  maxK:(int)_k
{
  return [self initWithTokenBuffer:[ANTLRTokenBuffer tokenBufferWithTokenizer:_lexer]
               maxK:_k];
};

//--------------------------------------------------------------------
-(void)consume
{
  //	Consume another token from the input stream.  Can only write sequentially!
  //		If you need 3 tokens ahead, you must consume 3 times.
  //
  //	Note that it is possible to overwrite tokens that have not been matched.
  //		For example, calling consume() 3 times when k=2, means that the first token
  //		consumed will be overwritten with the 3rd.
  [input consume];
};

//--------------------------------------------------------------------
-(int)LA:(int)_i
{
  int c;
  LOGObjectFnStart();
  if (_inputLA)
    c=(int)_inputLA(input, @selector(LA:), _i);
  else
    c=[input LA:_i];
  if (ANTLRLLkParser_traceFlag_LA)
	{
	  NSLog(@"%@ LLkParse LA:%d=%d",ANTLRTIDInfo(),_i,c);
	};
  LOGObjectFnStop();
  return c;
}

//--------------------------------------------------------------------
-(ANTLRDefToken)LT:(int)_i
{
  ANTLRDefToken t=nil;
  if (_inputLT)
    t=_inputLT(input, @selector(LT:), _i);
  else
    t=[input LT:_i];
  LOGObjectFnStop();
  return t;
};

//--------------------------------------------------------------------
// tracing
-(void)_trace:(NSString*)_text
		 rule:(NSString*)_ruleName
{
  register int cnt;
  [ANTLRLogOut writeFormat:@"%@ %@%s",
				_text,
				_ruleName,
				((guessing > 0) ? "; [guessing]" : "; ")];

  for (cnt = 1; cnt <= k; cnt++)
	{
	  if (cnt!=1)
		[ANTLRLogOut writeString:@", "];

	  [ANTLRLogOut writeFormat:@"LA(%i)==%@",
					cnt,
					[[self LT:cnt] text]];
	};
  [ANTLRLogOut writeNewline];
};

//--------------------------------------------------------------------
-(void)traceIn:(NSString*)_ruleName
{
  [self _trace:@"LLkParser enter" rule:_ruleName];
}

//--------------------------------------------------------------------
-(void)traceOut:(NSString*)_ruleName
{
  [self _trace:@"LLkParser exit " rule:_ruleName];
};

@end
