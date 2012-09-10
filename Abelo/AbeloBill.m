//
//  AbeloBill.m
//  Abelo
//
//  Created by Alasdair McCall on 06/09/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import "AbeloBill.h"


@interface AbeloBill()

@property (nonatomic) NSMutableArray *partyEntities;

@end

@implementation AbeloBill

@synthesize partyEntities = _partyEntities;
@synthesize total = _total;

- (NSMutableArray *)partyEntities {
    if(_partyEntities){
        _partyEntities = [[NSMutableArray alloc] init];
    }
    
    return _partyEntities;
}

- (int)addPartyEntity:(NSString *)entityName {
    [self.partyEntities addObject:entityName];
    
    return [self.partyEntities count];
}

@end
	