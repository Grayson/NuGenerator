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

enum {
	NuForLoopType,
	NuWhileLoopType,
	NuUntilLoopType,
};

@interface NuYieldException : NSException {
	id _cursor;
	id _cdr;
	NSMutableDictionary *_context;
	BOOL _isFirstRun;

	id _loopOperator;
	NSMutableDictionary *_loopContext;
	id _loopArgs;
	id _loopRemaining;
}
@property (retain) id cursor;
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
