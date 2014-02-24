//
//  PIFragmentStructuredText.h
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 09/12/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PIFragment.h"
#import "PIFragmentBlock.h"

@interface PIFragmentStructuredText : NSObject <PIFragment>

+ (PIFragmentStructuredText *)StructuredTextWithJson:(id)jsonObject;

- (NSArray *)blocks;

- (PIFragmentBlockHeading *)firstTitleObject;
- (NSString *)firstTitleFormatted;
- (NSString *)firstTitle;

- (PIFragmentBlockParagraph *)firstParagraphObject;
- (NSString *)firstParagraphFormatted;
- (NSString *)firstParagraph;

@end
