//
//  Nu-Overrides.h
//  NuGenerator
//
//  Created by Grayson Hansard on 12/29/09.
//  Copyright 2009 From Concentrate Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NuYieldException.h"
// #import "operator.m"



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