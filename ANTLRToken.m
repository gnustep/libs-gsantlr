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
#include "ANTLRToken.h"


@implementation ANTLRToken

static ANTLRToken* badToken=nil;

//--------------------------------------------------------------------
+(void)initialize
{
  [super initialize];
  if (!badToken)
    badToken = [[ANTLRToken alloc] initWithTokenType:ANTLRToken_INVALID_TYPE
								   text:@"<no text>"];
}

//--------------------------------------------------------------------
#if !ANTLR_GC
+(void)dealloc
{
  ANTLR_DESTROY(badToken);
  [super dealloc];
};
#endif
//--------------------------------------------------------------------
+ (id)badToken
{
  return badToken;
}

//--------------------------------------------------------------------
+(id)token
{
  return AUTORELEASE([self new]);
}

//--------------------------------------------------------------------
+(id)tokenWithTokenType:(ANTLRTokenType)_type
{
  return AUTORELEASE([[self alloc] initWithTokenType:_type]);
}

//--------------------------------------------------------------------
+(id)tokenWithTokenType:(ANTLRTokenType)_type
					text:(NSString *)_text
{
  return AUTORELEASE([[self alloc] initWithTokenType:_type
								   text:_text]);
};

//--------------------------------------------------------------------
-(id)init
{
  return [self initWithTokenType:ANTLRToken_INVALID_TYPE
			   text:@"<no text>"];
};

//--------------------------------------------------------------------
-(id)initWithTokenType:(ANTLRTokenType)_type
{
  return [self initWithTokenType:_type
			   text:@"<no text>"];
};

- (id)initWithTokenType:(ANTLRTokenType)_type
				   text:(NSString *)_text
{
  LOGObjectFnStart();
  if ((self = [super init]))
	{
	  [self setTokenType:_type];
	  [self setText:_text];
	};
  LOGObjectFnStop();
  return self;
}

//--------------------------------------------------------------------
#if !ANTLR_GC
- (void)dealloc
{
  type = ANTLRToken_INVALID_TYPE;
  [super dealloc];
}
#endif

//--------------------------------------------------------------------
// accessors

//--------------------------------------------------------------------
- (void)setColumn:(int)_column
{
};

//--------------------------------------------------------------------
-(int)column
{
  return 0;
};

//--------------------------------------------------------------------
- (void)setLine:(int)_line
{
};

//--------------------------------------------------------------------
-(int)line
{
  return 0;
};

//--------------------------------------------------------------------
-(void)setText:(NSString *)_text
{
};

//--------------------------------------------------------------------
-(NSString*)text
{
  return @"<no text>";
};

//--------------------------------------------------------------------
-(void)setTokenType:(ANTLRTokenType)_type
{
  LOGObjectFnStart();
  type = _type;
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
-(ANTLRTokenType)tokenType
{
  return type;
};

//--------------------------------------------------------------------
-(ANTLRTokenType)getTokenType 
{
  return [self tokenType];
};

//--------------------------------------------------------------------
// description
- (NSString*)description
{
  return [self stringValue];
}

//--------------------------------------------------------------------
-(NSString *)stringValue
{
  return [NSString stringWithFormat:@"<%@[%i] value=\"%@\">",
				   NSStringFromClass([self class]), type,
				   (type == ANTLRToken_EOF_TYPE) ? (id)@"EOF" : (id)[self text]];
};

@end
