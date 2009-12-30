//
//  NuYieldException.m
//  NuGenerator
//
//  Created by Grayson Hansard on 12/25/09.
//  Copyright 2009 From Concentrate Software. All rights reserved.
//

#import "NuYieldException.h"
#import "Nu-Overrides.h"


@implementation NuYieldException
@synthesize cursor = _cursor;
@synthesize cdr = _cdr;
@synthesize context = _context;

@synthesize loopOperator = _loopOperator;
@synthesize loopContext = _loopContext;
@synthesize loopArgs = _loopArgs;
@synthesize loopRemaining = _loopRemaining;

- (id)init
{
	self = [super initWithName:@"NuYieldException" reason:@"A yield operator was evaluated" userInfo:nil];
	if (!self) return nil;
	
	_isFirstRun = YES;
	
	return self;
}

- (NSArray *)allObjects {
	NSMutableArray *array = [NSMutableArray array];
	id obj = [self nextObject];
	while (obj) {
		[array addObject:obj];
		obj = [self nextObject];
	}
	return array;
}

- (id)objectEnumerator { return self; }

- (id)nextObject {
	if (_isFirstRun) {
		_isFirstRun = NO;
		return [self.cdr evalWithContext:self.context];
	}
	// Finish the last iteration
	[self finishIteration];
	
	// Iterate
	id returnValue = nil;
	if ([self.loopOperator isKindOfClass:[Nu_for_operator class]])
		returnValue = [self forLoopWithArguments:self.loopArgs context:self.loopContext];
	else if ([self.loopOperator isKindOfClass:[Nu_while_operator class]])
		returnValue = [self whileOrUntilLoopWithArguments:self.loopArgs context:self.loopContext isWhileLoop:YES];
	else if ([self.loopOperator isKindOfClass:[Nu_until_operator class]])
		returnValue = [self whileOrUntilLoopWithArguments:self.loopArgs context:self.loopContext isWhileLoop:NO];
	
	return returnValue;
}

- (id)finishIteration {
	id remaining = self.loopRemaining;
	id result = nil;
	@try {
		while (remaining && remaining != Nu__null) {
			result = [[remaining car] evalWithContext:self.loopContext];
			remaining = [remaining cdr];
		}
	}
	@catch (NSException *exception) {
		@throw exception;
	}
	return result;
}

- (id) each:(id) callable
{	
    id args = [[NuCell alloc] init];
    if ([callable respondsToSelector:@selector(evalWithArguments:context:)]) {
        id object;
        while ((object = [self nextObject]) && ![object isKindOfClass:[NSNull class]]) {
            @try
            {
                [args setCar:object];
                [callable evalWithArguments:args context:nil];
            }
            @catch (NuBreakException *exception) {
                break;
            }
            @catch (NuContinueException *exception) {
                // do nothing, just continue with the next loop iteration
            }
            @catch (id exception) {
                @throw(exception);
            }
        }
    }
    [args release];
    return self;
}

- (id) forLoopWithArguments:(id)cdr context:(NSMutableDictionary *)context
{
    id result = Nu__null;
    id controls = [cdr car];                      // this could use some error checking!
    id looptest = [[controls cdr] car];
    id loopincr = [[[controls cdr] cdr] car];

	// Loop was initialized at original for loop call.
    // id loopinit = [controls car];
    // [loopinit evalWithContext:context];

    // evaluate the loop condition
    id test = [looptest evalWithContext:context];
    id expressions = [cdr cdr];
    while (nu_valueIsTrue(test)) {
        @try
        {
            while (expressions && (expressions != Nu__null)) {
                result = [[expressions car] evalWithContext:context];
                expressions = [expressions cdr];
            }
        }
        @catch (NuBreakException *exception) {
            break;
        }
        @catch (NuContinueException *exception) {
            // do nothing, just continue with the next loop iteration
        }
		@catch (NuYieldException *exception) {
			[loopincr evalWithContext:context];
			self.loopContext = context;
			self.loopRemaining = [expressions cdr];
			result = [exception.cdr evalWithContext:self.loopContext];
			break;

		}
        @catch (id exception) {
            @throw(exception);
        }
        // perform the end of loop increment step
        [loopincr evalWithContext:context];
        // evaluate the loop condition
        test = [looptest evalWithContext:context];
    }
    return result;
}

- (id) whileOrUntilLoopWithArguments:(id)cdr context:(NSMutableDictionary *)context isWhileLoop:(BOOL)isWhileLoop
{
    id result = Nu__null;
    id test = [[cdr car] evalWithContext:context];
    id expressions = [cdr cdr];
    while (nu_valueIsTrue(test) == isWhileLoop) {
        @try
        {
            while (expressions && (expressions != Nu__null)) {
                result = [[expressions car] evalWithContext:context];
                expressions = [expressions cdr];
            }
        }
        @catch (NuBreakException *exception) {
            break;
        }
        @catch (NuContinueException *exception) {
            // do nothing, just continue with the next loop iteration
        }
		@catch (NuYieldException *exception) {
			result = [exception.cdr evalWithContext:context];
			exception.loopRemaining = [expressions cdr];
			break;
		}
        @catch (id exception) {
            @throw(exception);
        }
        test = [[cdr car] evalWithContext:context];
    }
    return result;
}


@end
