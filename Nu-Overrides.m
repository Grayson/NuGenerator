//
//  Nu-Overrides.m
//  NuGenerator
//
//  Created by Grayson Hansard on 12/29/09.
//  Copyright 2009 From Concentrate Software. All rights reserved.
//

#import "Nu-Overrides.h"


@implementation Nu_for_operator (override)
- (id) callWithArguments:(id)cdr context:(NSMutableDictionary *)context
{
    id result = Nu__null;
    id controls = [cdr car];                      // this could use some error checking!
    id loopinit = [controls car];
    id looptest = [[controls cdr] car];
    id loopincr = [[[controls cdr] cdr] car];
    // initialize the loop
    [loopinit evalWithContext:context];
    // evaluate the loop condition
    id test = [looptest evalWithContext:context];
    id expressions = [cdr cdr]; // <---- This has been moved to before the loop so that it's in scope for the yield exception.
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
			// Most of this probably isn't particularly useful, but it's an amalgamation of various attempts.
			
			// Basically, we want to save the current state when the yield happened (loopContext and loopRemaining)
			// as well as information for re-creating the loop later (loopArgs and loopOperator).
			// This returns the NuYieldException which will be our generator.
			exception.loopContext = context;
			exception.loopArgs = cdr;
			exception.loopOperator = self;
			exception.loopRemaining = [expressions cdr];
			
			return exception;
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

@end


@implementation Nu_while_operator (override)
- (id) callWithArguments:(id)cdr context:(NSMutableDictionary *)context
{
    id result = Nu__null;
    id test = [[cdr car] evalWithContext:context];
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
			exception.loopContext = context;
			exception.loopArgs = cdr;
			exception.loopOperator = self;
			exception.loopRemaining = [expressions cdr];
			
			return exception;
		}
        @catch (id exception) {
            @throw(exception);
        }
        test = [[cdr car] evalWithContext:context];
    }
    return result;
}

@end

@implementation Nu_until_operator (override)
- (id) callWithArguments:(id)cdr context:(NSMutableDictionary *)context
{
    id result = Nu__null;
    id test = [[cdr car] evalWithContext:context];
    id expressions = [cdr cdr];
    while (!nu_valueIsTrue(test)) {
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
			exception.loopContext = context;
			exception.loopArgs = cdr;
			exception.loopOperator = self;
			exception.loopRemaining = [expressions cdr];
			
			return exception;
		}
        @catch (id exception) {
            @throw(exception);
        }
        test = [[cdr car] evalWithContext:context];
    }
    return result;
}

@end