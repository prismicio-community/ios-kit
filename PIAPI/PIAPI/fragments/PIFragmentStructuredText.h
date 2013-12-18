//
//  PIFragmentStructuredText.h
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 09/12/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PIFragment.h"

/* spans */

@protocol PIFragmentBlockSpan <NSObject>

- (NSString *)type;

@end

@interface PIFragmentBlockSpanEm : NSObject <PIFragmentBlockSpan>
@end

@interface PIFragmentBlockSpanStrong : NSObject <PIFragmentBlockSpan>
@end

/* block */

@protocol PIFragmentBlock <NSObject>
- (NSString *)text;
@end

@protocol PIFragmentBlockText <PIFragmentBlock>

- (NSArray *)spans;

@end

@interface PIFragmentBlockParagraph : NSObject <PIFragmentBlockText>
+ (PIFragmentBlockParagraph *)paragraphWithJson:(id)jsonObject;
@end

@interface PIFragmentBlockPreformated : NSObject <PIFragmentBlockText>
+ (PIFragmentBlockPreformated *)preformatedWithJson:(id)jsonObject;
@end

@interface PIFragmentBlockHeading : NSObject <PIFragmentBlockText>
+ (PIFragmentBlockHeading *)headingWithJson:(id)jsonObject heading:(NSNumber *)heading;
- (NSNumber *)heading;
@end

@interface PIFragmentStructuredText : NSObject <PIFragment>

+ (PIFragmentStructuredText *)structuredTextWithJson:(id)jsonObject;

- (NSArray *)blocks;

- (PIFragmentBlockHeading *)firstTitleObject;
- (NSString *)firstTitleText;

@end
