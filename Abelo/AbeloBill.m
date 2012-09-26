//
//  AbeloBill.m
//  Abelo
//
//  Created by Alasdair McCall on 06/09/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import "AbeloBill.h"

#pragma mark - PartyMemberBillItem

@interface PartyMemberBillItem : NSObject

@property (nonatomic) NSNumber *partyMember;
@property (nonatomic) NSNumber *billItem;
@property (nonatomic) float percentageShared;

@end

@implementation PartyMemberBillItem

@synthesize partyMember = _partyMember;
@synthesize billItem = _billItem;
@synthesize percentageShared = _percentageShared;

@end

#pragma mark - AbeloBill private interface 

@interface AbeloBill()

@property (nonatomic) NSMutableDictionary *partyMembers;
@property (nonatomic) int nextPartyMemberKey;
@property (nonatomic) NSMutableDictionary *billItems;
@property (nonatomic) int nextBillItemKey;
@property (nonatomic) NSMutableArray *menuItemsLinked;

@end

#pragma mark - AbeloBill implementation

@implementation AbeloBill

@synthesize partyMembers = _partyMembers;

#pragma mark - Synthesize

@synthesize nextPartyMemberKey = _nextPartyMemberKey;
@synthesize billItems = _billItems;
@synthesize nextBillItemKey = _nextBillItemKey;
@synthesize total = _total;
@synthesize menuItemsLinked = _menuItemsLinked;

- (NSMutableDictionary *)partyMembers {
    if(_partyMembers){
        _partyMembers = [[NSMutableDictionary alloc] init];
    }
    
    return _partyMembers;
}

- (NSMutableDictionary *)billItems {
    if(!_billItems){
        _billItems = [[NSMutableDictionary alloc] init];
    }
    return _billItems;
}

- (NSMutableArray *)menuItemsLinked {
    if(!_menuItemsLinked){
        _menuItemsLinked = [[NSMutableArray alloc] init];
    }
    return _menuItemsLinked;
}

#pragma mark - Method implementations

- (int)addPartyMemberWithName:(NSString *)name {
    int newKey = ++self.nextPartyMemberKey;
    [self.partyMembers setObject:name forKey:[NSNumber numberWithInt:newKey]];
    
    return newKey;
}

- (void)removePartyMemberWithKey:(int)key {
    [self.partyMembers removeObjectForKey:[NSNumber numberWithInt:key]];
}

- (float)billTotalForPartyMemberWithKey:(int)key {
    float ret = 0.0;
    NSNumber *pKey = [NSNumber numberWithInt:key];
    if(![self.partyMembers objectForKey:pKey]) {
        return ret;
    }
    
    for (PartyMemberBillItem *partyMemberBillItem in self.menuItemsLinked) {
        if([partyMemberBillItem.partyMember isEqualToNumber:pKey]){
            float billItemValue = [(NSNumber *)[self.billItems objectForKey:partyMemberBillItem.billItem] floatValue];
            ret += billItemValue * partyMemberBillItem.percentageShared;
        }
    }
    
    return ret;
}

- (void)addBillItemWithKey:(int)billKey toPartyMemberWithKey:(int)partyMemberKey {
    NSNumber *pKey = [NSNumber numberWithInt:partyMemberKey];
    NSNumber *bKey = [NSNumber numberWithInt:billKey];
    if(![self.partyMembers objectForKey:pKey] ||
       ![self.billItems objectForKey:bKey]) {
        return;
    }

    PartyMemberBillItem *partyMemberBillItem = [[PartyMemberBillItem alloc] init];
    partyMemberBillItem.partyMember = pKey;
    partyMemberBillItem.billItem = bKey;
    partyMemberBillItem.percentageShared = 1.0;

    [self.menuItemsLinked addObject:partyMemberBillItem];
}

- (int)addBillItem:(NSString *)itemName withTotal:(float)total {
    int newKey = self.nextBillItemKey++;
    [self.billItems setObject:[NSNumber numberWithFloat:total] forKey:[NSNumber numberWithInt:newKey]];
    
    return newKey;
    
}

@end
	