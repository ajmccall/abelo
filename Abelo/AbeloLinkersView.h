//
//  AbeloLinkersView.h
//  Abelo
//
//  Created by Alasdair McCall on 26/09/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbeloScaleOffsetView.h"


@interface AbeloLinkersView : AbeloScaleOffsetView

@property (nonatomic) CGRect receiptViewRect;
@property (nonatomic) CGRect partyMembersViewRect;

- (void) startLinkerFromPoint:(CGPoint) startPoint;
- (void) addToCurrentLinkerPoint:(CGPoint) aPoint;
- (void) setCurrentLinkerWithColor:(UIColor *) color;
- (BOOL) isDrawing;

-(void) clearCurrentLinkers;
@end
