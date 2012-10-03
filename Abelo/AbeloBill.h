//
//  AbeloBill.h
//  Abelo
//
//  Created by Alasdair McCall on 06/09/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AbeloBill : NSObject

@property (nonatomic) double total;

#pragma mark - PartyMember methods

- (void) addPartyMemberWithViewId:(id) viewId withName:(NSString *) name;
- (void) removePartyMemberForViewId:(id) viewId;
- (BOOL) partyMemberExitForViewId:(id) viewId;
- (float) billTotalForPartyMemberForViewId:(id) viewId;

#pragma mark - BillItem methods

- (void) addBillItemWithId:(id) viewId withTotal:(float) total;
- (BOOL) billItemExistForViewId:(id) viewId;

#pragma mark - Linker methods

- (void) addBillItemWithKey:(int) billKey toPartyMemberWithKey:(int) partyMemberKey;

/*
- (id) addBillItem:(NSString *) itemName withTotal:(double) itemTotal andQuantity:(int) quantity;

- (void) partyEntity:(id) entity paided:(double) amount towardBillItem:(id) billItem;

- (void) partyEntity:(id) entity paidedInFullForBillItem:(id) billItem;

- (void) partyEntity:(id)entity paidedAPercentage:(double) percent towardBillItem:(id) billItem;
*/
@end
