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
#import "MRGRectMake.h"

#pragma mark - AbeloMainView PRIVATE interface

@interface AbeloMainView()

@property (nonatomic) AbeloReceiptView *receiptView;
@property (nonatomic) AbeloPartyMembersView *partyMembersView;
@property (nonatomic) AbeloLinkersView *linkerView;
@property (nonatomic) UIGestureRecognizer *pinchGesture;

@property (nonatomic) CGFloat drawScale;
@property (nonatomic) CGPoint drawOffset;

@end

#pragma mark - AbeloMainView implementation

@implementation AbeloMainView

@synthesize receiptView = _receiptView;
@synthesize partyMembersView = _partyMembersView;
@synthesize linkerView = _linkerView;

#pragma mark - Property synthesize definitions

@synthesize pinchGesture = _pinchGesture;
@dynamic image;
@synthesize drawOffset = _drawOffset;
@synthesize drawScale = _drawScale;

#pragma mark - Property synthesize implementations

- (void)setImage:(UIImage *)image {
    if(image){
        [self addGestureRecognizer:self.pinchGesture];
    } else {
        [self removeGestureRecognizer:self.pinchGesture];
    }
    
    self.receiptView.image = image;
}

- (UIImage *)image {
    return self.receiptView.image;
}

- (UIGestureRecognizer *)pinchGesture {
    if(!_pinchGesture) {
        _pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
    }
    return _pinchGesture;
}

- (void)setDrawOffset:(CGPoint)drawOffset {
    _drawOffset = drawOffset;
    self.receiptView.drawOffset = drawOffset;
    self.linkerView.drawOffset = drawOffset;
}

- (void)setDrawScale:(CGFloat)drawScale {
    _drawScale = drawScale;
    self.receiptView.drawScale = drawScale;
    self.linkerView.drawScale = drawScale;
}

#pragma mark - MainView methods

- (void)clearView {
    
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


#pragma mark - Gesture recognizer

- (void)pinchGesture:(UIPinchGestureRecognizer *)gesture {
    
    [self.linkerView clearCurrentLinkers];
    [self.receiptView clearCurrentRect];
    
    //scale the receipt view
    if(gesture.state == UIGestureRecognizerStateBegan){
        gesture.scale = self.drawScale;
    } else if(gesture.state == UIGestureRecognizerStateChanged){
        self.drawScale = gesture.scale;
        CGPoint midPoint = [gesture locationInView:self];
        CGFloat x = midPoint.x + self.drawScale * (self.frame.origin.x - midPoint.x);
        CGFloat y = midPoint.y + self.drawScale * (self.frame.origin.y - midPoint.y);
        self.drawOffset = CGPointMake(x,y);
    }
}

- (void)panGesture:(UIPanGestureRecognizer *)gesture {
    
    // if two-finger pan gesture inside the receiptView
    if(gesture.numberOfTouches == 2 &&
       (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged)) {
        
        [self.linkerView clearCurrentLinkers];
        [self.receiptView clearCurrentRect];

        self.drawOffset = CGPointMake(self.drawOffset.x + [gesture translationInView:self].x,
                                      self.drawOffset.y + [gesture translationInView:self].y);
        [gesture setTranslation:CGPointMake(0,0) inView:self];
    }
}

#pragma mark - Draw methods

#pragma mark - View initialisation

#define PARTY_MEMBERS_VIEW_WIDTH 150.0

- (void) setupView {
    
    self.drawOffset = CGPointMake(0,0);
    self.drawScale = 1.0;
    
    _receiptView = [[AbeloReceiptView alloc] initWithFrame:CGRectMake(0,
                                                                      0,
                                                                      self.frame.size.width - PARTY_MEMBERS_VIEW_WIDTH,
                                                                      self.frame.size.height)];
    
    _partyMembersView = [[AbeloPartyMembersView alloc] initWithFrame:CGRectMake(self.frame.size.width - PARTY_MEMBERS_VIEW_WIDTH, 0, PARTY_MEMBERS_VIEW_WIDTH, self.frame.size.height)];
    
    _linkerView = [[AbeloLinkersView alloc] initWithFrame:MRGRectMakeSetXY(0, 0, self.frame)];
    
    _linkerView.receiptViewRect = _receiptView.frame;
    _linkerView.partyMembersViewRect = _partyMembersView.frame;
    
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
