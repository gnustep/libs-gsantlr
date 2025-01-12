/* ANTLRHashString.m
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
#include "ANTLRException.h"

//====================================================================
@implementation ANTLRException

//--------------------------------------------------------------------
-(id)init
{
  return [self initWithName:@"ANTLRException"
			   reason:@"an antlr exception occurred"
			   userInfo:nil];
};

@end

//====================================================================
@implementation ANTLRScannerException

//--------------------------------------------------------------------
+(void)raiseWithReason:(NSString*)_reason
				  line:(int)_line;
{
  id exception=[[ANTLRScannerException alloc]initWithReason:_reason
											 line:_line];
  [exception raise];
};

//--------------------------------------------------------------------
-(id)init
{
  return [self initWithName:@"ANTLRScannerException"
			   reason:@"a scanner exception occurred"
			   userInfo:nil];
};

//--------------------------------------------------------------------
-(id)initWithReason:(NSString*)_reason
			   line:(int)_line
{
  _reason = [NSString stringWithFormat:@"[line=%03i] %@",
					  _line,
					  _reason];
  if ((self = [super initWithName:@"ANTLRScannerException"
					 reason:_reason
					 userInfo:nil]))
	  line = _line;
  return self;
};

// accessors

//--------------------------------------------------------------------
-(int)line
{
  return line;
}

@end

//====================================================================
@implementation ANTLRParserException

//--------------------------------------------------------------------
+(void)raiseWithReason:(NSString *)_reason
				  line:(int)_line;
{
  id exception=[[ANTLRParserException alloc]initWithReason:_reason
											line:_line];
  [exception raise];
};

//--------------------------------------------------------------------
-(id)init
{
  return [self initWithName:@"ANTLRParserException"
			   reason:@"a scanner exception occurred"
			   userInfo:nil];
};

//--------------------------------------------------------------------
-(id)initWithReason:(NSString *)_reason
			   line:(int)_line
{
  _reason = [NSString stringWithFormat:@"[line=%03i] %@",
					  _line,
					  _reason];

  if ((self = [super initWithName:@"ANTLRParserException"
					 reason:_reason
					 userInfo:nil]))
	  line = _line;
  return self;
};

// accessors

//--------------------------------------------------------------------
-(int)line
{
  return line;
};

@end

//====================================================================
@implementation ANTLRSemanticException
@end
