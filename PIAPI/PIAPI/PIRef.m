//
//  PIRef.m
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 28/11/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import "PIRef.h"

@interface PIRef ()
{
    NSString *_ref;
    NSString *_label;
    BOOL _isMasterRef;
}
@end

@implementation PIRef

+ (PIRef *) refWithJson:(NSDictionary *)jsonObject
{
    PIRef *ref = [[PIRef alloc] init];
    ref->_ref = jsonObject[@"ref"];
    ref->_label = jsonObject[@"label"];
    NSNumber *isMasterRef = jsonObject[@"isMasterRef"];
    ref->_isMasterRef = isMasterRef && isMasterRef.boolValue;
    return ref;
}

- (NSString *) ref
{
    return _ref;
}

- (NSString *) label
{
    return _label;
}

- (BOOL) isMasterRef
{
    return _isMasterRef;
}

@end
