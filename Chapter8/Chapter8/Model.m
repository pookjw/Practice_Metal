//
//  Model.m
//  Chapter8
//
//  Created by Jinwoo Kim on 4/29/23.
//

#import "Model.h"

@interface Model ()
@property (copy) NSString *name;
@end

@implementation Model

@synthesize transform = _transform;

- (instancetype)initWithName:(NSString *)name {
    if (self = [self init]) {
        
    }
    
    return self;
}

@end
