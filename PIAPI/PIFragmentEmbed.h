//
//  PIFragmentEmbed.h
//  PIAPI
//
//  Created by Erwan Loisant on 13/01/15.
//  Copyright (c) 2015 Zengularity. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PIFragment.h"

@interface PIFragmentEmbed : NSObject <PIFragment>

@property (nonatomic, readonly) NSString *type;
@property (nonatomic, readonly) NSString *provider;
@property (nonatomic, readonly) NSString *url;
@property (nonatomic, readonly) NSNumber* width;
@property (nonatomic, readonly) NSNumber* height;
@property (nonatomic, readonly) NSString *html;
@property (nonatomic, readonly) id oembedJson;

- (PIFragmentEmbed *)initWithJson:(id)jsonObject;

@end
