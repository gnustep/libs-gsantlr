/* AST.h
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

#ifndef _ANTLRAST_h_
	#define _ANTLRAST_h_

#define ANTLRDefAST_ 	id<NSObject,ANTLRAST,NSCopying>

#define ANTLRnullAST nil
@class ANTLRASTEnumerator;


@protocol ANTLRAST <NSCopying>
-(id)copyWithZone:(NSZone*)_zone;
-(void)addChild:(ANTLRDefAST_)_ast; // Add a (rightmost) child to this node

-(void)doWorkForFindAll:(NSMutableArray*)v
				 target:(ANTLRDefAST_)target
		   partialMatch:(BOOL)partialMatch;
-(BOOL)equalsList:(ANTLRDefAST_)t;
-(BOOL)equalsListPartial:(ANTLRDefAST_) sub;
-(BOOL)equalsTree:(ANTLRDefAST_)t;
-(BOOL)equalsTreePartial:(ANTLRDefAST_)sub;
-(ANTLRASTEnumerator*)findAll:(ANTLRDefAST_)target;
-(ANTLRASTEnumerator*)findAllPartial:(ANTLRDefAST_) sub;
-(void)removeChildren;
+(void)setVerboseStringConversion:(BOOL)verbose
						withNames:(NSString**) names;

-(BOOL)isEqualToAST:(ANTLRDefAST_)_ast;

// Set/Get the first child of this node; null if no children
-(void)setFirstChild:(ANTLRDefAST_)_child;

-(ANTLRDefAST_)firstChild;

// Set/Get the next sibling in line after this one
-(void)setNextSibling:(ANTLRDefAST_)_next;
-(ANTLRDefAST_)nextSibling;

// Set/Get the token text for this node
-(void)setText:(NSString *)_text;
-(NSString*)text;

// Set/Get the token type for this node
- (void)setTokenType:(ANTLRTokenType)_type;
- (ANTLRTokenType)tokenType;

-(void)setWithToken:(ANTLRDefToken)_token;
-(void)setWithAST:(ANTLRDefAST_)_AST;

-(NSString*)description;
-(NSString*)toString;
-(NSString*)toStringList;
-(NSString*)toStringListWithSiblingSeparator:(NSString*)_siblingSep
							   openSeparator:(NSString*)_openSep
							  closeSeparator:(NSString*)_closeSep;
-(NSString*)toStringTree;
@end

typedef id<NSObject,NSCopying,ANTLRAST>		ANTLRDefAST;


//	The AST Null object; the parsing cursor is set to this when
//		it is found to be null.  This way, we can test the
//		token type of a node without having to have tests for null
//		everywhere.
extern ANTLRDefAST ANTLRASTNULL;


@interface ANTLRAST : NSObject <NSCopying,ANTLRAST>
{
  ANTLRDefAST down;
  ANTLRDefAST right;
};
//-(id)initWithNode:(id)_node;
-(void)dealloc;
-(id)copyWithZone:(NSZone*)_zone;
-(void)addChild:(ANTLRDefAST)_ast; // Add a (rightmost) child to this node
-(BOOL)isEqualToAST:(ANTLRDefAST)_ast;

// Set/Get the first child of this node; null if no children
-(void)setFirstChild:(ANTLRDefAST)_child;

-(ANTLRDefAST)firstChild;

// Set/Get the next sibling in line after this one
-(void)setNextSibling:(ANTLRDefAST)_next;
-(ANTLRDefAST)nextSibling;

// Set/Get the token text for this node
-(void)setText:(NSString *)_text;
-(NSString*)text;

// Set/Get the token type for this node
- (void)setTokenType:(ANTLRTokenType)_type;
- (ANTLRTokenType)tokenType;
-(void)setWithToken:(ANTLRDefToken)_token;
-(void)setWithAST:(ANTLRDefAST)_AST;
-(NSString*)description;
-(NSString*)toString;
-(NSString*)toStringList;
-(NSString*)toStringListWithSiblingSeparator:(NSString*)_siblingSep
							   openSeparator:(NSString*)_openSep
							  closeSeparator:(NSString*)_closeSep;
-(NSString*)toStringTree;
@end

#endif //_ANTLRAST_h_
