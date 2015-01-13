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

@interface PIFragmentBlockParagraph : NSObject<PIFragmentBlockText>
+ (PIFragmentBlockParagraph *)BlockWithJson:(id)jsonObject;
@end

@interface PIFragmentBlockPreformatted : NSObject<PIFragmentBlockText>
+ (PIFragmentBlockPreformatted *)BlockWithJson:(id)jsonObject;
@end

@interface PIFragmentBlockHeading : NSObject<PIFragmentBlockText>
+ (PIFragmentBlockHeading *)BlockWithJson:(id)jsonObject heading:(NSNumber *)heading;
- (NSNumber *)heading;
@end

@interface PIFragmentBlockListItem : NSObject<PIFragmentBlockText>
+ (PIFragmentBlockListItem *)BlockWithJson:(id)jsonObject;
@end

@interface PIFragmentBlockOrderedListItem : NSObject<PIFragmentBlockText>
+ (PIFragmentBlockOrderedListItem *)BlockWithJson:(id)jsonObject;
@end
