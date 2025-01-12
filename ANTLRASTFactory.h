/* ASTFactory.h
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

#ifndef _ANTLRASTFactory_h_
	#define _ANTLRASTFactory_h_

#include <ANTLRAST.h>
#include <ANTLRASTPair.h>
#include <ANTLRToken.h>


@protocol ANTLRASTFactory
-(void)setASTNodeType:(NSString*)_nodeType;

//	Add a child to the current AST
-(void)addASTChild:(ANTLRDefAST)_AST
				in:(ANTLRASTPair*)_ASTPair;

//	Create a new empty AST node; if the user did not specify
//		an AST node type, then create a default one: CommonAST.
-(ANTLRDefAST)create;
-(ANTLRDefAST)create:(id<NSObject>)_unkown;

-(ANTLRDefAST)createWithTokenType:(ANTLRTokenType)_token;

-(ANTLRDefAST)createWithTokenType:(ANTLRTokenType)_token
							 text:(NSString*)_text;

//	Create a new empty AST node; if the user did not specify
//		an AST node type, then create a default one: CommonAST.
-(ANTLRDefAST)createWithToken:(ANTLRDefToken)_token;
-(ANTLRDefAST)createWithAST:(ANTLRDefAST)_AST;

-(void)makeASTRoot:(ANTLRDefAST)_AST
				in:(ANTLRASTPair*)_ASTPair;

//	Copy a single node.  clone() is not used because
//		we want to return an AST not a plain object...a type
//		safety issue.  Further, we want to have all AST node
//		creation go through the factory so creation can be
//		tracked.  Returns null if t is null.
-(ANTLRDefAST)dup:(ANTLRDefAST)_AST;

//	Duplicate tree including siblings of root.
-(ANTLRDefAST)dupList:(ANTLRDefAST)t;


//	Duplicate a tree, assuming this is a root node of a tree--
//		duplicate that node and what's below; ignore siblings of root node.
 -(ANTLRDefAST)dupTree:(ANTLRDefAST)_AST;

//	Make a tree from a list of nodes.  The first element in the
//		array is the root.  If the root is null, then the tree is
//		a simple list not a tree.  Handles null children nodes correctly.
//		For example, build(a, b, null, c) yields tree (a b c).  build(null,a,b)
//		yields tree (nil a b).
-(ANTLRDefAST)make:(NSArray*)nodes;

@end

typedef id<NSObject,ANTLRASTFactory>	ANTLRDefASTFactory;

@interface ANTLRASTFactory: NSObject <ANTLRASTFactory>
{
  NSString* nodeType;
  Class nodeTypeClass;
};

-(void)setASTNodeType:(NSString*)_nodeType;

//	Add a child to the current AST
-(void)addASTChild:(ANTLRDefAST)_AST
				in:(ANTLRASTPair*)_ASTPair;

//	Create a new empty AST node; if the user did not specify
//		an AST node type, then create a default one: CommonAST.
-(ANTLRDefAST)create;
-(ANTLRDefAST)createWithTokenType:(ANTLRTokenType)_token;

-(ANTLRDefAST)createWithTokenType:(ANTLRTokenType)_token
							 text:(NSString*)_text;

//	Create a new empty AST node; if the user did not specify
//		an AST node type, then create a default one: CommonAST.
-(ANTLRDefAST)createWithToken:(ANTLRDefToken)_token;
-(ANTLRDefAST)createWithAST:(ANTLRDefAST)_AST;

-(void)makeASTRoot:(ANTLRDefAST)_AST
				in:(ANTLRASTPair*)_ASTPair;

//	Copy a single node.  clone() is not used because
//		we want to return an AST not a plain object...a type
//		safety issue.  Further, we want to have all AST node
//		creation go through the factory so creation can be
//		tracked.  Returns null if t is null.
-(ANTLRDefAST)dup:(ANTLRDefAST)_AST;

//	Duplicate tree including siblings of root.
-(ANTLRDefAST)dupList:(ANTLRDefAST)t;


//	Duplicate a tree, assuming this is a root node of a tree--
//		duplicate that node and what's below; ignore siblings of root node.
 -(ANTLRDefAST)dupTree:(ANTLRDefAST)_AST;

//	Make a tree from a list of nodes.  The first element in the
//		array is the root.  If the root is null, then the tree is
//		a simple list not a tree.  Handles null children nodes correctly.
//		For example, build(a, b, null, c) yields tree (a b c).  build(null,a,b)
//		yields tree (nil a b).
-(ANTLRDefAST)make:(NSArray*)nodes;

@end

#endif //_ANTLRASTFactory_h_
