//
//  NuYieldOperator.m
//  NuGenerator
//
//  Created by Grayson Hansard on 12/24/09.
//  Copyright 2009 From Concentrate Software. All rights reserved.
//

#import "NuYieldOperator.h"

@implementation NuParser(x)
-(id)current { return current; }
@end


@implementation NuYieldOperator

+(void)install {
	NSLog(@"%s", _cmd);
	NuSymbolTable *table = [NuSymbolTable sharedSymbolTable];
	[(NuSymbol *) [[table symbolWithCString:"yield"] retain] setValue:[[[self class] alloc] init]];
}

- (void)dealloc
{
	[super dealloc];
}

- (id) callWithArguments:(id)cdr context:(NSMutableDictionary *)context {
	NuYieldException *exception = [[NuYieldException new] autorelease];
	exception.cdr = cdr;
	exception.context = context;
	@throw exception;
    return nil; // Never reached.
}

@end
