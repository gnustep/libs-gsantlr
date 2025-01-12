/* ANTLRMismatchedTokenException.m
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
#include "ANTLRMismatchedTokenException.h"
#include "ANTLRBitSet.h"

@implementation ANTLRMismatchedTokenException

//--------------------------------------------------------------------
+(void)raiseWithTokenNames:(NSString**)_tokenNames
			 expectedRange:(ANTLRTokenType)_lower:(ANTLRTokenType)_upper
					   AST:(ANTLRDefAST)_ast
				  matchNot:(BOOL)_flag
{
  id exception=[[ANTLRMismatchedTokenException alloc]initWithTokenNames:_tokenNames
													 expectedRange:_lower:_upper
													 AST:_ast
													 matchNot:_flag];
  [exception raise];
};


//--------------------------------------------------------------------
+(void)raiseWithTokenNames:(NSString**)_tokenNames
		 expectedTokenType:(ANTLRTokenType)_tokenType
					   AST:(ANTLRDefAST)_ast
				  matchNot:(BOOL)_flag
{
  id exception=[[ANTLRMismatchedTokenException alloc]initWithTokenNames:_tokenNames
													 expectedTokenType:_tokenType
													 AST:_ast
													 matchNot:_flag];
  [exception raise];
};


//--------------------------------------------------------------------
+(void)raiseWithTokenNames:(NSString**)_tokenNames
	   expectedTokenBitSet:(ANTLRBitSet*)_set
					   AST:(ANTLRDefAST)_ast
				  matchNot:(BOOL)_flag
{
  id exception=[[ANTLRMismatchedTokenException alloc]initWithTokenNames:_tokenNames
													 expectedTokenBitSet:_set
													 AST:_ast
													 matchNot:_flag];
  [exception raise];
};


//--------------------------------------------------------------------
- (id)initWithTokenNames:(NSString **)_tokenNames
		   expectedRange:(ANTLRTokenType)_lower:(ANTLRTokenType)_upper
					 AST:(ANTLRDefAST)_ast
				matchNot:(BOOL)_flag
{
  if ((self = [self initWithName:@"ANTLRMismatchedTokenException"
					reason:@"Mismatched Token"
					userInfo:nil]))
	{
	  ASSIGN(ast, _ast);
	  tokenNames   = _tokenNames;
	  expecting    = _lower;
	  upper        = _upper;
	  mismatchType = _flag ? ANTLRMismatchTokenType_NOT_TOKEN : ANTLRMismatchTokenType_TOKEN;
	  if (ast)
		ASSIGN(tokenText,[ast text]);
	  else
		tokenText=@"<empty tree>";
	};
  return self;
}


//--------------------------------------------------------------------
- (id)initWithTokenNames:(NSString **)_tokenNames
	   expectedTokenType:(ANTLRTokenType)_tokenType
					 AST:(ANTLRDefAST)_ast
				matchNot:(BOOL)_flag
{
  if ((self = [self initWithName:@"ANTLRMismatchedTokenException"
					reason:@"Mismatched Token"
					userInfo:nil]))
	{
	  ASSIGN(ast, _ast);
	  tokenNames   = _tokenNames;
	  expecting    = _tokenType;
	  mismatchType = _flag ? ANTLRMismatchTokenType_NOT_TOKEN : ANTLRMismatchTokenType_TOKEN;
	  if (ast)
		ASSIGN(tokenText,[ast text]);
	  else
		tokenText=@"<empty tree>";
	};
  return self;
};
//--------------------------------------------------------------------
- (id)initWithTokenNames:(NSString**)_tokenNames
	 expectedTokenBitSet:(ANTLRBitSet*)_set
					 AST:(ANTLRDefAST)_ast
				matchNot:(BOOL)_flag
{
  if ((self = [self initWithName:@"ANTLRMismatchedTokenException"
					reason:@"Mismatched Token"
					userInfo:nil]))
	{
	  ASSIGN(ast, _ast);
	  tokenNames   = _tokenNames;
	  ASSIGN(set, _set);
	  mismatchType = _flag ? ANTLRMismatchTokenType_NOT_TOKEN : ANTLRMismatchTokenType_TOKEN;
	  if (ast)
		ASSIGN(tokenText,[ast text]);
	  else
		tokenText=@"<empty tree>";
	};
  return self;
};

//--------------------------------------------------------------------
+(void)raiseWithTokenNames:(NSString**)_tokenNames
		 expectedTokenType:(ANTLRTokenType)_tokenType
					 token:(ANTLRDefToken)_token
				  matchNot:(BOOL)_flag
{
  id exception=[[ANTLRMismatchedTokenException alloc]initWithTokenNames:_tokenNames
													 expectedTokenType:_tokenType
													 token:_token
													 matchNot:_flag];
  [exception raise];
};

//--------------------------------------------------------------------
+(void)raiseWithTokenNames:(NSString **)_tokenNames
	   expectedTokenBitSet:(ANTLRBitSet *)_set
					 token:(ANTLRDefToken)_token
				  matchNot:(BOOL)_flag
{
  id exception=[[ANTLRMismatchedTokenException alloc]initWithTokenNames:_tokenNames
													 expectedTokenBitSet:_set
													 token:_token
													 matchNot:_flag];
  [exception raise];
};

//--------------------------------------------------------------------
+(void)raiseWithTokenNames:(NSString **)_tokenNames
			 expectedRange:(ANTLRTokenType)_lower:(ANTLRTokenType)_upper
					 token:(ANTLRDefToken)_token
				  matchNot:(BOOL)_flag
{
  id exception=[[ANTLRMismatchedTokenException alloc]initWithTokenNames:(NSString **)_tokenNames
													 expectedRange:_lower:_upper
													 token:_token
													 matchNot:_flag];
  [exception raise];
};

//--------------------------------------------------------------------
-(id)initWithTokenNames:(NSString**)_tokenNames
	  expectedTokenType:(ANTLRTokenType)_tokenType
				  token:(ANTLRDefToken)_token
			   matchNot:(BOOL)_flag
{
  if ((self = [self initWithName:@"ANTLRMismatchedTokenException"
					reason:@"Mismatched Token"
					userInfo:nil]))
	{
	  ASSIGN(token, _token);
	  tokenNames   = _tokenNames;
	  expecting    = _tokenType;
	  mismatchType = _flag ? ANTLRMismatchTokenType_NOT_TOKEN : ANTLRMismatchTokenType_TOKEN;
	  ASSIGN(tokenText,[token text]);
	};
  return self;
}

//--------------------------------------------------------------------
-(id)initWithTokenNames:(NSString**)_tokenNames
	expectedTokenBitSet:(ANTLRBitSet*)_set
				  token:(ANTLRDefToken)_token
			   matchNot:(BOOL)_flag
{
  if ((self = [self initWithName:@"ANTLRMismatchedTokenException"
					reason:@"Mismatched Token"
					userInfo:nil]))
	{
	  ASSIGN(token, _token);
	  ASSIGN(set,   _set);
	  tokenNames   = _tokenNames;
	  mismatchType = _flag ? ANTLRMismatchTokenType_NOT_SET : ANTLRMismatchTokenType_SET;
	  ASSIGN(tokenText,[token text]);
	};
  return self;
}

//--------------------------------------------------------------------
-(id)initWithTokenNames:(NSString **)_tokenNames
		  expectedRange:(ANTLRTokenType)_lower:(ANTLRTokenType)_upper
				  token:(ANTLRDefToken)_token
			   matchNot:(BOOL)_flag
{  
  if ((self = [self initWithName:@"ANTLRMismatchedTokenException"
					reason:@"Mismatched Token"
					userInfo:nil]))
	{
	  ASSIGN(token, _token);
	  tokenNames   = _tokenNames;
	  expecting    = _lower;
	  upper        = _upper;
	  mismatchType = _flag ? ANTLRMismatchTokenType_NOT_RANGE : ANTLRMismatchTokenType_RANGE;
	  ASSIGN(tokenText,[token text]);
	};
  return self;
};

//--------------------------------------------------------------------
#if !ANTLR_GC
- (void)dealloc
{
  ANTLR_DESTROY(set);
  ANTLR_DESTROY(token);
  ANTLR_DESTROY(ast);
  ANTLR_DESTROY(tokenText);
  tokenNames = NULL;
  [super dealloc];
};
#endif

//--------------------------------------------------------------------
// accessors
-(NSString *)tokenName:(ANTLRTokenType)_tokenType
{
  if (_tokenType == ANTLRToken_INVALID_TYPE)
    return @"<Set of tokens>";
  else if (_tokenType < 0)
    return [NSString stringWithFormat:@"<%i>", _tokenType];
  else
    return tokenNames[_tokenType];
}

//--------------------------------------------------------------------
-(NSString*)description
{
  NSString* s = token ? [NSString stringWithFormat:@"line(%i), ",[token line]] : @"";
  switch (mismatchType)
	{
	case ANTLRMismatchTokenType_TOKEN:
	  s = [s stringByAppendingFormat:@"expecting %@, found '%@'",
			 [self tokenName:expecting],
			 tokenText];
	  break;
	case ANTLRMismatchTokenType_NOT_TOKEN:
	  s = [s stringByAppendingFormat:@"expecting anything but %@; got it anyway",
			 [self tokenName:expecting]];
	  break;
	case ANTLRMismatchTokenType_RANGE:
	  s = [s stringByAppendingFormat:@"expecting token in range: %@..%@, found '%@'",
			 [self tokenName:expecting],
			 [self tokenName:upper],
			 tokenText];
	  break;
	case ANTLRMismatchTokenType_NOT_RANGE:
	  s = [s stringByAppendingFormat:@"expecting token NOT in range: %@..%@, found '%@'",
			 [self tokenName:expecting],
			 [self tokenName:upper],
			 tokenText];
	  break;
	case ANTLRMismatchTokenType_SET:
	case ANTLRMismatchTokenType_NOT_SET:
	  {
		NSArray* elems=[set toArray];
		int i=0;
		s = [s stringByAppendingFormat:@"expecting %s one of (",
			   (mismatchType == ANTLRMismatchTokenType_NOT_SET ? "NOT " : "")];
		for (i=0;i<[elems count];i++)
			s = [s stringByAppendingFormat:@" %@",
				   [self tokenName:[[elems objectAtIndex:i] intValue]]];
		s = [s stringByAppendingFormat:@"), found '%@'",
			   tokenText];
	  };
	  break;
	default :
	  s = [super description];
	  break;
	};
  return s;
};

@end
