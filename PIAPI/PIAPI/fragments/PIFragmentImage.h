//
//  PIFragmentImage.h
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 20/12/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PIFragment.h"

@interface Dimensions : NSObject
+ (Dimensions *)DimensionsWithWidth:(NSUInteger)width height:(NSUInteger)height;
- (NSUInteger)width;
- (NSUInteger)height;
@end

@interface PIFragmentImageView : NSObject
+ (PIFragmentImageView *)ViewWithJson:(id)jsonObject;
- (NSURL *)url;
- (NSString *)alt;
- (NSString *)copyright;
- (Dimensions *)dimensions;
@end

@interface PIFragmentImage : NSObject <PIFragment>
+ (PIFragmentImage *)imageWithJson:(id)jsonObject;
- (PIFragmentImageView *)main;
- (NSDictionary *)views;
- (PIFragmentImageView *)view:(NSString *)name;
@end
