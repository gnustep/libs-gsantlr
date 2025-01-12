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
#include "ANTLRHashString.h"
#include "ANTLRCharScanner.h"

@implementation ANTLRHashString

static int prime = 151;

//--------------------------------------------------------------------
+(id)hashString:(NSString*)_str
		  lexer:(ANTLRCharScanner*)_lexer
{
  return AUTORELEASE([[self alloc] initWithString:_str
								   lexer:_lexer]);
};

//--------------------------------------------------------------------
-(id)initWithLexer:(ANTLRCharScanner *)_lexer
{
  LOGObjectFnStart();
  if ((self = [super init]))
	{
	  lexer = RETAIN(_lexer);
	};
  LOGObjectFnStop();
  return self;
}

//--------------------------------------------------------------------
-(id)initWithBuffer:(unichar*)_buf
			 length:(unsigned int)_length
			  lexer:(ANTLRCharScanner*)_lexer
{  
  LOGObjectFnStart();
  if ((self = [self initWithLexer:_lexer]))
	  [self setBuffer:_buf
			length:_length];
  LOGObjectFnStop();
  return self;
};

//--------------------------------------------------------------------
-(id)initWithString:(NSString*)_str
			  lexer:(ANTLRCharScanner*)_lexer
{
  LOGObjectFnStart();
  if ((self = [self initWithLexer:_lexer]))
	  [self setString:_str];
  LOGObjectFnStop();
  return self;
}

//--------------------------------------------------------------------
#if !ANTLR_GC
-(void)dealloc
{
  ANTLR_FREE(buffer);
  ANTLR_DESTROY(s);
  ANTLR_DESTROY(lexer);
  [super dealloc];
}
#endif

// accessors

//--------------------------------------------------------------------
-(unichar)characterAtIndex:(int)_idx
{
  unichar c;
  LOGObjectFnStart();
  c=s ? [s characterAtIndex:_idx] : buffer[_idx];
  LOGObjectFnStop();
  return c;
};

//--------------------------------------------------------------------
-(unsigned int)length
{
  return s ? [s length] : len;
};

//--------------------------------------------------------------------
-(void)setBuffer:(unichar*)_buf
		  length:(unsigned int)_len
{
  LOGObjectFnStart();
  ANTLR_DESTROY(s);
  ANTLR_FREE(buffer);
  buffer = ANTLR_ALLOC_ATOMIC(sizeof(unichar) * _len);
  memcpy(buffer, _buf, _len * sizeof(unichar));
  len = _len;
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
-(void)setString:(NSString*)_s
{
  LOGObjectFnStart();
  if (s != _s)
	{
	  ANTLR_DESTROY(s);
	  s = [_s copy];
	  ANTLR_FREE(buffer);
	};
  LOGObjectFnStop();
};

//--------------------------------------------------------------------
-(NSString*)stringValue
{
  if (s)
	return s;
  else if (buffer)
	return [NSString stringWithCharacters:buffer
					 length:len];
  else
	return nil;
};

// hashing

//--------------------------------------------------------------------
-(BOOL)isEqual:(id)_object
{
  if (_object == self)
	  return YES;
  else if (!([_object isKindOfClass:[ANTLRHashString class]] ||
        [_object isKindOfClass:[NSString class]]))
	  return NO;
  else
	{
	  ANTLRHashString* str = nil;
	  unsigned l = [self length];

	  if ([_object isKindOfClass:[NSString class]])
		str = AUTORELEASE([[ANTLRHashString alloc] initWithString:_object
											lexer:lexer]);
	  else
		str = _object;
	  
	  if ([str length] != l)
		return NO;
	  else if ([lexer hasCaseSensitiveLiterals])
		{
		  register int i;
		  for (i = 0; i < l; i++)
			  if ([self characterAtIndex:i] != [str characterAtIndex:i])
				return NO;
		}
	  else
		{
		  register int i;
		  for (i = 0; i < l; i++)
			  if ([lexer toLower:[self characterAtIndex:i]] != [lexer toLower:[str characterAtIndex:i]])
				return NO;
		};
	  return YES;
	};
};

//--------------------------------------------------------------------
-(unsigned)hash
{
  register unsigned hashval = 0;
  register unsigned l       = [self length];
  LOGObjectFnStart();
  if ([lexer hasCaseSensitiveLiterals])
	{
	  register unsigned i;  
	  for (i = 0; i < l; i++)
		hashval = hashval * prime + [self characterAtIndex:i];
	}
  else
	{
	  register unsigned i;
	  for (i = 0; i < l; i++)
		hashval = hashval * prime + [lexer toLower:[self characterAtIndex:i]];
	};
  LOGObjectFnStop();
  return hashval;
};

@end
