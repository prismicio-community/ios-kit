//
//  PIWithFragments.m
//  PIAPI
//
//  Created by Erwan Loisant on 12/01/15.
//  Copyright (c) 2015 Zengularity. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PIWithFragments.h"

@implementation PIWithFragments

@synthesize data = _data;

+ (id <PIFragment>)parseFragment:(id)jsonObject
{
    id <PIFragment> fragment = nil;
    if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        NSString *type = jsonObject[@"type"];
        id <PIFragment> (^selectedCase)() = @{
                                              @"Link.document" : ^{
                                                  return [PIFragmentLinkDocument LinkWithJson:jsonObject[@"value"]];
                                              },
                                              @"Text" : ^{
                                                  return [PIFragmentText TextWithJson:jsonObject];
                                              },
                                              @"Number" : ^{
                                                  return [PIFragmentNumber NumberWithJson:jsonObject];
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
                                              @"Group" : ^{
                                                  return [PIFragmentGroup GroupWithJson:jsonObject];
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

+ (PIWithFragments *)WithFragmentsWithJson:(id)jsonObject
{
    return [[PIWithFragments alloc] initWithJson:jsonObject];
}

- (PIWithFragments *)initWithFragments:(NSDictionary *)data
{
    self = [self init];
    self->_data = data;
    return self;
}

- (PIWithFragments *)initWithJson:(id)jsonObject
{
    self = [self init];
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    NSDictionary *docData = jsonObject[@"data"];
    for (NSString *docName in docData) {
        // 1st loop for free (data's syntax is {"<collection>":{<real-data>}}
        NSDictionary *fieldData = docData[docName];
        for (NSString *fieldName in fieldData) {
            NSDictionary *field = fieldData[fieldName];
            id <PIFragment> fragment = [PIWithFragments parseFragment:field];
            if (fragment != nil) {
                [data setObject:fragment forKey:[NSString stringWithFormat:@"%@.%@", docName, fieldName]];
            }
        }
    }
    self->_data = data;
    
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

- (id<PIFragment>)get:(NSString*)field
{
    id<PIFragment> fragment = self->_data[field];
    return fragment;
}

- (PIFragmentLink *)getLink:(NSString*)field
{
    id<PIFragment> fragment = [self get:field];
    if ([fragment isKindOfClass:[PIFragmentLink class]]) {
        return fragment;
    }
    return nil;
}


@end
