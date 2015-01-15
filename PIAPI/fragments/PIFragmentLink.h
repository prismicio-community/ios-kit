//
//  PIFragmentLink.h
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 18/12/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PIFragment.h"
#import "PIWithFragments.h"

@protocol PIFragmentLink <PIFragment>
@end

@interface PIFragmentLinkDocument : PIWithFragments<PIFragmentLink>

@property (nonatomic, readonly) NSString *id;
@property (nonatomic, readonly) NSString *type;
@property (nonatomic, readonly) NSArray *tags;
@property (nonatomic, readonly) NSString *slug;
@property (nonatomic, readonly, getter=isBroken) NSString *broken;

- (PIFragmentLinkDocument *)initWithJson:(id)jsonObject;

@end

@interface PIFragmentLinkWeb : NSObject<PIFragmentLink>

@property (nonatomic, readonly) NSURL *url;
@property (nonatomic, readonly) NSString *contentType;

- (PIFragmentLinkWeb *)initWithJson:(id)jsonObject;

@end

@interface PIFragmentLinkFile : NSObject<PIFragmentLink>

@property (nonatomic, readonly) NSURL *url;
@property (nonatomic, readonly) NSString *kind;
@property (readonly) NSUInteger size;
@property (nonatomic, readonly) NSString *filename;

- (PIFragmentLinkFile *)initWithJson:(id)jsonObject;

@end
