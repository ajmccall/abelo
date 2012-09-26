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

    
@interface AbeloReceiptView : UIView

@property (nonatomic) UIImage *image;
@property (nonatomic) AbeloReceiptViewDrawState drawState;
@property (nonatomic) CGFloat drawScale;
@property (nonatomic) CGPoint drawOffset;

- (void) clearView;

- (void) addPointToCurrentRect:(CGPoint) fingerPoint;
- (void) setCurrentRectAsMenuItemWithId:(int) menuItemId;
- (void) setCurrentRectAsTotal;

- (BOOL) clearLastMenuItem;
@end
