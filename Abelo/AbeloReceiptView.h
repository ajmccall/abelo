//
//  AbeloReceiptView.h
//  Abelo
//
//  Created by Alasdair McCall on 11/09/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import <UIKit/UIKit.h>

//// enum to control the drawing state of the recipet view
//enum ViewsDrawState {
//    ViewsDrawStateStart = 0,
//    ViewsDrawStateImage = 1,
//    ViewsDrawStateMenuItems = 2,
//    ViewsDrawStateTotal = 3,
//    ViewsDrawStateFinished = 4
//} typedef ViewsDrawState;

    
@interface AbeloReceiptView : UIView

@property (nonatomic) UIImage *image;
@property (nonatomic) CGFloat drawScale;
@property (nonatomic) CGPoint drawOffset;

- (void) clearView;

- (void) addPointToCurrentRect:(CGPoint) fingerPoint;
- (void) setCurrentRectAsMenuItem;
- (void) setCurrentRectAsTotal;
- (BOOL) clearLastMenuItem;

@end
