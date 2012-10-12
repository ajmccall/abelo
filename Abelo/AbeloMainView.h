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

@class AbeloMainView;

@protocol AbeloMainViewDelegate

- (void) showPartyMemberController:(AbeloMainView *) sender forViewId:(id) viewId;
- (void) showBillItemController:(AbeloMainView *) sender forViewId:(id) viewId;
- (void) addBillItem:(AbeloMainView *) sender forBillItemViewId:(id) billItemViewId toPartyMemberWithViewId:(id) partyMemberViewId;

@end

@interface AbeloMainView : UIView<AbeloTouchableViewProtocol>

@property (nonatomic, weak) id<AbeloMainViewDelegate> delegate;

#pragma mark - MainView methods

- (void) clearView;
- (void) panGesture:(UIPanGestureRecognizer *)gesture;
- (CGRect) scaleAndTranslateRectIfNecessary:(CGRect) rect;
- (BOOL) isTouchInPartyMembersView:(CGPoint) touchPoint;

#pragma mark - Translation methods

- (CGRect) translateBillItemRectInMainView:(CGRect) billItemRect;
- (CGRect) translatePartyMemberRectInMainView:(CGRect) partyMemberRect;

#pragma mark - ReceiptView methods

@property (nonatomic) UIImage *image;

- (void) addPointToCurrentRect:(CGPoint) fingerPoint;
- (id) setCurrentRectAsBillItem;
- (id) setCurrentRectAsTotal;
- (UIImage *) getImageForRect:(CGRect) rect;
- (void) clearCurrentBillItem;

#pragma mark - PartyMembers view

- (id) addPartyMemberWithName:(NSString *)name andColor:(UIColor *) color;
- (void) updatePartyMemberId:(id) viewId withName:(NSString *)name andColor:(UIColor *) color;
- (void) updatePartyMemberId:(id) viewId withTotal:(int) total andNumberItems:(int) numberItems;

#pragma mark - LinkerView methods

- (void) startLinkerFromPoint:(CGPoint) startPoint;
- (void) addToCurrentLinkerPoint:(CGPoint) aPoint;
- (void) setCurrentLinkerWithColor:(UIColor *) color;
- (BOOL) isDrawing;

@end
