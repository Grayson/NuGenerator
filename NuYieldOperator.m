//
//  NuYieldOperator.m
//  NuGenerator
//
//  Created by Grayson Hansard on 12/24/09.
//  Copyright 2009 From Concentrate Software. All rights reserved.
//

#import "NuYieldOperator.h"

@implementation NuYieldOperator

// This is called from generator.nu to add `yield` as a keyword.  This should be added automatically, though.
+(void)install {
	NuSymbolTable *table = [NuSymbolTable sharedSymbolTable];
	[(NuSymbol *) [[table symbolWithCString:"yield"] retain] setValue:[[[self class] alloc] init]];
}

// When `yield` is encountered, save the yielded value information (cdr and context) and throw an exception.
// All of the other necessary state information will be added by the looping function that processes the exception.
- (id) callWithArguments:(id)cdr context:(NSMutableDictionary *)context {
	NuYieldException *exception = [[NuYieldException new] autorelease];
	exception.cdr = cdr;
	exception.context = context;
	@throw exception;
    return nil; // Never reached.
}

@end
