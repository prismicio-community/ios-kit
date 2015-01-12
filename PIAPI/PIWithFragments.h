//
//  PIWithFragments.h
//  PIAPI
//
//  Created by Erwan Loisant on 12/01/15.
//  Copyright (c) 2015 Zengularity. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PIFragment.h"
#import "PIFragmentText.h"
#import "PIFragmentStructuredText.h"
#import "PIFragmentImage.h"
#import "PIFragmentNumber.h"
#import "PIFragmentSelect.h"
#import "PIFragmentColor.h"
#import "PIFragmentDate.h"
#import "PIFragmentGroup.h"

@interface PIWithFragments : NSObject

@property (nonatomic, readwrite) NSDictionary *data;

+ (PIWithFragments *)WithFragmentsWithJson:(id)jsonObject;

- (PIFragmentBlockHeading *)firstTitleObject;

- (NSAttributedString *)firstTitleFormatted;

- (NSString *)firstTitle;

- (PIFragmentBlockParagraph *)firstParagraphObject;

- (NSAttributedString *)firstParagraphFormatted;

- (NSString *)firstParagraph;

- (id<PIFragment>)get:(NSString*)field;

- (PIFragmentImage *)getImage:(NSString*)field view:(NSString*)view;

- (NSArray *)getAllImages:(NSString*)field view:(NSString*)view;

- (PIFragmentStructuredText *)getStructuredText:(NSString*)field;

- (PIFragmentLink *)getLink:(NSString*)field;

// TODO - (PIFragmentEmbed *)getEmbed:(NSString*)field;

- (PIFragmentText *)getText:(NSString*)field;

- (PIFragmentColor *)getColor:(NSString*)field;

// TODO - (PIFragmentNumber *)getNumber:(NSString*)field;

- (PIFragmentDate *)getDate:(NSString*)field;

// TODO - (PIFragmentTimestamp *)getTimestamp:(NSString*)field;

// TODO - (PIFragmentGeoPoint *)getGeoPoint:(NSString*)field;

// TODO - (PIFragmentBoolean *)getBoolean:(NSString*)field;


@end
