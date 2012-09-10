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
//@property (nonatomic, readonly) double totalRemaing;

- (int) addPartyEntity:(NSString *) entityName;

/*
- (id) addBillItem:(NSString *) itemName withTotal:(double) itemTotal andQuantity:(int) quantity;

- (id) addBillItem:(NSString *) itemName withTotal:(double) itemTotal;

- (void) partyEntity:(id) entity paided:(double) amount towardBillItem:(id) billItem;

- (void) partyEntity:(id) entity paidedInFullForBillItem:(id) billItem;

- (void) partyEntity:(id)entity paidedAPercentage:(double) percent towardBillItem:(id) billItem;
*/
@end
