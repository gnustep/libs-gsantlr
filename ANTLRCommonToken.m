/* ANTLRCommonToken.m
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
#include "ANTLRCommonToken.h"

@implementation ANTLRCommonToken

//--------------------------------------------------------------------
+(id)commonToken
{
  return AUTORELEASE([self new]);
};

+(id)commonTokenWithTokenType:(ANTLRTokenType)_type
						 text:(NSString*)_text
{
  return AUTORELEASE([[self alloc] initWithTokenType:_type
								   text:_text]);
};

//--------------------------------------------------------------------
+(id)commonTokenWithText:(NSString*)_text
{
  return AUTORELEASE([[self alloc] initWithTokenType:ANTLRToken_INVALID_TYPE
								   text:_text]);
}

//--------------------------------------------------------------------
#if !ANTLR_GC
- (void)dealloc
{
  ANTLR_DESTROY(text);
  [super dealloc];
}
#endif

//--------------------------------------------------------------------
// accessors
-(void)setLine:(int)_line
{
  line = _line;
};

//--------------------------------------------------------------------
-(int)line
{
  return line;
};

//--------------------------------------------------------------------
-(void)setText:(NSString*)_text
{
  ASSIGN(text, _text);
};

//--------------------------------------------------------------------
-(NSString*)text
{
  return text;
};

//--------------------------------------------------------------------
// description
-(NSString*)description
{
  return [NSString stringWithFormat:@"<%@[%i] value=\"%@\" line=%i>",
				   NSStringFromClass([self class]),
				   type,
				   (type == ANTLRToken_EOF_TYPE) ? (id)@"EOF" : (id)text,
				   line];
};

@end
