//
//  PIFragmentImage.m
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 20/12/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import "PIFragmentImage.h"

@interface Dimensions ()
{
    NSUInteger _width;
    NSUInteger _height;
}
@end
@implementation Dimensions

+ (Dimensions *)DimensionsWithWidth:(NSUInteger)width height:(NSUInteger)height
{
    Dimensions *dimension = [[Dimensions alloc] init];
    dimension->_width = width;
    dimension->_height = height;
    return dimension;
}

+ (Dimensions *)DimensionsWithJson:(id)jsonObject
{
    NSNumber *width = jsonObject[@"width"];
    NSNumber *height = jsonObject[@"height"];
    return [self DimensionsWithWidth:[width unsignedIntegerValue] height:[height unsignedIntegerValue]];
}

- (NSUInteger)width
{
    return _width;
}

- (NSUInteger)height;
{
    return _height;
}

@end

@interface PIFragmentImageView ()
{
    NSURL *_url;
    NSString *_alt;
    NSString *_copyright;
    Dimensions *_dimensions;
}
@end
@implementation PIFragmentImageView

+ (PIFragmentImageView *)ViewWithJson:(id)jsonObject
{
    PIFragmentImageView *view = [[PIFragmentImageView alloc] init];
    view->_url = jsonObject[@"url"];
    view->_alt = jsonObject[@"alt"];
    view->_copyright = jsonObject[@"copyright"];
    view->_dimensions = [Dimensions DimensionsWithJson:jsonObject[@"dimensions"]];
    return view;
}

- (NSURL *)url;
{
    return _url;
}

- (NSString *)alt;
{
    return _alt;
}

- (NSString *)copyright;
{
    return _copyright;
}

- (Dimensions *)dimensions;
{
    return _dimensions;
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
