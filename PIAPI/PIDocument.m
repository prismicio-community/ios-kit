//
//  PIDocument.m
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 27/11/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import "PIDocument.h"

@implementation PIDocument

@synthesize href = _href;
@synthesize id = _id;
@synthesize slugs = _slugs;
@synthesize tags = _tags;
@synthesize type = _type;

+ (PIDocument *)DocumentWithJson:(id)jsonObject
{
    return [[PIDocument alloc] initWithJson:jsonObject];
}

- (PIDocument *)initWithJson:(id)jsonObject
{
    self = [self init];

    PIWithFragments *withFragments = [PIWithFragments WithFragmentsWithJson:jsonObject];
    self.data = [withFragments data];

    NSString *href = jsonObject[@"href"];
    _href = href ? [NSURL URLWithString:href] : nil;

    _id = jsonObject[@"id"];

    NSMutableArray *slugs = [[NSMutableArray alloc] init];
    NSArray *slugFields = jsonObject[@"slugs"];
    for (NSString *slugField in slugFields) {
        [slugs addObject:slugField];
    }
    _slugs = slugs;

    NSMutableArray *tags = [[NSMutableArray alloc] init];
    NSArray *tagFields = jsonObject[@"tags"];
    for (NSString *tagField in tagFields) {
        [tags addObject:tagField];
    }
    _tags = tags;

    _type = jsonObject[@"type"];

    return self;
}

- (PIFragmentGroup *)getGroup:(NSString*)field
{
    id<PIFragment> fragment = [self get:field];
    if ([fragment isKindOfClass:[PIFragmentGroup class]]) {
        return fragment;
    }
    return nil;
}

@end
