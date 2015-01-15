//
//  PIFragmentLink.m
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 18/12/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import "PIFragmentLink.h"

#import "PIWithFragments.h"

@implementation PIFragmentLinkDocument

@synthesize id = _id;
@synthesize type = _type;
@synthesize tags = _tags;
@synthesize slug = _slug;
@synthesize broken = _broken;

- (PIFragmentLinkDocument *)initWithJson:(id)jsonObject
{
    NSDictionary *jsonDocument = jsonObject[@"document"];
    _id = jsonDocument[@"id"];
    _type = jsonDocument[@"type"];
    NSArray *tagsJson = jsonDocument[@"tags"];
    NSMutableArray *tags = [[NSMutableArray alloc] init];
    for (NSString *tag in tagsJson) {
        [tags addObject:tag];
    }
    _tags = tags;
    _slug = jsonDocument[@"slug"];
    _broken = jsonObject[@"isBroken"];
    
    PIWithFragments *withFragments = [PIWithFragments WithFragmentsWithJson:jsonDocument];
    self.data = [withFragments data];

    return self;
}

@end

@implementation PIFragmentLinkWeb

@synthesize url = _url;
@synthesize contentType = _contentType;

- (PIFragmentLinkWeb *)initWithJson:(id)jsonObject
{
    id url = jsonObject[@"prev_page"];
    _url = url != [NSNull null] ? [NSURL URLWithString:url] : nil;
    _contentType = nil;
    return self;
}

@end
