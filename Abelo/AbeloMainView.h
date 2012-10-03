//
//  AbeloMainView.h
//  Abelo
//
//  Created by Alasdair McCall on 26/09/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbeloPartyMembersView.h"
#import "AbeloTouchableViewProtocol.h"

@interface AbeloMainView : UIView<AbeloTouchableViewProtocol>

#pragma mark - MainView methods

- (void) clearView;
- (void) panGesture:(UIPanGestureRecognizer *)gesture;

#pragma mark - ReceiptView methods

@property (nonatomic) UIImage *image;
- (void) addPointToCurrentRect:(CGPoint) fingerPoint;
- (id) setCurrentRectAsBillItem;
- (id) setCurrentRectAsTotal;

#pragma mark - PartyMembers view

-(void) partyMembersViewDelegate:(id<AbeloPartyMembersViewProtocol>) delegate;
-(id) addPartyMemberWithName:(NSString *)name;


#pragma mark - LinkerView methods

- (void) startLinkerFromPoint:(CGPoint) startPoint;
- (void) addToCurrentLinkerPoint:(CGPoint) aPoint;
- (void) setCurrentLinkerWithColor:(UIColor *) color;
- (BOOL) isDrawing;

@end
