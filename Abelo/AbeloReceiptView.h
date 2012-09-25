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
    AbeloReceiptViewDrawStateStart = 0,
    AbeloReceiptViewDrawStateImage = 1,
    AbeloReceiptViewDrawStateMenuItems = 2,
    AbeloReceiptViewDrawStateTotal = 3,
    AbeloReceiptViewDrawStateFinished = 4
} typedef AbeloReceiptViewDrawState;

@protocol ReceiptViewDelegate <NSObject>

- (UIImage *) getImage;
- (void) addMenuItemWithIndex:(int) index;
- (void) clearMenuItemWithIndex:(int) index;
@optional
- (void) displayNextStepMessage:(NSString *) message;
@end
    
@interface AbeloReceiptView : UIView

@property (nonatomic) UIImage *image;
@property (nonatomic) AbeloReceiptViewDrawState drawState;
@property (nonatomic, weak) id<ReceiptViewDelegate> delegate;

- (void) clearView;

@end
