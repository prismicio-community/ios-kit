//
//  PIFragmentImage.m
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 20/12/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import "PIFragmentImage.h"

@implementation Dimensions

@synthesize width = _width;
@synthesize height = _height;

+ (Dimensions *)DimensionsWithWidth:(NSUInteger)width height:(NSUInteger)height
{
    return [[Dimensions alloc] initWithWidth:width height:height];
}

+ (Dimensions *)DimensionsWithJson:(id)jsonObject
{
    NSNumber *width = jsonObject[@"width"];
    NSNumber *height = jsonObject[@"height"];
    return [self DimensionsWithWidth:[width unsignedIntegerValue] height:[height unsignedIntegerValue]];
}

- (Dimensions *)initWithWidth:(NSUInteger)width height:(NSUInteger)height
{
    self = [self init];
    _width = width;
    _height = height;
    return self;
}

@end

@implementation PIFragmentImageView

@synthesize url = _url;
@synthesize alt = _alt;
@synthesize copyright = _copyright;
@synthesize dimensions = _dimensions;

+ (PIFragmentImageView *)ViewWithJson:(id)jsonObject
{
    return [[PIFragmentImageView alloc] initWithJson:jsonObject];
}

- (PIFragmentImageView *)initWithJson:(id)jsonObject
{
    self = [self init];
    _url = jsonObject[@"url"];
    _alt = jsonObject[@"alt"];
    _copyright = jsonObject[@"copyright"];
    _dimensions = [Dimensions DimensionsWithJson:jsonObject[@"dimensions"]];
    return self;
}

@end

@interface PIFragmentImage ()
{
    PIFragmentImageView *_main;
    NSDictionary *_views;
}
@end
@implementation PIFragmentImage

+ (PIFragmentImage *)imageWithJson:(id)jsonObject
{
    PIFragmentImage *image = [[PIFragmentImage alloc] init];
    image->_main = [PIFragmentImageView ViewWithJson:jsonObject[@"main"]];
    NSMutableDictionary *views = [[NSMutableDictionary alloc] init];
    image->_views = views;
    NSDictionary *jsonViews = jsonObject[@"views"];
    for (id viewName in jsonViews) {
        id jsonView = jsonViews[viewName];
        PIFragmentImageView *view = [PIFragmentImageView ViewWithJson:jsonView];
        [views setObject:view forKey:viewName];
    }
    return image;
}

- (PIFragmentImageView *)main
{
    return _main;
}

- (NSDictionary *)views
{
    return _views;
}

- (PIFragmentImageView *)view:(NSString *)name
{
    return _views[name];
}

@end
