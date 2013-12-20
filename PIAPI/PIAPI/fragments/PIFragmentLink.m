//
//  PIFragmentLink.m
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 18/12/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import "PIFragmentLink.h"

@interface PIFragmentLinkDocument ()
@property NSString *id;
@property NSString *type;
@property NSArray *tags;
@property NSString *slug;
@property NSString *isBroken;
@end

@implementation PIFragmentLinkDocument

+ (PIFragmentLinkDocument *)LinkWithJson:(id)jsonObject
{
    return [[PIFragmentLinkDocument alloc] initWithJson:jsonObject];
}

- (PIFragmentLinkDocument *)initWithJson:(id)jsonObject
{
    NSDictionary *jsonDocument = jsonObject[@"document"];
    self.id = jsonDocument[@"id"];
    self.type = jsonDocument[@"type"];
    NSArray *tagsJson = jsonDocument[@"tags"];
    NSMutableArray *tags = [[NSMutableArray alloc] init];
    for (NSString *tag in tagsJson) {
        [tags addObject:tag];
    }
    self.tags = _tags;
    self.slug = jsonDocument[@"slug"];
    self.isBroken = jsonObject[@"isBroken"];
    return self;
}

@end

@implementation PIFragmentLink
+ (id <PIFragmentLink>)LinkWithJson:(id)jsonObject
{
    id <PIFragmentLink> link = nil;
    NSString *type = jsonObject[@"type"];
    id <PIFragmentLink> (^selectedCase)() = @{
        @"Link.document" : ^{
            return [PIFragmentLinkDocument LinkWithJson:jsonObject[@"value"]];
        },
    }[type];
    if (selectedCase != nil) {
        link = selectedCase();
    }
    else {
        NSLog(@"Unsupported link type: %@", type);
    }
    return link;
}
@end
