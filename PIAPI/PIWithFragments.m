//
//  PIWithFragments.m
//  PIAPI
//
//  Created by Erwan Loisant on 12/01/15.
//  Copyright (c) 2015 Zengularity. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PIWithFragments.h"
#import "PIFragment.h"
#import "PIFragmentText.h"
#import "PIFragmentLink.h"
#import "PIFragmentStructuredText.h"
#import "PIFragmentImage.h"
#import "PIFragmentNumber.h"
#import "PIFragmentSelect.h"
#import "PIFragmentColor.h"
#import "PIFragmentDate.h"
#import "PIFragmentGroup.h"
#import "PIFragmentEmbed.h"
#import "PIFragmentGeoPoint.h"


@implementation PIWithFragments

@synthesize data = _data;

+ (id <PIFragment>)parseFragment:(id)jsonObject
{
    id <PIFragment> fragment = nil;
    if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        NSString *type = jsonObject[@"type"];
        id <PIFragment> (^selectedCase)() = @{
                                              @"Link.document" : ^{
                                                  return [[PIFragmentLinkDocument alloc] initWithJson:jsonObject[@"value"]];
                                              },
                                              @"Link.web" : ^{
                                                  return [[PIFragmentLinkWeb alloc] initWithJson:jsonObject[@"value"]];
                                              },
                                              @"Link.file" : ^{
                                                  return [[PIFragmentLinkFile alloc] initWithJson:jsonObject[@"value"]];
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
                                              @"Embed" : ^{
                                                  return [[PIFragmentEmbed alloc] initWithJson:jsonObject];
                                              },
                                              @"GeoPoint" : ^{
                                                  return [[PIFragmentGeoPoint alloc] initWithJson:jsonObject];
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
            if ([fieldData[fieldName] isKindOfClass:[NSArray class]]) {
                for (int i = 0; i < [fieldData[fieldName] count]; i++) {
                    NSDictionary *item = fieldData[fieldName][i];
                    id <PIFragment> fragment = [PIWithFragments parseFragment:item];
                    if (fragment != nil) {
                        [data setObject:fragment forKey:[NSString stringWithFormat:@"%@.%@[%d]", docName, fieldName, i]];
                    }
                }
            } else {
                NSDictionary *field = fieldData[fieldName];
                id <PIFragment> fragment = [PIWithFragments parseFragment:field];
                if (fragment != nil) {
                    [data setObject:fragment forKey:[NSString stringWithFormat:@"%@.%@", docName, fieldName]];
                }
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

- (NSArray *)linkedDocuments
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (NSString *key in _data) {
        id <PIFragment> fragment = _data[key];
        if ([fragment isKindOfClass:[PIFragmentLinkDocument class]]) {
            [result addObject:fragment];
        }
        if ([fragment isKindOfClass:[PIFragmentGroup class]]) {
            for (PIWithFragments *groupDoc in [(PIFragmentGroup*)fragment groupDocs]) {
                [result addObjectsFromArray:[groupDoc linkedDocuments]];
            }
        }
        if ([fragment isKindOfClass:[PIFragmentStructuredText class]]) {
            for (id<PIFragmentBlock> block in [(PIFragmentStructuredText*)fragment blocks]) {
                if ([block conformsToProtocol:@protocol(PIFragmentBlockText)]) {
                    for (PIFragmentBlockSpan *span in [(id<PIFragmentBlockText>)block spans]) {
                        if ([span isKindOfClass:[PIFragmentBlockSpanLink class]]) {
                            PIFragmentBlockSpanLink *link = (PIFragmentBlockSpanLink*)span;
                            if ([[link link] isKindOfClass:[PIFragmentLinkDocument class]]) {
                                [result addObject:link];
                            }
                        }
                    }
                }
            }
        }
    }
    return result;
}

- (id<PIFragment>)get:(NSString*)field
{
    id<PIFragment> fragment = self->_data[field];
    return fragment;
}

- (PIFragmentStructuredText*)getStructuredText:(NSString*)field
{
    id<PIFragment> fragment = [self get:field];
    if ([fragment isKindOfClass:[PIFragmentStructuredText class]]) {
        return fragment;
    }
    return nil;
}

- (PIFragmentText*)getText:(NSString*)field
{
    id<PIFragment> fragment = [self get:field];
    if ([fragment isKindOfClass:[PIFragmentText class]]) {
        return fragment;
    }
    return nil;
}

- (PIFragmentEmbed*)getEmbed:(NSString*)field
{
    id<PIFragment> fragment = [self get:field];
    if ([fragment isKindOfClass:[PIFragmentEmbed class]]) {
        return fragment;
    }
    return nil;
}

- (PIFragmentColor*)getColor:(NSString*)field
{
    id<PIFragment> fragment = [self get:field];
    if ([fragment isKindOfClass:[PIFragmentColor class]]) {
        return fragment;
    }
    return nil;
}

- (PIFragmentGeoPoint*)getGeoPoint:(NSString*)field
{
    id<PIFragment> fragment = [self get:field];
    if ([fragment isKindOfClass:[PIFragmentGeoPoint class]]) {
        return fragment;
    }
    return nil;
}

- (PIFragmentNumber*)getNumber:(NSString*)field
{
    id<PIFragment> fragment = [self get:field];
    if ([fragment isKindOfClass:[PIFragmentNumber class]]) {
        return fragment;
    }
    return nil;
}

- (PIFragmentDate*)getDate:(NSString*)field
{
    id<PIFragment> fragment = [self get:field];
    if ([fragment isKindOfClass:[PIFragmentDate class]]) {
        return fragment;
    }
    return nil;
}

- (id<PIFragmentLink>)getLink:(NSString*)field
{
    id<PIFragment> fragment = [self get:field];
    if ([fragment conformsToProtocol:@protocol(PIFragmentLink)]) {
        return (id<PIFragmentLink>)fragment;
    }
    return nil;
}

- (PIFragmentImage*)getImage:(NSString*)field
{
    id<PIFragment> fragment = [self get:field];
    if ([fragment isKindOfClass:[PIFragmentImage class]]) {
        return (PIFragmentImage*)fragment;
    }
    return nil;
}

- (PIFragmentImageView*)getImageView:(NSString*)field view:(NSString *)view
{
    PIFragmentImage *image = [self getImage:field];
    if (image != nil) {
        return [image view:view];
    }
    return nil;
}


@end
