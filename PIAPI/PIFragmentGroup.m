//
//  PIFragmentGroup.m
//  PIAPI
//
//  Created by Erwan Loisant on 12/01/15.
//  Copyright (c) 2015 Zengularity. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PIFragmentGroup.h"

@interface PIFragmentGroup () {
    NSMutableArray *_groupDocs;
}
@end

@implementation PIFragmentGroup

@synthesize groupDocs = _groupDocs;

+ (PIFragmentGroup *)GroupWithJson:(id)jsonObject
{
    PIFragmentGroup *group = [[PIFragmentGroup alloc] init];
    group->_groupDocs =  [[NSMutableArray alloc] init];

    NSArray *values = jsonObject[@"value"];
    for (NSDictionary *jsonDoc in values) {
        PIWithFragments *groupDoc = [PIWithFragments WithFragmentsWithJson:jsonDoc];
        if (groupDoc != nil) {
            [group->_groupDocs addObject:groupDoc];
        }
    }

    return group;
}

- (NSArray *)groupDocs
{
    return _groupDocs;
}

@end

