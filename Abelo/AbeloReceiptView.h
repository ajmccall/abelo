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

- (void) clearView;


- (void) setCurrentMenuItemAndDrawNext;
- (void) resetCurrentMenuItem;

- (void) pinchGesture:(UIPinchGestureRecognizer *) gesture;
- (void) panGesture:(UIPanGestureRecognizer *) gesture;

@end
