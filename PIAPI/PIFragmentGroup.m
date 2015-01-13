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
    for (NSDictionary *docData in values) {
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        for (NSString *fieldName in docData) {
            NSDictionary *field = docData[fieldName];
            id <PIFragment> fragment = [PIWithFragments parseFragment:field];
            if (fragment != nil) {
                [data setObject:fragment forKey:fieldName];
            }
        }
        PIWithFragments *groupDoc = [[PIWithFragments alloc] initWithFragments:data];
        [group->_groupDocs addObject:groupDoc];
    }

    return group;
}

- (NSArray *)groupDocs
{
    return _groupDocs;
}

@end

