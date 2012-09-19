//
//  AbeloReceiptView.h
//  Abelo
//
//  Created by Alasdair McCall on 11/09/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ReceiptViewDelegate;

// enum to control the drawing state of the recipet view
enum AbeloReceiptViewDrawState {
    ReceiptViewDrawPriceBounds,
    ReceiptViewDrawTotalBounds,
    ReceiptViewDrawMenuItems,
    ReceiptViewDrawNone
} typedef ReceiptViewDrawState;

@protocol ReceiptViewDelegate

@optional
- (void) addPartyGuestWithTitle:(NSString *) title atIndex:(int) index;
- (void) addMenuItemWithIndex:(int) index;
- (void) setImage:(UIImage *) image;

@end
    
@interface AbeloReceiptView : UIView

@property (nonatomic) UIImage *image;
@property (nonatomic) ReceiptViewDrawState drawState;
@property (nonatomic, weak) ReceiptViewDelegate *delegate;

- (void) clearView;

//- (void) setCurrentMenuItemAndDrawNext;
//- (void) resetCurrentMenuItem;

- (void) pinchGesture:(UIPinchGestureRecognizer *) gesture;
- (void) panGesture:(UIPanGestureRecognizer *) gesture;

@end
