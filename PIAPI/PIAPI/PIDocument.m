//
//  PIDocument.m
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 27/11/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import "PIDocument.h"

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

+ (PIDocument *)documentWithJson:(id)jsonObject
{
    PIDocument *document = [[PIDocument alloc] init];

    document->_data = [[NSMutableDictionary alloc] init];
    NSDictionary *data = [jsonObject objectForKey:@"data"];
    // TODO parse data :-)

    NSString *href = [jsonObject objectForKey:@"href"];
    document->_href = href ? [NSURL URLWithString:href] : nil;

    document->_id = [jsonObject objectForKey:@"id"];

    document->_slugs = [[NSMutableArray alloc] init];
    NSArray *slugs = [jsonObject objectForKey:@"slugs"];
    for (NSString *slug in slugs) {
        [document->_slugs addObject:slug];
    }

    document->_tags = [[NSMutableArray alloc] init];
    NSArray *tags = [jsonObject objectForKey:@"tags"];
    for (NSString *tag in tags) {
        [document->_tags addObject:tag];
    }

    document->_type = [jsonObject objectForKey:@"type"];

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

- (NSString *)firstTitle
{
    return @"A title";
}


@end
