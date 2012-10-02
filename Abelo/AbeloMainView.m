//
//  AbeloMainView.m
//  Abelo
//
//  Created by Alasdair McCall on 26/09/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import "AbeloMainView.h"
#import "AbeloReceiptView.h"

#pragma mark - AbeloMainView PRIVATE interface

@interface AbeloMainView()

@property (nonatomic) AbeloReceiptView *receiptView;

@end

#pragma mark - AbeloMainView implementation

@implementation AbeloMainView

@synthesize receiptView = _receiptView;

#pragma mark - Property synthesize definitions

@dynamic image;

#pragma mark - Property synthesize implementations

- (void)setImage:(UIImage *)image {
    self.receiptView.image = image;
}

- (UIImage *)image {
    return self.receiptView.image;
}


#pragma mark - MainView methods

- (void)panGesture:(UIPanGestureRecognizer *)gesture {
    [self.receiptView panGesture:gesture];
}

#pragma mark - ReceiptView methods

- (void)addPointToCurrentRect:(CGPoint)fingerPoint {
    [self.receiptView addPointToCurrentRect:fingerPoint];
}

- (void)setCurrentRectAsMenuItem {
    [self.receiptView setCurrentRectAsMenuItem];
}

- (void)setCurrentRectAsTotal {
    [self.receiptView setCurrentRectAsTotal];
}

#pragma mark - Gesture recognizers



#pragma mark - Draw methods

//- (void)drawRect:(CGRect)rect {
//
//}

#pragma mark - View initialisation

#define PARTY_MEMBERS_VIEW_WIDTH 150.0

- (void) setupView {
    
    _receiptView = [[AbeloReceiptView alloc] initWithFrame:CGRectMake(0,
                                                                      0,
                                                                      self.frame.size.width - PARTY_MEMBERS_VIEW_WIDTH,
                                                                      self.frame.size.height)];
    
    [self addSubview:self.receiptView];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)awakeFromNib {
    [self setupView];
}

@end
