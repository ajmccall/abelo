//
//  AbeloReceiptView.h
//  Abelo
//
//  Created by Alasdair McCall on 11/09/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import <UIKit/UIKit.h>

// enum to control the drawing state of the recipet view
enum AbeloReceiptViewDrawState {
    AbeloReceiptViewDrawStateFinished = 4,
    AbeloReceiptViewDrawStateMenuItems = 3,
    AbeloReceiptViewDrawStateTotalBounds = 2,
    AbeloReceiptViewDrawStateImage = 1,
    AbeloReceiptViewDrawStateStart = 0
} typedef AbeloReceiptViewDrawState;

@protocol ReceiptViewDelegate

- (UIImage *) getImage;
@optional
- (void) addMenuItemWithIndex:(int) index;
- (void) clearMenuItemWithIndex:(int) index;
@end
    
@interface AbeloReceiptView : UIView

@property (nonatomic) UIImage *image;
@property (nonatomic) AbeloReceiptViewDrawState drawState;
@property (nonatomic, weak) id<ReceiptViewDelegate> delegate;

- (void) clearView;

- (void) pinchGesture:(UIPinchGestureRecognizer *) gesture;
- (void) panGesture:(UIPanGestureRecognizer *) gesture;

@end
