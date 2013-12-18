//
//  PIFragmentStructuredText.m
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 09/12/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PIFragmentStructuredText.h"

/* span */

@interface PIFragmentBlockSpanEm ()
{
    NSRange _range;
}
@end

@implementation PIFragmentBlockSpanEm

+ (PIFragmentBlockSpanEm *)spanWithJson:(id)jsonObject
{
    PIFragmentBlockSpanEm *span = [[PIFragmentBlockSpanEm alloc] init];
    NSUInteger start = [jsonObject[@"start"] unsignedIntegerValue];
    NSUInteger end = [jsonObject[@"end"] unsignedIntegerValue];
    NSUInteger length = end - start;
    span->_range = NSMakeRange(start, length);
    return span;
}

- (NSString *)type
{
    return @"em";
}

- (NSRange)range
{
    return _range;
}

@end

@interface PIFragmentBlockSpanStrong ()
{
    NSRange _range;
}
@end

@implementation PIFragmentBlockSpanStrong

+ (PIFragmentBlockSpanStrong *)spanWithJson:(id)jsonObject
{
    PIFragmentBlockSpanStrong *span = [[PIFragmentBlockSpanStrong alloc] init];
    NSUInteger start = [jsonObject[@"start"] unsignedIntegerValue];
    NSUInteger end = [jsonObject[@"end"] unsignedIntegerValue];
    NSUInteger length = end - start;
    span->_range = NSMakeRange(start, length);
    return span;
}

- (NSString *)type
{
    return @"strong";
}

- (NSRange)range
{
    return _range;
}

@end

/* block */

@interface PIFragmentBlockSpan : NSObject
@end
@implementation PIFragmentBlockSpan
+ (id <PIFragmentBlockSpan>)spanWithJson:(id)jsonObject
{
    id <PIFragmentBlockSpan> span = nil;
    if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        NSString *type = jsonObject[@"type"];
        id <PIFragmentBlockSpan> (^selectedCase)() = @{
            @"em" : ^{
                return [PIFragmentBlockSpanEm spanWithJson:jsonObject];
            },
            @"strong" : ^{
                return [PIFragmentBlockSpanStrong spanWithJson:jsonObject];
            },
            /*@"hyperlink" : ^{
                return [PIFragmentBlockSpanLink linkWithJson:jsonObject heading:@1];
            },*/
        }[type];
        if (selectedCase != nil) {
            span = selectedCase();
        }
        else {
            NSLog(@"Unsupported block type: %@", type);
        }
    }
    return span;
}

+ (NSAttributedString *)formatText:(id <PIFragmentBlockText>)block fontDescriptor:(UIFontDescriptor *)fontDescriptor
{
    // Create styles
    UIFontDescriptor *boldFontDescriptor = [fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    UIFontDescriptor *italicFontDescriptor = [fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
    UIFont *normalFont = [UIFont fontWithDescriptor:fontDescriptor size:0.0];
    UIFont *boldFont = [UIFont fontWithDescriptor:boldFontDescriptor size: 0.0];
    UIFont *italicFont = [UIFont fontWithDescriptor:italicFontDescriptor size: 0.0];
    NSDictionary *normalAttributes = @{ NSFontAttributeName : normalFont };
    NSDictionary *boldAttributes = @{ NSFontAttributeName : boldFont };
    NSDictionary *italicAttributes = @{ NSFontAttributeName : italicFont };

    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:[block text]];
    [content addAttributes:normalAttributes range:NSMakeRange(0, [content length])];

    NSArray *spans = [block spans];
    for (id <PIFragmentBlockSpan> span in spans) {
        void (^selectedCase)() = @{
            @"em" : ^{
                [content addAttributes:boldAttributes range:[span range]];
            },
            @"strong" : ^{
                [content addAttributes:italicAttributes range:[span range]];
            },
        }[[span type]];
        if (selectedCase != nil) {
            selectedCase();
        }
    }

    return content;
}

@end

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

/* fragment */

@interface PIFragmentStructuredText () {
    NSMutableArray *_blocks;
}
@end

@implementation PIFragmentStructuredText

+ (id <PIFragmentBlock>)parseBlock:(id)jsonObject
{
    id <PIFragmentBlock> block = nil;
    if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        NSString *type = jsonObject[@"type"];
        id <PIFragmentBlock> (^selectedCase)() = @{
            @"paragraph" : ^{
                return [PIFragmentBlockParagraph paragraphWithJson:jsonObject];
            },
            @"preformated" : ^{
                return [PIFragmentBlockPreformated preformatedWithJson:jsonObject];
            },
            @"heading1" : ^{
                return [PIFragmentBlockHeading headingWithJson:jsonObject heading:@1];
            },
            @"heading2" : ^{
                return [PIFragmentBlockHeading headingWithJson:jsonObject heading:@2];
            },
            @"heading3" : ^{
                return [PIFragmentBlockHeading headingWithJson:jsonObject heading:@3];
            },
            @"heading4" : ^{
                return [PIFragmentBlockHeading headingWithJson:jsonObject heading:@4];
            },
        }[type];
        if (selectedCase != nil) {
            block = selectedCase();
        }
        else {
            NSLog(@"Unsupported fragment type: %@", type);
        }
    }
    return block;
}

+ (PIFragmentStructuredText *)structuredTextWithJson:(id)jsonObject
{
    PIFragmentStructuredText *structuredText = [[PIFragmentStructuredText alloc] init];
    
    structuredText->_blocks = [[NSMutableArray alloc] init];
    NSDictionary *values = jsonObject[@"value"];
    for (NSDictionary *field in values) {
        id <PIFragmentBlock> block = [self parseBlock:field];
        if (block != nil) {
            [structuredText->_blocks addObject:block];
        }
    }
    
    return structuredText;
}

- (NSArray *)blocks
{
    return _blocks;
}

- (PIFragmentBlockHeading *)firstTitleObject
{
    PIFragmentBlockHeading *res = nil;
    for (id <PIFragmentBlock> block in _blocks) {
        if ([block isKindOfClass:[PIFragmentBlockHeading class]]) {
            PIFragmentBlockHeading *heading = (PIFragmentBlockHeading *)block;
            if (res == nil || [res heading] < [heading heading]) {
                res = heading;
            }
        }
    }
    return res;
}

- (NSAttributedString *)firstTitleFormatted
{
    PIFragmentBlockHeading *heading = [self firstTitleObject];
    if (heading) {
        return [heading formattedText];
    }
    return nil;
}

- (NSString *)firstTitle
{
    PIFragmentBlockHeading *heading = [self firstTitleObject];
    if (heading) {
        return [heading text];
    }
    return nil;
}

- (PIFragmentBlockParagraph *)firstParagraphObject
{
    PIFragmentBlockParagraph *res = nil;
    for (id <PIFragmentBlock> block in _blocks) {
        if ([block isKindOfClass:[PIFragmentBlockParagraph class]]) {
            return (PIFragmentBlockParagraph *)block;
        }
    }
    return res;
}

- (NSAttributedString *)firstParagraphFormatted
{
    PIFragmentBlockParagraph *paragraph = [self firstParagraphObject];
    if (paragraph) {
        return [paragraph formattedText];
    }
    return nil;
}

- (NSString *)firstParagraph
{
    PIFragmentBlockParagraph *paragraph = [self firstParagraphObject];
    if (paragraph) {
        return [paragraph text];
    }
    return nil;
}

@end
