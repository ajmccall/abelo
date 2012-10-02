//
//  AbeloMainView.h
//  Abelo
//
//  Created by Alasdair McCall on 26/09/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AbeloMainView : UIView

#pragma mark - MainView methods

- (void) clearView;

#pragma mark - ReceiptView methods

@property (nonatomic) UIImage *image;
- (void) addPointToCurrentRect:(CGPoint) fingerPoint;
- (void) setCurrentRectAsMenuItem;
- (void) setCurrentRectAsTotal;
- (BOOL) clearLastMenuItem;

#pragma mark - PartyMembers view

-(void) addPartyMemberWithName:(NSString *)name;

#pragma mark - LinkerView methods

- (void) startLinkerFromPoint:(CGPoint) startPoint;
- (void) addToCurrentLinkerPoint:(CGPoint) aPoint;
- (void) finishCurrentLinkerSetId:(int) linkerId withColor:(UIColor *) color;
- (BOOL) isDrawing;

@end
