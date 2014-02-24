//
//  PIDocument.m
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 27/11/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import "PIDocument.h"

@implementation PIDocument

@synthesize data = _data;
@synthesize href = _href;
@synthesize id = _id;
@synthesize slugs = _slugs;
@synthesize tags = _tags;
@synthesize type = _type;

+ (id <PIFragment>)parseFragment:(id)jsonObject
{
    id <PIFragment> fragment = nil;
    if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        NSString *type = jsonObject[@"type"];
        id <PIFragment> (^selectedCase)() = @{
            @"Text" : ^{
                return [PIFragmentText TextWithJson:jsonObject];
            },
            @"StructuredText" : ^{
                return [PIFragmentStructuredText StructuredTextWithJson:jsonObject];
            },
            @"Image" : ^{
                return [PIFragmentImage imageWithJson:jsonObject[@"value"]];
            },
            @"Select" : ^{
                return [PIFragmentSelect SelectWithJson:jsonObject];
            },
            @"Color" : ^{
                return [PIFragmentColor ColorWithJson:jsonObject];
            },
            @"Date" : ^{
                return [PIFragmentDate DateWithJson:jsonObject];
            },
        }[type];
        if (selectedCase != nil) {
            fragment = selectedCase();
        }
        else {
            NSLog(@"Unsupported fragment type: %@", type);
        }
    }
    return fragment;
}

+ (PIDocument *)DocumentWithJson:(id)jsonObject
{
    return [[PIDocument alloc] initWithJson:jsonObject];
}

- (PIDocument *)initWithJson:(id)jsonObject
{
    self = [self init];

    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    NSDictionary *docData = jsonObject[@"data"];
    for (NSString *docName in docData) {
        // 1st loop for free (data's syntax is {"<collection>":{<real-data>}}
        NSDictionary *fieldData = docData[docName];
        for (NSString *fieldName in fieldData) {
            NSDictionary *field = fieldData[fieldName];
            id <PIFragment> fragment = [PIDocument parseFragment:field];
            if (fragment != nil) {
                [data setObject:fragment forKey:fieldName];
            }
        }
    }
    _data = data;

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

- (NSAttributedString *)firstTitleFormatted
{
    PIFragmentBlockHeading *heading = [self firstTitleObject];
    if (heading) {
        return [heading formattedText];
    }
    return nil;
}

- (NSString *)firstTitle
{
    PIFragmentBlockHeading *heading = [self firstTitleObject];
    if (heading) {
        return [heading text];
    }
    return nil;
}

- (PIFragmentBlockParagraph *)firstParagraphObject
{
    for (NSString *key in _data) {
        id <PIFragment> fragment = _data[key];
        if ([fragment isKindOfClass:[PIFragmentStructuredText class]]) {
            PIFragmentStructuredText *structuredText = fragment;
            PIFragmentBlockParagraph *paragraph = [structuredText firstParagraphObject];
            if (paragraph != nil) {
                return paragraph;
            }
        }
    }
    return nil;
}

- (NSAttributedString *)firstParagraphFormatted
{
    PIFragmentBlockParagraph *fragment = [self firstParagraphObject];
    if (fragment) {
        return [fragment formattedText];
    }
    return nil;
}

- (NSString *)firstParagraph
{
    PIFragmentBlockParagraph *fragment = [self firstParagraphObject];
    if (fragment) {
        return [fragment text];
    }
    return nil;
}

@end
