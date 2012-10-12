//
//  AbeloBill.m
//  Abelo
//
//  Created by Alasdair McCall on 06/09/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import "AbeloBill.h"
#import "MRGLog.h"

#pragma mark MODEL
#pragma mark PartyMemberModel interface

@interface PartyMemberModel : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) UIColor *color;
@property (nonatomic) NSMutableDictionary *billItemsAndPercentages;
@property (nonatomic, readonly) int numberOfItems;

@end

#pragma mark - PartyMemberModel implementation

@implementation PartyMemberModel

@synthesize name = _name;
@synthesize color = _color;
@synthesize billItemsAndPercentages = _billItemsAndPercentages;
@dynamic numberOfItems;

- (int)numberOfItems {
    return [self.billItemsAndPercentages count];
}

- (NSMutableDictionary *) billItemsAndPercentages {
    if(!_billItemsAndPercentages) {
        _billItemsAndPercentages = [NSMutableDictionary dictionary];
    }
    return _billItemsAndPercentages;
}

@end

#pragma mark - AbeloBill PRIVATE interface 

@interface AbeloBill()

@property (nonatomic) NSMutableDictionary *partyMembers;
@property (nonatomic) NSMutableDictionary *billItems;

@end

#pragma mark - AbeloBill implementation

@implementation AbeloBill

#pragma mark - Properties synthesis and definitions

@synthesize partyMembers = _partyMembers;
@synthesize billItems = _billItems;
@synthesize total = _total;

- (NSMutableDictionary *)partyMembers {
    if(!_partyMembers){
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

#pragma mark - PartyMember implementations

- (void)setPartyMemberWithId:(id)partyMemberId name:(NSString *)name color:(UIColor *)color {
    
    PartyMemberModel *pm = [self.partyMembers objectForKey:partyMemberId];
    if(!pm) {
        pm = [[PartyMemberModel alloc] init];
    }
    pm.name = name;
    pm.color = color;
    
    [self.partyMembers setObject:pm forKey:partyMemberId];
}

- (void)removePartyMemberForId:(id)partyMemberId {
    [self.partyMembers removeObjectForKey:partyMemberId];
}

- (int)partyMemberTotalForId:(id)partyMemberId {
    int total = 0.0;
    PartyMemberModel *pm = [self.partyMembers objectForKey:partyMemberId];
    NSMutableDictionary *dic = pm.billItemsAndPercentages;
    for(id key in dic){
        total += [((NSNumber *)[self.billItems objectForKey:key]) intValue];
    }
    
    return total;
}

- (NSString *) partyMemberNameForId:(id)partyMemberId {
    PartyMemberModel *pm = [self.partyMembers objectForKey:partyMemberId];
    return pm.name;
}

- (int)numberOfItemsForPartyMemberForId:(id)partyMemberId {
    PartyMemberModel *pm = [self.partyMembers objectForKey:partyMemberId];
    return pm.numberOfItems;
}

- (NSArray *)partyMemberBillItemsForId:(id)partyMemberId {
    DLog(@"NOT IMPLEMENTED YET");
    return nil;
}

- (UIColor *)partyMemberColorForId:(id)partyMemberId {
    PartyMemberModel *pm = [self.partyMembers objectForKey:partyMemberId];
    return pm.color;
}

#pragma mark - Linker methods

- (void)addBillItemWithId:(id)billItemId toPartyMemberWithId:(id)partyMemberId {
    [self addBillItemWithId:billItemId toPartyMemberWithId:partyMemberId withPercentage:1.0];
}

- (void)addBillItemWithId:(id)billItemId toPartyMemberWithId:(id)partyMemberId withPercentage:(float)percent {
    PartyMemberModel *pm = [self.partyMembers objectForKey:partyMemberId];
    [pm.billItemsAndPercentages setObject:[NSNumber numberWithFloat:percent] forKey:billItemId];
}

#pragma mark - BillItem methods

- (void)setBillItemWithId:(id)billItemId withTotal:(int)total {
    [self.billItems setObject:[NSNumber numberWithInt:total] forKey:billItemId];
}

- (void)removeBillItemForId:(id)billItemId {
    DLog(@"NOT IMPLEMENTED YET");
    //todo: go through all partymember bill items and remove them?
}

- (BOOL)billItemExistForId:(id)billItemId {
    return [self.billItems objectForKey:billItemId] != nil;
}

- (int)billItemTotalForId:(id)billItemId {
    return [((NSNumber *)[self.billItems objectForKey:billItemId]) intValue];
}

@end