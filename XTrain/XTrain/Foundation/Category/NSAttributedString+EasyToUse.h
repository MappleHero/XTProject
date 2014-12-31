//
//  NSAttributedString+EasyToUse.h
//  TuniuSelfDriving
//
//  Created by Ben on 14/12/2.
//  Copyright (c) 2014年 Tuniu. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface NSAttributedString (EasyToUse)

+ (id)attributedStringWithString:(NSString*)string;

+ (id)attributedStringWithAttributedString:(NSAttributedString*)attrStr;

@end

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0

@interface NSMutableAttributedString (EasyToUse)

- (void)setFont:(UIFont*)font;
- (void)setFont:(UIFont*)font range:(NSRange)range;
- (void)setFontName:(NSString*)fontName size:(CGFloat)size;
- (void)setFontName:(NSString*)fontName size:(CGFloat)size range:(NSRange)range;

- (void)setTextColor:(UIColor*)color;
- (void)setTextColor:(UIColor*)color range:(NSRange)range;

- (void)setTextStrikethroughStyle:(NSUnderlineStyle)style;
- (void)setTextStrikethroughStyle:(NSUnderlineStyle)style range:(NSRange)range;

- (void)setTextUnderLineStyle:(NSUnderlineStyle)style;
- (void)setTextUnderLineStyle:(NSUnderlineStyle)style range:(NSRange)range;

- (void)modifyParagraphStylesWithBlock:(void (^)(NSMutableParagraphStyle *paragraphStyle))block;
- (void)modifyParagraphStylesInRange:(NSRange)range withBlock:(void(^)(NSMutableParagraphStyle *paragraphStyle))block;

- (void)setParagraphStyle:(NSParagraphStyle *)paragraphStyle;
- (void)setParagraphStyle:(NSParagraphStyle *)paragraphStyle range:(NSRange)range;

@end

#endif
