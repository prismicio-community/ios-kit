//
//  PIFragmentStructuredText.h
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 09/12/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PIFragment.h"

@protocol PIFragmentBlock <NSObject>
- (NSString *)text;
@end

@interface PIFragmentBlockParagraph : NSObject <PIFragmentBlock>
+ (PIFragmentBlockParagraph *)paragraphWithJson:(id)jsonObject;
@end

@interface PIFragmentBlockPreformated : NSObject <PIFragmentBlock>
+ (PIFragmentBlockPreformated *)preformatedWithJson:(id)jsonObject;
@end

@interface PIFragmentBlockHeading : NSObject <PIFragmentBlock>
+ (PIFragmentBlockHeading *)headingWithJson:(id)jsonObject heading:(NSNumber *)heading;
- (NSNumber *)heading;
@end

@interface PIFragmentStructuredText : NSObject <PIFragment>

+ (PIFragmentStructuredText *)structuredTextWithJson:(id)jsonObject;

- (NSArray *)blocks;

- (PIFragmentBlockHeading *)firstTitleObject;
- (NSString *)firstTitleText;

@end
