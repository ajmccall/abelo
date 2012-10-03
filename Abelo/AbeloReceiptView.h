//
//  AbeloReceiptView.h
//  Abelo
//
//  Created by Alasdair McCall on 11/09/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbeloScaleOffsetView.h"

@interface AbeloReceiptView : AbeloScaleOffsetView

@property (nonatomic) UIImage *image;

- (void) clearView;

- (void) addPointToCurrentRect:(CGPoint) fingerPoint;
- (void) setCurrentRectAsBillItem;
- (void) setCurrentRectAsTotal;
- (BOOL) clearLastBillItemAndReturnSuccess;
- (BOOL) clearTotalAndReturnSuccess;

- (void) clearCurrentRect;

@end
