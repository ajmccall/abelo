//
//  AbeloPartyMembersView.m
//  Abelo
//
//  Created by Alasdair McCall on 21/09/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import "AbeloPartyMembersView.h"

@interface AbeloPartyMembersView ()

@property (nonatomic) CGPoint newLabelPoint;
@property (nonatomic) int labelIndex;
@end

@implementation AbeloPartyMembersView

@synthesize labelIndex = _labelIndex;

#pragma mark - Method implementations

- (void)addPartyMemberWithName:(NSString *)name {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.newLabelPoint.x,
                                                               self.newLabelPoint.y,
                                                               self.frame.size.width,
                                                               33)
                      ];
    label.text = name;
    [self addSubview:label];
    if(self.labelIndex % 2 == 0) {
        label.backgroundColor = [UIColor yellowColor];
    } else {
        label.backgroundColor = [UIColor cyanColor];
    }
    self.labelIndex++;
    [self setNeedsDisplay];
    self.newLabelPoint = CGPointMake(self.newLabelPoint.x, self.newLabelPoint.y + 33);
}


#pragma mark - Initialise

- (void) setup {
    self.newLabelPoint = CGPointMake(0, 0);

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
