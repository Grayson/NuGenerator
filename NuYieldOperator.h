//
//  NuYieldOperator.h
//  NuGenerator
//
//  Created by Grayson Hansard on 12/24/09.
//  Copyright 2009 From Concentrate Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NuYieldException.h"

/*
	The NuYieldOperator simply adds a new keyword to the Nu runtime, `yield`.  Whenever `yield` is encountered,
	the NuYieldOperator takes note of the state and throws a NuYieldException.  If this happens inside a looping
	operator (`for`, `while`, or `until`), the exception is returned as a generator.  The generator responds
	to nu-enumeration methods.  When `yield` is encountered while enumerating the generator, the 
	exception/generator stops the loop execution and executes a block with the yielded value.
*/

@interface NuYieldOperator : NuOperator {
}
@end
