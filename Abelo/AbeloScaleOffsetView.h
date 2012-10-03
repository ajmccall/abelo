//
//  AbeloScaleOffSetView.h
//  Abelo
//
//  Created by Alasdair McCall on 03/10/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AbeloScaleOffsetView : UIView

@property (nonatomic) CGFloat drawScale;
@property (nonatomic) CGPoint drawOffset;

- (CGPoint) translateAndScalePoint:(CGPoint) p;
- (CGPoint) reverseTranslateAndScalePoint:(CGPoint) p;
- (CGRect) reverseTranslateAndScaleRect:(CGRect) rect;
- (CGRect) CGRectMakeFromFingerPoint:(CGPoint) p;
+ (CGFloat) maximumScale;

@end
