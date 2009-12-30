//
//  NuYieldOperator.h
//  NuGenerator
//
//  Created by Grayson Hansard on 12/24/09.
//  Copyright 2009 From Concentrate Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NuYieldException.h"

@interface NuYieldOperator : NuOperator {
}
@end

@interface NuReturnException (x)
- (id) initWithValue:(id) v;
@end
