//
//  PIFragmentBlock.h
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 20/12/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PIFragmentBlockSpan.h"

@protocol PIFragmentBlock <NSObject>
- (NSString *)text;
@end

@protocol PIFragmentBlockText <PIFragmentBlock>

- (NSArray *)spans;
- (NSAttributedString *)formattedText;

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