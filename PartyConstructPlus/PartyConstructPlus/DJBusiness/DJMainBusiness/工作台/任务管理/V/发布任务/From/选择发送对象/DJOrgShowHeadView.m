//
//  DJOrgShowHeadView.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/8.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJOrgShowHeadView.h"
#import "YYText.h"
#import "NSParagraphStyle+YYText.h"
@interface DJOrgShowHeadView ()<UITextViewDelegate>

@property (nonatomic, strong)UITextView *textview;

/**
 *
 */
@property (nonatomic, assign)BOOL isSelect;
/**
 *
 */
@property (nonatomic, strong)YYLabel * label;
@end

@implementation DJOrgShowHeadView

-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
//        self.textview = [[UITextView alloc] init];
//        self.textview.backgroundColor = [UIColor clearColor];
//        [self addSubview:self.textview];
//        self.textview.sd_layout.leftSpaceToView(self, 15).rightSpaceToView(self, 15).topSpaceToView(self, 4).bottomSpaceToView(self, 0);
//        _textview.linkTextAttributes = @{NSForegroundColorAttributeName: kColorRGB(46, 126, 237, 1),
//                                         NSUnderlineColorAttributeName: [UIColor lightGrayColor],
//                                         NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid)};
//
//        _textview.delegate = self;
//        _textview.editable = NO; //必须禁止输入，否则点击将弹出输入键盘
//        _textview.scrollEnabled = NO;
//        _textview.selectable=YES;

        
        
        self.label = [YYLabel new];
        _label.userInteractionEnabled = YES;
        _label.numberOfLines = 0;
        _label.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        _label.size = CGSizeMake(260, 260);
        [self addSubview:_label];
        _label.sd_layout.leftSpaceToView(self, 15).rightSpaceToView(self, 15).topSpaceToView(self, 4).bottomSpaceToView(self, 0);

    }
    return self;
}

- (void)protocolIsSelect:(NSArray *)strArray{
    NSLog(@"strArray%@", strArray);
    NSString *orgNameStr =@"";
    for (int i = 0; i < strArray.count; i++) {
        NSString *tempStr = strArray[i];
        orgNameStr =  [NSString stringWithFormat:@"%@%@", orgNameStr, tempStr];
    }
    
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    UIFont  *textFont = MFont(kFit(15));
    
    for (int i = 0; i < strArray.count; i ++) {
        NSString *title = strArray[i];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:title attributes:nil]];
        
        UIColor * textColor = kColorRGB(0, 101, 194, 1);
        UIImage *image = [UIImage imageNamed:@"DJRegistrationRight"];
        image = [UIImage imageWithCGImage:image.CGImage scale:3 orientation:UIImageOrientationUp];
        if (i == strArray.count - 1) {
            textColor = [UIColor blackColor];
            image = nil;
        }
        
        [text yy_setTextHighlightRange:NSMakeRange(text.length-title.length, title.length) color:textColor backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            if ([_delegate respondsToSelector:@selector(OrgNameClick:)]) {
                [_delegate OrgNameClick:i + 1];
            }
        }];
        
        NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:CGSizeMake(14, 14) alignToFont:textFont alignment:YYTextVerticalAlignmentCenter];
        [text appendAttributedString:attachText];
    }
    text.yy_font = textFont;
    _label.attributedText = text;
    
//     NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:orgNameStr];
//    NSString *showStr= @"";
//    for (int i= 0;  i< strArray.count; i++) {
//
//        NSString *tempStr =strArray[i];
//        showStr =  [NSString stringWithFormat:@"%@%@",showStr, tempStr];
//
//
//        UIImage *image = [UIImage imageNamed:@"DJRegistrationRight"];
//        CGSize size = CGSizeMake(11, 11);
//        UIGraphicsBeginImageContextWithOptions(size, false, 0);
//        [image drawInRect:CGRectMake(0, 0,11, 11)];
//        UIImage *resizeImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
//        textAttachment.image = resizeImage;
//        NSMutableAttributedString *imageString = (id) [NSMutableAttributedString attributedStringWithAttachment:textAttachment];
//        if (i == strArray.count - 1) {
//
//        }else {
//            [attributedString addAttribute:NSLinkAttributeName
//                                     value:[NSString stringWithFormat:@"%d://", i+1]
//                                     range:[[attributedString string] rangeOfString:strArray[i]]];
//            [imageString addAttribute:NSLinkAttributeName
//                                value:@"image://"
//                                range:NSMakeRange(0, imageString.length)];
//            [attributedString insertAttributedString:imageString atIndex:showStr.length+i];
//        }
//        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, attributedString.length)];
//    }
//
//
//     _textview.attributedText = nil;
//    _textview.attributedText = attributedString;

}



- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction NS_AVAILABLE_IOS(10_0) {
    
    return  YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    
    if ([[URL scheme] isEqualToString:@"1"]) {
        
        if ([_delegate respondsToSelector:@selector(OrgNameClick:)]) {
            [_delegate OrgNameClick:1];
        }
        return NO;
    } else if ([[URL scheme] isEqualToString:@"2"]) {
        if ([_delegate respondsToSelector:@selector(OrgNameClick:)]) {
            [_delegate OrgNameClick:2];
        }
        return NO;
    } else if ([[URL scheme] isEqualToString:@"3"]) {
        if ([_delegate respondsToSelector:@selector(OrgNameClick:)]) {
            [_delegate OrgNameClick:3];
        }
        return NO;
    }else if ([[URL scheme] isEqualToString:@"4"]) {
        if ([_delegate respondsToSelector:@selector(OrgNameClick:)]) {
            [_delegate OrgNameClick:3];
        }
        return NO;
    }
    else if ([[URL scheme] isEqualToString:@"5"]) {
        if ([_delegate respondsToSelector:@selector(OrgNameClick:)]) {
            [_delegate OrgNameClick:3];
        }
        return NO;
    }
    return NO;
}


- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    [UIMenuController sharedMenuController].menuVisible = NO;
    [_textview resignFirstResponder];
    [self setNeiRong];
    if ([UIMenuController sharedMenuController])
    {
        [UIMenuController   sharedMenuController].menuVisible = NO;
    }
    return  NO;
    
}


- (void)setNeiRong {
    

}


@end
