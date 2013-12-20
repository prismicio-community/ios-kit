//
//  PIFragmentBlock.m
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 20/12/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import "PIFragmentBlock.h"

@interface PIFragmentBlockParagraph ()
{
    NSString *_text;
    NSMutableArray *_spans;
}
@end
@implementation PIFragmentBlockParagraph

+ (PIFragmentBlockParagraph *)paragraphWithJson:(id)jsonObject
{
    PIFragmentBlockParagraph *paragraph = [[PIFragmentBlockParagraph alloc] init];
    paragraph->_text = jsonObject[@"text"];
    paragraph->_spans = [[NSMutableArray alloc] init];
    NSArray *spans = jsonObject[@"spans"];
    for (id jsonSpan in spans) {
        PIFragmentBlockSpan *span = [PIFragmentBlockSpan spanWithJson:jsonSpan];
        if (span != nil) {
            [paragraph->_spans addObject:span];
        }
    }
    return paragraph;
}

- (NSString *)text
{
    return _text;
}

- (NSArray *)spans
{
    return _spans;
}

- (NSAttributedString *)formattedText
{
    UIFontDescriptor* fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    return [PIFragmentBlockSpan formatText:self fontDescriptor:fontDescriptor];
}

@end

@interface PIFragmentBlockPreformated ()
{
    NSString *_text;
    NSMutableArray *_spans;
}
@end
@implementation PIFragmentBlockPreformated

+ (PIFragmentBlockPreformated *)preformatedWithJson:(id)jsonObject
{
    PIFragmentBlockPreformated *preformated = [[PIFragmentBlockPreformated alloc] init];
    preformated->_text = jsonObject[@"text"];
    preformated->_spans = [[NSMutableArray alloc] init];
    NSArray *spans = jsonObject[@"spans"];
    for (id jsonSpan in spans) {
        PIFragmentBlockSpan *span = [PIFragmentBlockSpan spanWithJson:jsonSpan];
        if (span != nil) {
            [preformated->_spans addObject:span];
        }
    }
    return preformated;
}

- (NSString *)text
{
    return _text;
}

- (NSArray *)spans
{
    return _spans;
}

- (NSAttributedString *)formattedText
{
    UIFontDescriptor* fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    return [PIFragmentBlockSpan formatText:self fontDescriptor:fontDescriptor];
}

@end

@interface PIFragmentBlockHeading ()
{
    NSString *_text;
    NSMutableArray *_spans;
    NSNumber *_heading;
}
@end
@implementation PIFragmentBlockHeading

+ (PIFragmentBlockHeading *)headingWithJson:(id)jsonObject heading:(NSNumber *)heading
{
    PIFragmentBlockHeading *headingBlock = [[PIFragmentBlockHeading alloc] init];
    headingBlock->_text = jsonObject[@"text"];
    headingBlock->_spans = [[NSMutableArray alloc] init];
    NSArray *spans = jsonObject[@"spans"];
    for (id jsonSpan in spans) {
        PIFragmentBlockSpan *span = [PIFragmentBlockSpan spanWithJson:jsonSpan];
        if (span != nil) {
            [headingBlock->_spans addObject:span];
        }
    }
    headingBlock->_heading = heading;
    return headingBlock;
}

- (NSString *)text
{
    return _text;
}

- (NSNumber *)heading
{
    return _heading;
}

- (NSArray *)spans
{
    return _spans;
}

- (NSAttributedString *)formattedText
{
    UIFontDescriptor* fontDescriptor = nil;
    if ([_heading integerValue] == 1) {
        fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleHeadline];
    }
    else {
        fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleSubheadline];
    }
    return [PIFragmentBlockSpan formatText:self fontDescriptor:fontDescriptor];
}

@end
