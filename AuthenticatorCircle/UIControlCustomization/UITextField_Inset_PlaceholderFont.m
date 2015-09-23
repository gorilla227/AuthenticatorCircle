//
//  UITextField_Inset_PlaceholderFont.m
//  AuthenticatorCircle
//
//  Created by Andy Xu on 15/9/4.
//  Copyright (c) 2015年 Andy Xu. All rights reserved.
//

#import "UITextField_Inset_PlaceholderFont.h"

@implementation UITextField_Inset_PlaceholderFont

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 5, 0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 5, 0);
}

- (void)drawPlaceholderInRect:(CGRect)rect {
    NSDictionary *placeholderAttributes = @{NSForegroundColorAttributeName:[UIColor grayColor], NSFontAttributeName:self.font};
    CGRect boundingRect = [self.placeholder boundingRectWithSize:rect.size options:NSStringDrawingTruncatesLastVisibleLine attributes:placeholderAttributes context:nil];
    [self.placeholder drawAtPoint:CGPointMake(0, rect.size.height / 2 - boundingRect.size.height / 2) withAttributes:placeholderAttributes];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    // Drawing code
    [self.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [self.layer setBorderWidth:1.0f];
    [self.layer setCornerRadius:kTextFieldCornerRadius];
    [self.layer setMasksToBounds:YES];
}

@end
