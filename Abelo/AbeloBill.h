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

- (int) addPartyMemberWithName:(NSString *) name;
- (void) removePartyMemberWithKey:(int) key;
- (float) billTotalForPartyMemberWithKey:(int) key;
- (void) addBillItemWithKey:(int) billKey toPartyMemberWithKey:(int) partyMemberKey;

#pragma mark - BillItem methods

- (int) addBillItem:(NSString *) itemName withTotal:(float) total;

#pragma mark - Linker methods

/*
- (id) addBillItem:(NSString *) itemName withTotal:(double) itemTotal andQuantity:(int) quantity;

- (void) partyEntity:(id) entity paided:(double) amount towardBillItem:(id) billItem;

- (void) partyEntity:(id) entity paidedInFullForBillItem:(id) billItem;

- (void) partyEntity:(id)entity paidedAPercentage:(double) percent towardBillItem:(id) billItem;
*/
@end
