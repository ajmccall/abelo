//
//  AbeloPartyMembersView.m
//  Abelo
//
//  Created by Alasdair McCall on 21/09/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import "AbeloPartyMembersView.h"
#import "AbeloPartyMemberView.h"
#import "MRGRectMake.h"

@interface AbeloPartyMembersView ()

@property (nonatomic) CGFloat newPartyMemberViewPosition;
@property (nonatomic) int labelIndex;
@property (nonatomic) NSMutableDictionary *partyMembers;
@end

@implementation AbeloPartyMembersView

@synthesize labelIndex = _labelIndex;
@synthesize partyMembers = _partyMembers;
@synthesize newPartyMemberViewPosition = _newPartyMemberViewPosition;

#pragma mark - Method implementations

- (void)addPartyMemberWithName:(NSString *)name {
    
    AbeloPartyMemberView *view = [[AbeloPartyMemberView alloc] init];
    view.frame = MRGRectMakeSetXY(0, self.newPartyMemberViewPosition, view.frame);
    view.frame = MRGRectMakeSetWidth(self.frame.size.width, view.frame);
    view.name = name;
    view.total = 0;
    
    if(self.labelIndex % 2 == 0) {
        [view setColor:[UIColor yellowColor]];
    } else {
        [view setColor:[UIColor cyanColor]];
    }

    self.labelIndex++;
    self.newPartyMemberViewPosition = self.newPartyMemberViewPosition + view.frame.size.height;

    [self.partyMembers setObject:view forKey:[NSNumber numberWithInt:self.labelIndex]];
    [self addSubview:view];
}


#pragma mark - Initialise

- (void) setup {
    self.newPartyMemberViewPosition = 0;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [self setup];
}

@end
