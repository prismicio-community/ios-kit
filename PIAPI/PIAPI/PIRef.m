//
//  PIRef.m
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 28/11/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import "PIRef.h"

@implementation PIRef

@synthesize ref = _ref;
@synthesize label = _label;
@synthesize masterRef = _masterRef;

+ (PIRef *) RefWithJson:(id)jsonObject
{
    return [[PIRef alloc] initWithJson:jsonObject];
}

- (PIRef *) initWithJson:(id)jsonObject
{
    if ((self = [self init]) == nil)
        return nil;
    _ref = jsonObject[@"ref"];
    _label = jsonObject[@"label"];
    NSNumber *masterRef = jsonObject[@"isMasterRef"];
    _masterRef = masterRef && masterRef.boolValue;
    return self;
}

@end
