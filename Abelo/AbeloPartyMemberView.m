//
//  AbeloPartyMemberView.m
//  Abelo
//
//  Created by Alasdair McCall on 24/09/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import "AbeloPartyMemberView.h"
#import "AbeloStringDefines.h"
#import "MRGRectMake.h"


@interface AbeloPartyMemberView ()

@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UILabel *totalLabel;

@end

#define NAME_LABEL_HEIGHT 30.0
#define TOTAL_LABEL_HEIGHT 30.0

@implementation AbeloPartyMemberView

#pragma mark - Synthesize

@synthesize name = _name;
@synthesize total = _total;
@synthesize nameLabel = _nameLabel;
@synthesize totalLabel = _totalLabel;
@synthesize color = _color;

- (void)setColor:(UIColor *)color {
    self.nameLabel.backgroundColor = color;
    self.totalLabel.backgroundColor = color;
    self.backgroundColor = color;
    [self setNeedsDisplay];
}

- (UIColor *)color {
    return self.nameLabel.backgroundColor;
}

- (void)setTotal:(int)total {
    _total = total;
    
    int pounds = total / 100;
    int pennies = total % 100;

    self.totalLabel.text = [NSString stringWithFormat:@"£%d.%.2d", pounds, pennies];
    
    if(self.totalLabel.frame.size.height == 0){
        self.totalLabel.frame = CGRectMake(self.frame.origin.x,
                                           NAME_LABEL_HEIGHT,
                                           self.frame.size.width,
                                           TOTAL_LABEL_HEIGHT);
    }
}

- (void)setName:(NSString *)name {
    _name = name;
    self.nameLabel.text = name;
    if(self.nameLabel.frame.size.height ==0){
        self.nameLabel.frame = CGRectMake(self.frame.origin.x,
                                          0,
                                          self.frame.size.width,
                                          NAME_LABEL_HEIGHT);
    }
}

#pragma mark - NSCopyingProtocol

- (id)copyWithZone:(NSZone *)zone {
    return self;
}



#pragma mark - Interface methods

+ (CGFloat) defaultViewHeight {
    return NAME_LABEL_HEIGHT + TOTAL_LABEL_HEIGHT;
}

#pragma mark - Initialise

- (void) setup {
    _nameLabel = [[UILabel alloc] init];
    _totalLabel = [[UILabel alloc] init];
    _totalLabel.textAlignment = UITextAlignmentRight;
    [self addSubview:_nameLabel];
    [self addSubview:_totalLabel];
    self.frame = MRGRectMakeSetHeight(NAME_LABEL_HEIGHT + TOTAL_LABEL_HEIGHT, self.frame);
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
