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
#import "AbeloPartyMemberView.h"
#import "AbeloLinkersView.h"
#import "MRGRectMake.h"
#import "MRGLog.h"

enum TouchState {
    TouchStateBillItem,
    TouchStatePartyMember,
    TouchStateLinker,
    TouchStateNone
} typedef TouchState;

#pragma mark - AbeloMainView PRIVATE interface

@interface AbeloMainView()

@property (nonatomic) AbeloReceiptView *receiptView;
@property (nonatomic) AbeloPartyMembersView *partyMembersView;
@property (nonatomic) AbeloLinkersView *linkerView;
@property (nonatomic) UIGestureRecognizer *pinchGesture;
@property (nonatomic) UITapGestureRecognizer *tapGesture;
@property (nonatomic) UIGestureRecognizer *panGesture;
@property (nonatomic) CGFloat drawScale;
@property (nonatomic) CGPoint drawOffset;
@property (nonatomic) TouchState touchState;


@end

#pragma mark - AbeloMainView implementation

@implementation AbeloMainView

@synthesize receiptView = _receiptView;
@synthesize partyMembersView = _partyMembersView;
@synthesize linkerView = _linkerView;

#pragma mark - Property synthesize definitions

@synthesize delegate = _delegate;
@dynamic image;
@synthesize drawOffset = _drawOffset;
@synthesize drawScale = _drawScale;

@synthesize pinchGesture = _pinchGesture;
@synthesize tapGesture = _tapGesture;
@synthesize panGesture = _panGesture;

@synthesize touchState = _touchState;

#pragma mark - Property synthesize implementations

- (void)setImage:(UIImage *)image {
    if(image){
        [self addGestureRecognizer:self.pinchGesture];
        [self addGestureRecognizer:self.panGesture];
    } else {
        [self removeGestureRecognizer:self.pinchGesture];
        [self removeGestureRecognizer:self.panGesture];
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

- (UITapGestureRecognizer *)tapGesture {
    if(!_tapGesture){
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        _tapGesture.numberOfTapsRequired = 1;
        _tapGesture.numberOfTouchesRequired = 1;
        
    }
    
    return _tapGesture;
}

- (UIGestureRecognizer *)panGesture {
    if(!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    }
    return _panGesture;
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

- (CGRect) scaleAndTranslateRectIfNecessary:(CGRect)rect {
    
    if(CGRectContainsRect(self.receiptView.frame, rect)){
        return [self.receiptView reverseTranslateAndScaleRect:rect];
    }
    
    return rect;    
}

- (BOOL)isTouchInPartyMembersView:(CGPoint)touchPoint {
    return CGRectContainsPoint(self.partyMembersView.frame, touchPoint);
}

#pragma mark - Translation methods

- (CGRect)translateBillItemRectInMainView:(CGRect)billItemRect {
    return billItemRect;
}

- (CGRect)translatePartyMemberRectInMainView:(CGRect)partyMemberRect {
    return MRGRectMakeSetX(self.receiptView.frame.size.width + partyMemberRect.origin.x, partyMemberRect);
}

#pragma mark - AbeloTouchableViewProtocol

- (id)anyUIViewAtPoint:(CGPoint)point{
    //return any view id from the either receiptView, partyMembersView, linkersView
    if([self.receiptView anyUIViewAtPoint:point]) {
        return [self.receiptView anyUIViewAtPoint:point];
    } else if([self.partyMembersView anyUIViewAtPoint:point]){
        return [self.partyMembersView anyUIViewAtPoint:point];
    } else if([self.linkerView anyUIViewAtPoint:point]){
        return [self.linkerView anyUIViewAtPoint:point];
    }
    
    // or nil if none exists
    return nil;
}

- (NSArray *)uiViewsAtPoint:(CGPoint)point {
    // return array by combining arrays from receiptView, partyMembersView, linkersView
    return [[[self.linkerView uiViewsAtPoint:point] arrayByAddingObjectsFromArray:[self.partyMembersView uiViewsAtPoint:point]] arrayByAddingObjectsFromArray:[self.receiptView uiViewsAtPoint:point]];
}

#pragma mark - ReceiptView methods

- (void)addPointToCurrentRect:(CGPoint)fingerPoint {
    [self.receiptView addPointToCurrentRect:fingerPoint];
}

- (id)setCurrentRectAsBillItem {
    return [self.receiptView setCurrentRectAsBillItem];
}

- (id)setCurrentRectAsTotal {
    return [self.receiptView setCurrentRectAsTotal];
}

- (UIImage *)getImageForRect:(CGRect)rect {
    return [self.receiptView getImageForRect:rect];
}

- (void)clearCurrentBillItem {
    [self.receiptView clearCurrentRect];
}

#pragma mark - PatyMember methods

- (id) addPartyMemberWithName:(NSString *)name andColor:(UIColor *)color {
    return [self.partyMembersView addPartyMemberWithName:name andColor:color];
}

- (void)updatePartyMemberId:(id)viewId withName:(NSString *)name andColor:(UIColor *)color {

    AbeloPartyMemberView *view = (AbeloPartyMemberView *) viewId;
    view.name = name;
    [view setColor:color];
}

- (void)updatePartyMemberId:(id)viewId withTotal:(int)total andNumberItems:(int)numberItems {
    AbeloPartyMemberView *view = (AbeloPartyMemberView *) viewId;
    view.total = total;
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


- (void)tapGesture:(UITapGestureRecognizer *)gesture {

    // tap gesture clears touchState as they are used  for panGesture
    self.touchState = TouchStateNone;
    [self.linkerView clearCurrentLinkers];
    [self.receiptView clearCurrentRect];

    if([self.receiptView anyUIViewAtPoint:[gesture locationInView:self.receiptView]]){
        [self.delegate showBillItemController:self forViewId:[self.receiptView anyUIViewAtPoint:[gesture locationInView:self.receiptView]]];
    } else if([self.partyMembersView anyUIViewAtPoint:[gesture locationInView:self.partyMembersView]]) {
        [self.delegate showPartyMemberController:self forViewId:[self.partyMembersView anyUIViewAtPoint:[gesture locationInView:self.partyMembersView]]];
    } else if([self isTouchInPartyMembersView:[gesture locationInView:self.partyMembersView]]){
        [self.delegate showPartyMemberController:self forViewId:nil];
    }
    
}

- (void)panGesture:(UIPanGestureRecognizer *)gesture {
    
    if(gesture.numberOfTouches == 0){
        
        if(self.touchState == TouchStateBillItem){
            id viewId = [self.receiptView anyUIViewAtPoint:[gesture locationInView:self.receiptView]];
            if(viewId){
                [self.delegate showBillItemController:self forViewId:viewId];
            }
        }
        
        if(self.touchState == TouchStateLinker){
            
            //if the points ends inside of label within the partyMemberVC
            id viewId = [self.partyMembersView anyUIViewAtPoint:[gesture locationInView:self.partyMembersView]];
            if(viewId) {

                [self addToCurrentLinkerPoint:[gesture locationInView:self]];
                
                //beware, THIS IS A HACK!
                id pId = [self.partyMembersView anyUIViewAtPoint:[gesture locationInView:self.partyMembersView]];
                id bId = [self.receiptView anyUIViewAtPoint:self.linkerView.startPoint];
                
                [self setCurrentLinkerWithColor:[UIColor colorWithRed:0.5 green:1.0 blue:0.33 alpha:0.8]];
                
                
                [self.delegate addBillItem:self
                         forBillItemViewId:bId
                   toPartyMemberWithViewId:pId];
                
//                [self.delegate showLinkerController:self
//                                  forBillItemViewId: billItemViewId
//                               andPartyMemberViewId: partyMemberViewId];
            } else {
                [self.linkerView clearCurrentLinkers];
            }
        }
        
    } else if(gesture.numberOfTouches == 1){
        
        if(self.touchState == TouchStateBillItem){
            if(gesture.state == UIGestureRecognizerStateBegan ||
               gesture.state == UIGestureRecognizerStateChanged) {
                if(CGRectContainsPoint(self.receiptView.frame, [gesture locationInView:self.receiptView])) {
                    [self addPointToCurrentRect:[gesture locationInView:self.receiptView]];
                }
            } else {
                DLog(@"panGesture.state unknown[%d]", gesture.state);
            }
        } else if(self.touchState == TouchStateLinker){
            if(gesture.state == UIGestureRecognizerStateBegan ||
               gesture.state == UIGestureRecognizerStateChanged) {
                [self addToCurrentLinkerPoint:[gesture locationInView:self]];
            } else {
                DLog(@"gesture.state[%d] unknow", gesture.state);
            }
        }
        
    } else if(gesture.numberOfTouches == 2 &&
           (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged)) {
            
            [self.linkerView clearCurrentLinkers];
            [self.receiptView clearCurrentRect];
            
            self.drawOffset = CGPointMake(self.drawOffset.x + [gesture translationInView:self].x,
                                          self.drawOffset.y + [gesture translationInView:self].y);
            [gesture setTranslation:CGPointMake(0,0) inView:self];
        }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    
    // add touch if we are drawing menu itme rectaganles or the total rectangles
    if([touches count] == 1){
        
        //if the touch is in the receipt view then, add to current rect
        if(CGRectContainsPoint(self.receiptView.frame, touchPoint)) {
            
            if([self.receiptView anyUIViewAtPoint:touchPoint]) {
                self.touchState = TouchStateLinker;
                [self startLinkerFromPoint:touchPoint];
//                DLog(@"Found at at a billItem");
            } else {
                self.touchState = TouchStateBillItem;
                [self addPointToCurrentRect:touchPoint];
            }
        }
        
        
//        if(self.viewsDrawState == ViewsDrawStateBillItems ||
//           self.viewsDrawState == ViewsDrawStateTotal) {
        
            //            if([self.mainView anyUIViewAtPoint:touchPoint]){
            //                NSArray *viewIds = [self.mainView uiViewsAtPoint:touchPoint];
            //                for (id viewId in viewIds) {
            //                    if([self.bill billItemExistForViewId:viewId]) {
            //                        [self showBillItemViewControllerAtView:viewId];
            //                        break;
            //                    }
            //                }
            //            }
            
//        } else if(self.viewsDrawState == ViewsDrawStateLinking){
        
            //check that a uiView exists
            if([self anyUIViewAtPoint:touchPoint]){
//                if([self.bill billItemExistForViewId:[[self.mainView uiViewsAtPoint:touchPoint] objectAtIndex:0]]){
//                    [self startLinkerFromPoint:touchPoint];
//                }
//            }
        }
    }
}

#pragma mark - Draw methods

#pragma mark - View initialisation

#define PARTY_MEMBERS_VIEW_WIDTH 150.0

- (void) setupView {
    
    self.touchState = TouchStateNone;
    
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
    
    [self addGestureRecognizer:self.tapGesture];
    
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
