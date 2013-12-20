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

@interface PIDocument : NSObject

+ (PIDocument *)documentWithJson:(id)jsonObject;

- (NSMutableDictionary *)data;

- (NSURL *)href;

- (NSString *)id;

- (NSMutableArray *)slugs;

- (NSMutableArray *)tags;

- (NSString *)type;

- (PIFragmentBlockHeading *)firstTitleObject;

- (NSAttributedString *)firstTitleFormatted;

- (NSString *)firstTitle;

- (PIFragmentBlockParagraph *)firstParagraphObject;

- (NSAttributedString *)firstParagraphFormatted;

- (NSString *)firstParagraph;

@end
