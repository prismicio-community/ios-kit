//
//  PIWithFragments.h
//  PIAPI
//
//  Created by Erwan Loisant on 12/01/15.
//  Copyright (c) 2015 Zengularity. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PIFragment;
@class PIFragmentText;
@protocol PIFragmentLink;
@class PIFragmentStructuredText;
@class PIFragmentImage;
@class PIFragmentImageView;
@class PIFragmentNumber;
@class PIFragmentSelect;
@class PIFragmentColor;
@class PIFragmentDate;
@class PIFragmentGroup;
@class PIFragmentBlockParagraph;
@class PIFragmentBlockHeading;

@interface PIWithFragments : NSObject

@property (nonatomic, readwrite) NSDictionary *data;

+ (PIWithFragments *)WithFragmentsWithJson:(id)jsonObject;

- (PIWithFragments *)initWithFragments:(NSDictionary *)data;

+ (id <PIFragment>)parseFragment:(id)jsonObject;

- (PIFragmentBlockHeading *)firstTitleObject;

- (NSAttributedString *)firstTitleFormatted;

- (NSString *)firstTitle;

- (PIFragmentBlockParagraph *)firstParagraphObject;

- (NSAttributedString *)firstParagraphFormatted;

- (NSString *)firstParagraph;

- (NSArray *)linkedDocuments;

- (id<PIFragment>)get:(NSString*)field;

- (PIFragmentImage *)getImage:(NSString*)field;

- (PIFragmentImageView *)getImageView:(NSString*)field view:(NSString*)view;

// TODO - (NSArray *)getAllImages:(NSString*)field;

// TODO - (NSArray *)getAllImageViews:(NSString*)field view:(NSString*)view;

- (PIFragmentStructuredText *)getStructuredText:(NSString*)field;

- (id<PIFragmentLink>)getLink:(NSString*)field;

// TODO - (PIFragmentEmbed *)getEmbed:(NSString*)field;

- (PIFragmentText *)getText:(NSString*)field;

- (PIFragmentColor *)getColor:(NSString*)field;

// TODO - (PIFragmentNumber *)getNumber:(NSString*)field;

- (PIFragmentDate *)getDate:(NSString*)field;

// TODO - (PIFragmentTimestamp *)getTimestamp:(NSString*)field;

// TODO - (PIFragmentGeoPoint *)getGeoPoint:(NSString*)field;

// TODO - (PIFragmentBoolean *)getBoolean:(NSString*)field;


@end
