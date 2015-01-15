//
//  PIFragmentEmbed.m
//  PIAPI
//
//  Created by Erwan Loisant on 13/01/15.
//  Copyright (c) 2015 Zengularity. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PIFragmentEmbed.h"

@implementation PIFragmentEmbed

@synthesize type = _type;
@synthesize provider = _provider;
@synthesize url = _url;
@synthesize width = _width;
@synthesize height = _height;
@synthesize html = _html;
@synthesize oembedJson = _oembedJson;

- (PIFragmentEmbed *)initWithJson:(id)jsonObject
{
    self = [self init];
    _oembedJson = jsonObject[@"oembed"];
    _type = _oembedJson[@"type"];
    _provider = _oembedJson[@"provider_name"];
    _url = _oembedJson[@"url"];
    _html = _oembedJson[@"html"];
    _width = _oembedJson[@"width"];
    _height = _oembedJson[@"height"];
    return self;
}

@end
