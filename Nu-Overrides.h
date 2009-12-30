//
//  Nu-Overrides.h
//  NuGenerator
//
//  Created by Grayson Hansard on 12/29/09.
//  Copyright 2009 From Concentrate Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NuYieldException.h"

/*
	Nu-Overrides.h is a short collection of changes to Nu's looping operators.  Basically, they are copied
	and pasted from operations.m with the addition of the NuYieldException handler.  Also, the initial expression
	evaluation (`id expressions = [cdr cdr];`) has been moved to outside of the loop so that `expressions` is in
	scope for the yield exception.
	
	Only the `for` operator has additional comments since the same basic idea is used in all three.
*/


@interface Nu_for_operator : NuOperator {}
@end

@interface Nu_while_operator : NuOperator {}
@end

@interface Nu_until_operator : NuOperator {}
@end



@interface Nu_for_operator (override)
@end

@interface Nu_while_operator (override)
@end

@interface Nu_until_operator (override)
@end