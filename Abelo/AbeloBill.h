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

- (void) setPartyMemberWithId:(id) partyMemberId name:(NSString *) name color:(UIColor *) color;
- (void) removePartyMemberForId:(id) partyMemberId;
- (NSString *) partyMemberNameForId:(id) partyMemberId;
- (int) partyMemberTotalForId:(id) partyMemberId;
- (int) numberOfItemsForPartyMemberForId:(id) partyMemberId;
- (NSArray *) partyMemberBillItemsForId:(id) partyMemberId;

- (UIColor *) partyMemberColorForId:(id) partyMemberId;

#pragma mark - BillItem methods

- (void) setBillItemWithId:(id) billItemId withTotal:(int) total;
- (void) removeBillItemForId:(id) billItemId;
- (int) billItemTotalForId:(id) billItemId;
- (BOOL) billItemExistForId:(id) billItemId;

#pragma mark - Linker methods

- (void) addBillItemWithId:(id) billItemId toPartyMemberWithId:(id) partyMemberId withPercentage:(float) percent;
- (void) addBillItemWithId:(id) billItemId toPartyMemberWithId:(id) partyMemberId;

/*
- (id) addBillItem:(NSString *) itemName withTotal:(double) itemTotal andQuantity:(int) quantity;

- (void) partyEntity:(id) entity paided:(double) amount towardBillItem:(id) billItem;

- (void) partyEntity:(id) entity paidedInFullForBillItem:(id) billItem;

- (void) partyEntity:(id)entity paidedAPercentage:(double) percent towardBillItem:(id) billItem;
*/
@end
