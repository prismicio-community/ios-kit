//
//  PIWithFragmentsProtocol.h
//  PIAPI
//
//  Created by Erwan Loisant on 13/01/15.
//  Copyright (c) 2015 Zengularity. All rights reserved.
//

#ifndef PIAPI_PIWithFragmentsProtocol_h
#define PIAPI_PIWithFragmentsProtocol_h

@class PIFragmentBlockHeading;
@class PIFragmentBlockParagraph;
@class PIFragmentStructuredText;
@class PIFragmentDate;
@class PIFragmentImage;
@class PIFragmentGroup;
@class PIFragmentText;
@class PIFragmentColor;
@protocol PIFragmentLink;

@protocol PIWithFragments

@property (nonatomic, readwrite) NSDictionary *data;

- (PIFragmentBlockHeading *)firstTitleObject;

- (NSAttributedString *)firstTitleFormatted;

- (NSString *)firstTitle;

- (PIFragmentBlockParagraph *)firstParagraphObject;

- (NSAttributedString *)firstParagraphFormatted;

- (NSString *)firstParagraph;

- (NSArray *)linkedDocuments;

- (id<PIFragment>)get:(NSString*)field;

- (PIFragmentImage *)getImage:(NSString*)field view:(NSString*)view;

- (NSArray *)getAllImages:(NSString*)field view:(NSString*)view;

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

#endif
