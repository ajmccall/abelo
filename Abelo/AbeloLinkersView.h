//
//  AbeloLinkersView.h
//  Abelo
//
//  Created by Alasdair McCall on 26/09/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbeloScaleOffsetView.h"
#import "AbeloTouchableViewProtocol.h"


@interface AbeloLinkersView : AbeloScaleOffsetView<AbeloTouchableViewProtocol>

@property (nonatomic) CGRect receiptViewRect;
@property (nonatomic) CGRect partyMembersViewRect;

@property (nonatomic, readonly) CGPoint startPoint;
@property (nonatomic, readonly) CGPoint endPoint;

- (void) startLinkerFromPoint:(CGPoint) startPoint;
- (void) addToCurrentLinkerPoint:(CGPoint) aPoint;
- (void) setCurrentLinkerWithColor:(UIColor *) color;
- (BOOL) isDrawing;

-(void) clearCurrentLinkers;
@end
