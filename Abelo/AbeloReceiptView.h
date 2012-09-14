//
//  AbeloReceiptView.h
//  Abelo
//
//  Created by Alasdair McCall on 11/09/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import <UIKit/UIKit.h>

enum RecieptViewDrawState {
    RecieptViewDrawPriceBounds,
    RecieptViewDrawTotalBounds,
    RecieptViewDrawMenuItems,
    RecieptViewDrawNone
} typedef RecieptViewDrawState;
    
@interface AbeloReceiptView : UIView

@property (nonatomic) UIImage *image;

@property (nonatomic) RecieptViewDrawState drawState;

- (void) setMenuItemsBoundsPoint1:(CGFloat) p1 point2:(CGFloat) p2;
- (void) clearView;
- (void) pinchGesture:(UIPinchGestureRecognizer *) gesture;
//- (void) tapGesture:(UITapGestureRecognizer *) gesture;
- (void) panGesture:(UIPanGestureRecognizer *) gesture;

@end
