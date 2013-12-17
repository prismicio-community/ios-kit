//
//  PIDocument.m
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 27/11/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import "PIDocument.h"

#import "PIFragmentText.h"
#import "PIFragmentStructuredText.h"

@interface PIDocument ()
{
    NSMutableDictionary *_data;
    NSURL *_href;
    NSString *_id;
    NSMutableArray *_slugs;
    NSMutableArray *_tags;
    NSString *_type;
}
@end



@implementation PIDocument

+ (id <PIFragment>)parseFragment:(id)jsonObject
{
    id <PIFragment> fragment = nil;
    if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        NSString *type = jsonObject[@"type"];
        id <PIFragment> (^selectedCase)() = @{
            @"Text" : ^{
                return [PIFragmentText textWithJson:jsonObject];
            },
            @"StructuredText" : ^{
                return [PIFragmentStructuredText structuredTextWithJson:jsonObject];
            }
        }[type];
        if (selectedCase != nil) {
            fragment = selectedCase();
        }
    }
    return fragment;
}

+ (PIDocument *)documentWithJson:(id)jsonObject
{
    PIDocument *document = [[PIDocument alloc] init];

    document->_data = [[NSMutableDictionary alloc] init];
    NSDictionary *docData = jsonObject[@"data"];
    for (NSString *docName in docData) {
        // 1st loop for free (data's syntax is {"<collection>":{<real-data>}}
        NSDictionary *data = docData[docName];
        for (NSString *fieldName in data) {
            NSDictionary *field = data[fieldName];
            id <PIFragment> fragment = [PIDocument parseFragment:field];
            if (fragment != nil) {
                [document->_data setObject:fragment forKey:fieldName];
            }
        }
    }

    NSString *href = jsonObject[@"href"];
    document->_href = href ? [NSURL URLWithString:href] : nil;

    document->_id = jsonObject[@"id"];

    document->_slugs = [[NSMutableArray alloc] init];
    NSArray *slugs = jsonObject[@"slugs"];
    for (NSString *slug in slugs) {
        [document->_slugs addObject:slug];
    }

    document->_tags = [[NSMutableArray alloc] init];
    NSArray *tags = jsonObject[@"tags"];
    for (NSString *tag in tags) {
        [document->_tags addObject:tag];
    }

    document->_type = jsonObject[@"type"];

    return document;
}

- (NSMutableDictionary *)data
{
    return _data;
}

- (NSURL *)href
{
    return _href;
}

- (NSString *)id
{
    return _id;
}

- (NSMutableArray *)slugs
{
    return _slugs;
}

- (NSMutableArray *)tags
{
    return _tags;
}

- (NSString *)type
{
    return _type;
}

- (PIFragmentBlockHeading *)firstTitleObject
{
    PIFragmentBlockHeading *res = nil;
    for (NSString *key in _data) {
        id <PIFragment> fragment = _data[key];
        if ([fragment isKindOfClass:[PIFragmentStructuredText class]]) {
            PIFragmentStructuredText *structuredText = fragment;
            PIFragmentBlockHeading *heading = [structuredText firstTitleObject];
            if (res == nil || [res heading] < [heading heading]) {
                res = heading;
            }
        }
    }
    return res;
}

- (NSString *)firstTitle
{
    PIFragmentBlockHeading *heading = [self firstTitleObject];
    if (heading) {
        return [heading text];
    }
    return nil;
}

@end
