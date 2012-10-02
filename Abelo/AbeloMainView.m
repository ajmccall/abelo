//
//  AbeloMainView.m
//  Abelo
//
//  Created by Alasdair McCall on 26/09/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import "AbeloMainView.h"
#import "AbeloReceiptView.h"
#import "AbeloPartyMembersView.h"
#import "AbeloLinkersView.h"

#pragma mark - AbeloMainView PRIVATE interface

@interface AbeloMainView()

@property (nonatomic) AbeloReceiptView *receiptView;
@property (nonatomic) AbeloPartyMembersView *partyMembersView;
@property (nonatomic) AbeloLinkersView *linkerView;
@end

#pragma mark - AbeloMainView implementation

@implementation AbeloMainView

@synthesize receiptView = _receiptView;
@synthesize partyMembersView = _partyMembersView;
@synthesize linkerView = _linkerView;

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

- (void)clearView {
    
}

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

#pragma mark - PatyMember methods

- (void)addPartyMemberWithName:(NSString *)name {
    [self.partyMembersView addPartyMemberWithName:name];
}

- (void)partyMembersViewDelegate:(id)delegate {
    self.partyMembersView.delegate = delegate;
}

#pragma mark - LinkerView methods

- (void)startLinkerFromPoint:(CGPoint)startPoint {
    [self.linkerView startLinkerFromPoint:startPoint];
}

- (void)addToCurrentLinkerPoint:(CGPoint)aPoint {
    [self.linkerView addToCurrentLinkerPoint:aPoint];
}

- (void)setCurrentLinkerWithColor:(UIColor *)color {
    [self.linkerView setCurrentLinkerWithColor:color];
}

- (BOOL)isDrawing {
    return [self.linkerView isDrawing];
}

#pragma mark - Gesture recognizers

#pragma mark - Draw methods

#pragma mark - View initialisation

#define PARTY_MEMBERS_VIEW_WIDTH 150.0

- (void) setupView {
    
    _receiptView = [[AbeloReceiptView alloc] initWithFrame:CGRectMake(0,
                                                                      0,
                                                                      self.frame.size.width - PARTY_MEMBERS_VIEW_WIDTH,
                                                                      self.frame.size.height)];
    
    _partyMembersView = [[AbeloPartyMembersView alloc] initWithFrame:CGRectMake(self.frame.size.width - PARTY_MEMBERS_VIEW_WIDTH, 0, PARTY_MEMBERS_VIEW_WIDTH, self.frame.size.height)];
    
    _linkerView = [[AbeloLinkersView alloc] initWithFrame:self.frame];
    
    [self addSubview:self.receiptView];
    [self addSubview:self.partyMembersView];
    [self addSubview:self.linkerView];
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
