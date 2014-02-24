//
//  PIDocument.h
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 27/11/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PIFragmentText.h"
#import "PIFragmentStructuredText.h"
#import "PIFragmentImage.h"
#import "PIFragmentSelect.h"
#import "PIFragmentColor.h"
#import "PIFragmentDate.h"

@interface PIDocument : NSObject

+ (PIDocument *)DocumentWithJson:(id)jsonObject;

@property (nonatomic, readonly) NSDictionary *data;
@property (nonatomic, readonly) NSURL *href;
@property (nonatomic, readonly) NSString *id;
@property (nonatomic, readonly) NSArray *slugs;
@property (nonatomic, readonly) NSArray *tags;
@property (nonatomic, readonly) NSString *type;

- (PIFragmentBlockHeading *)firstTitleObject;

- (NSAttributedString *)firstTitleFormatted;

- (NSString *)firstTitle;

- (PIFragmentBlockParagraph *)firstParagraphObject;

- (NSAttributedString *)firstParagraphFormatted;

- (NSString *)firstParagraph;

@end
