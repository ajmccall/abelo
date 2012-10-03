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
@property (nonatomic) NSMutableDictionary *billItems;
@property (nonatomic) NSMutableArray *billItemsLinked;

@end

#pragma mark - AbeloBill implementation

@implementation AbeloBill

@synthesize partyMembers = _partyMembers;

#pragma mark - Synthesize

@synthesize billItems = _billItems;
@synthesize total = _total;
@synthesize billItemsLinked = _billItemsLinked;

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

- (NSMutableArray *)billItemsLinked {
    if(!_billItemsLinked){
        _billItemsLinked = [[NSMutableArray alloc] init];
    }
    return _billItemsLinked;
}

#pragma mark - Method implementations

- (void)addPartyMemberWithViewId:(id)viewId withName:(NSString *)name {
    [self.partyMembers setObject:name forKey:viewId];
}

- (void)removePartyMemberForViewId:(id)viewId {
    [self.partyMembers removeObjectForKey:viewId];
}

- (float)billTotalForPartyMemberForViewId:(id)viewId {
    float ret = 0.0;
    if(![self.partyMembers objectForKey:viewId]) {
        return -1;
    }

//    for (PartyMemberBillItem *partyMemberBillItem in self.billItemsLinked) {
//        if([partyMemberBillItem.partyMember isEqualToNumber:viewId]){
//            float billItemValue = [(NSNumber *)[self.billItems objectForKey:partyMemberBillItem.billItem] floatValue];
//            ret += billItemValue * partyMemberBillItem.percentageShared;
//        }
//    }
    
    return ret;
}

- (BOOL)partyMemberExitForViewId:(id)viewId {
    return ![self.partyMembers objectForKey:viewId];
}

#pragma mark - Linker methods

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

    [self.billItemsLinked addObject:partyMemberBillItem];
}

#pragma mark - BillItem methods

- (void)addBillItemWithId:(id)viewId withTotal:(float)total {
    [self.billItems setObject:[NSNumber numberWithFloat:total] forKey:viewId];
}

- (BOOL)billItemExistForViewId:(id)viewId {
    return ![self.billItems objectForKey:viewId];
}
@end
	