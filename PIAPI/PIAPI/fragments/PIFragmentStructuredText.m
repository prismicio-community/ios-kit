//
//  PIFragmentStructuredText.m
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 09/12/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import "PIFragmentStructuredText.h"


@interface PIFragmentBlockParagraph ()
{
    NSString *_text;
}
@end
@implementation PIFragmentBlockParagraph

+ (PIFragmentBlockParagraph *)paragraphWithJson:(id)jsonObject {
    PIFragmentBlockParagraph *paragraph = [[PIFragmentBlockParagraph alloc] init];
    paragraph->_text = jsonObject[@"text"];
    return paragraph;
}

- (NSString *)text
{
    return _text;
}

@end

@interface PIFragmentBlockPreformated ()
{
    NSString *_text;
}
@end
@implementation PIFragmentBlockPreformated

+ (PIFragmentBlockPreformated *)preformatedWithJson:(id)jsonObject {
    PIFragmentBlockPreformated *paragraph = [[PIFragmentBlockPreformated alloc] init];
    paragraph->_text = jsonObject[@"text"];
    return paragraph;
}

- (NSString *)text
{
    return _text;
}

@end

@interface PIFragmentBlockHeading ()
{
    NSString *_text;
    NSNumber *_heading;
}
@end
@implementation PIFragmentBlockHeading

+ (PIFragmentBlockHeading *)headingWithJson:(id)jsonObject heading:(NSNumber *)heading
{
    PIFragmentBlockHeading *headingBlock = [[PIFragmentBlockHeading alloc] init];
    headingBlock->_text = jsonObject[@"text"];
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

@end

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
            PIFragmentBlockHeading *heading = block;
            if (res == nil || [res heading] < [heading heading]) {
                res = heading;
            }
        }
    }
    return res;
}

- (NSString *)firstTitleText
{
    PIFragmentBlockHeading *heading = [self firstTitleObject];
    if (heading) {
        return [heading text];
    }
    return nil;
}

@end
