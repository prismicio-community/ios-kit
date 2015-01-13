//
//  PIFragmentLink.h
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 18/12/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PIFragment.h"
#import "PIWithFragmentsProtocol.h"

@protocol PIFragmentLink <PIFragment>
@end

@interface PIFragmentLinkDocument : NSObject <PIWithFragments, PIFragmentLink>

@property (nonatomic, readonly) NSString *id;
@property (nonatomic, readonly) NSString *type;
@property (nonatomic, readonly) NSArray *tags;
@property (nonatomic, readonly) NSString *slug;
@property (nonatomic, readonly, getter=isBroken) NSString *broken;

+ (PIFragmentLinkDocument *)LinkWithJson:(id)jsonObject;

@end
