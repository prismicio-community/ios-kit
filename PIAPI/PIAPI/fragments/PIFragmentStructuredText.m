//
//  PIFragmentStructuredText.m
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 09/12/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import "PIFragmentStructuredText.h"

/* span */

@interface PIFragmentBlockSpanEm ()
{
    NSNumber *_start;
    NSNumber *_end;
}
@end

@implementation PIFragmentBlockSpanEm

+ (PIFragmentBlockSpanEm *)spanWithJson:(id)jsonObject
{
    PIFragmentBlockSpanEm *span = [[PIFragmentBlockSpanEm alloc] init];
    span->_start = jsonObject[@"start"];
    span->_end = jsonObject[@"end"];
    return span;
}

- (NSString *)type
{
    return @"em";
}

@end

@interface PIFragmentBlockSpanStrong ()
{
    NSNumber *_start;
    NSNumber *_end;
}
@end

@implementation PIFragmentBlockSpanStrong

+ (PIFragmentBlockSpanStrong *)spanWithJson:(id)jsonObject
{
    PIFragmentBlockSpanStrong *span = [[PIFragmentBlockSpanStrong alloc] init];
    span->_start = jsonObject[@"start"];
    span->_end = jsonObject[@"end"];
    return span;
}

- (NSString *)type
{
    return @"strong";
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

- (NSString *)firstParagraph
{
    PIFragmentBlockParagraph *paragraph = [self firstParagraphObject];
    if (paragraph) {
        return [paragraph text];
    }
    return nil;
}

@end
