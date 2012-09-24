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

- (void)setColor:(UIColor *)color {
    self.nameLabel.backgroundColor = color;
    self.totalLabel.backgroundColor = color;
    [self setNeedsDisplay];
}

- (void)setTotal:(float)total {
    _total = total;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setLocale:[NSLocale currentLocale]];
    NSString *localisedMoneyString = [formatter stringFromNumber:[NSNumber numberWithFloat:total]];

    self.totalLabel.text = localisedMoneyString;
    
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

#pragma mark - Interface methods

+ (CGFloat)DefaultViewSize {
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
