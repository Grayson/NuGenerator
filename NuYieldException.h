//
//  NuYieldException.h
//  NuGenerator
//
//  Created by Grayson Hansard on 12/25/09.
//  Copyright 2009 From Concentrate Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "operator.h"
#import "nuinternals.h"
#import "symbol.h"
#import "cell.h"
#import "enumerable.h"
#import "parser.h"

/*
	NuYieldException is both an exception and a generator.  This is probably bad design, but I was lazy and these
	features can be separated later.
	
	Basically, the exception part is merely used by NuYieldOperator to throw a specific type of exception to which
	looping operators add state information.
	
	As a generator, this excception responds to nu-enumeration methods.  For each iteration, the currently yielded
	value is passed to a block.  After the block executes, the looping operator finishes with the remainder 
	following the `yield` and then continues interating until yield is  encountered again.  At this point, the 
	block is executed with the yielded value and the iteration continues until the loop exits or a Nu__null value
	 is returned (although the whole null value thing may need to be tweaked).
*/


@interface NuYieldException : NSException {
	id _cdr;
	NSMutableDictionary *_context;
	BOOL _isFirstRun;

	id _loopOperator;
	NSMutableDictionary *_loopContext;
	id _loopArgs;
	id _loopRemaining;
}
@property (retain) id cdr;
@property (retain) NSMutableDictionary *context;

@property (retain) id loopOperator;
@property (retain) NSMutableDictionary *loopContext;
@property (retain) id loopArgs;
@property (retain) id loopRemaining;

- (id)nextObject;
- (id)allObjects;
- (id) each:(id) callable;
- (id)finishIteration;

- (id) forLoopWithArguments:(id)cdr context:(NSMutableDictionary *)context;
- (id) whileOrUntilLoopWithArguments:(id)cdr context:(NSMutableDictionary *)context isWhileLoop:(BOOL)isWhileLoop;

@end
