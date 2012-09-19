//
//  AbeloReceiptView.m
//  Abelo
//
//  Created by Alasdair McCall on 11/09/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import "AbeloReceiptView.h"
#import "AbeloUtilities.h"

typedef struct MenuItemTuple{
    CGPoint topLeft, bottomRight;
} MenuItemTuple;

#pragma mark - Constants

#define NIL_FLOAT -1
#define MAX_SCALE 5.0

@interface AbeloReceiptView ()

@property (nonatomic) CGFloat drawScale;
@property (nonatomic) CGPoint drawOffset;

@property (nonatomic) CGPoint currentTouch;

@property (nonatomic) CGRect currentMenuItemRect;
@property (nonatomic) NSMutableArray *menuItemRects;

@property (nonatomic, readonly) UIColor *redTransparent;
@property (nonatomic, readonly) UIColor *blueTransparent;
@property (nonatomic, readonly) UIColor *greenTransparent;

@property (nonatomic) UIButton *nextButton;
@property (nonatomic) UIButton *backButton;
@property (nonatomic) UIButton *okButton;

- (CGPoint) translateAndScalePoint:(CGPoint) p;

@end

@implementation AbeloReceiptView

@synthesize image = _image;

#pragma mark - Property synthesis

- (void)setImage:(UIImage *)image {
    [self clearView];
    switch ([image imageOrientation]) {
        case UIImageOrientationRight:
            _image = image;
            break;
        default:
            _image = [UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationRight];
            break;
    }
    [self setNeedsDisplay];
}

//buttons
@synthesize nextButton = _nextButton;
@synthesize backButton = _backButton;
@synthesize okButton = _okButton;

- (UIButton *)nextButton {
    if(!_nextButton){
        _nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _nextButton.frame = CGRectMake(18, 947, 85, 37);
        _nextButton.titleLabel.text = @"Next";
        [_nextButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_nextButton];
    }
    return _nextButton;
}

- (UIButton *)backButton {
    if(!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _backButton.frame = CGRectMake(470, 947, 85, 37);
        _backButton.titleLabel.text = @"Back";
        [_backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backButton];
    }
    return _backButton;
}

- (UIButton *)okButton {
    if(!_okButton){
        _okButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _okButton.frame = CGRectMake(261, 947, 85, 37);
        _okButton.titleLabel.text = @"Next";
        [_okButton addTarget:self action:@selector(okButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_okButton];
    }
    return _okButton;
}

//current touch & current rect

@synthesize currentMenuItemRect = _currentMenuItemRect;

- (void)setCurrentMenuItemRect:(CGRect)currentMenuItemRect {
    _currentMenuItemRect = currentMenuItemRect;
    [self setNeedsDisplay];
}

@synthesize currentTouch = _currentTouch;

- (void)setCurrentTouch:(CGPoint)currentTouch {
    _currentTouch = [self translateAndScalePoint:currentTouch];
}

//drawing properties
@synthesize menuItemRects;
@synthesize drawState;
@synthesize drawOffset = _drawOffset;
@synthesize drawScale = _drawScale;

- (void)setDrawOffset:(CGPoint)drawOffset {
    
    //check we're not trying to make hte offset too far outside of the view
    if(drawOffset.x > 0){
        drawOffset.x = 0;
    } else if(self.frame.origin.x - drawOffset.x + self.frame.size.width > self.drawScale * self.frame.size.width){
        drawOffset.x = self.frame.origin.x + self.frame.size.width * (1 - self.drawScale);
    }

    if(drawOffset.y > 0){
        drawOffset.y = 0;
    } else if(self.frame.origin.y - drawOffset.y + self.frame.size.height > self.drawScale * self.frame.size.height){
        drawOffset.y = self.frame.origin.y + self.frame.size.height * (1 - self.drawScale);
    }

    //check if you need to set these values and hence redraw the screen
    if(drawOffset.x == _drawOffset.x &&
       drawOffset.y == _drawOffset.y){
        return;
    }

    _drawOffset = drawOffset;
    [self setNeedsDisplay];
}

- (CGFloat)drawScale{
    if(!_drawScale){
        return 1.0;
    } else {
        return _drawScale;
    }
}

- (void)setDrawScale:(CGFloat)scale {
    if(_drawScale == scale){
        return;
    }
    
    if(scale < 1.0) {
        scale = 1.0;
    } else if(scale > MAX_SCALE) {
        scale = MAX_SCALE;
    }
    _drawScale = scale;
    [self setNeedsDisplay];
    
}

// colors - could be constants
- (UIColor *)redTransparent {
    return [UIColor colorWithRed:255 green:0 blue:0 alpha:0.3];
}

- (UIColor *)greenTransparent {
    return [UIColor colorWithRed:0 green:255 blue:0 alpha:0.3];
}

- (UIColor *)blueTransparent {
    return [UIColor colorWithRed:0 green:0 blue:255 alpha:0.3];
}

#pragma mark - Methods Implementations

- (void)clearView {
    
    self.drawState = ReceiptViewDrawNone;
    
    _currentMenuItemRect = CGRectMake(NIL_FLOAT, NIL_FLOAT, NIL_FLOAT, NIL_FLOAT);
    self.menuItemRects = [NSMutableArray array];
    
    _drawOffset = CGPointMake(0,0);
    _currentTouch = CGPointMake(NIL_FLOAT, NIL_FLOAT);
    _drawScale = 1.0;
    _image = nil;
    [self setNeedsDisplay];
}

- (CGPoint) translateAndScalePoint:(CGPoint) p {
    return CGPointMake((p.x - self.drawOffset.x) / self.drawScale, (p.y - self.drawOffset.y) / self.drawScale);
}

- (CGRect) reverseTranslateAndScaleRect:(CGRect) rect {
    return CGRectMake(self.drawScale * rect.origin.x + self.drawOffset.x,
                      self.drawScale * rect.origin.y + self.drawOffset.y,
                      rect.size.width * self.drawScale, rect.size.height * self.drawScale);
}

#define DEFAULT_FINGER_DIM 6.0
#define FINGER_X_OFFSET 6.0
#define FINGER_Y_OFFSET 20.0
- (CGRect) CGRectMakeFromFingerPoint:(CGPoint) p {
    return CGRectMake(p.x + FINGER_X_OFFSET,
                      p.y - FINGER_Y_OFFSET,
                      DEFAULT_FINGER_DIM,
                      DEFAULT_FINGER_DIM);
}

- (void) addMenuItemPoint:(CGPoint) p {
    
    p = [self translateAndScalePoint:p];
    
    if(self.currentMenuItemRect.origin.x != NIL_FLOAT){
        self.currentMenuItemRect = CGRectUnion(self.currentMenuItemRect, [self CGRectMakeFromFingerPoint:p]);
        return;
    }

    int i = 0;
    bool foundRectContainingPoint = NO;
    while(i < [self.menuItemRects count] && !foundRectContainingPoint) {
        CGRect rect = [[self.menuItemRects objectAtIndex:i] CGRectValue];
        if(CGRectContainsPoint(rect, p)) {
            foundRectContainingPoint = YES;
        } else {
            i++;
        }
    }
    
//    DLog(@"point p(%g, %g) was %@ in array[%d]", p.x, p.y, foundRectContainingPoint ? @"FOUND" : @"NOTFOUND", [self.menuItemRects count]);
    
    CGRect rect = [self CGRectMakeFromFingerPoint:p];
    if(!foundRectContainingPoint) {
        self.currentMenuItemRect = rect;
    } else {
        self.currentMenuItemRect = rect;
//        rect = CGRectUnion(rect, [[self.menuItemRects objectAtIndex:i] CGRectValue]);
//        [self.menuItemRects removeObjectAtIndex:i];
//        [self.menuItemRects insertObject:[NSValue valueWithCGRect:rect] atIndex:i];
    }

    [self setNeedsDisplay];
}

- (void)setCurrentMenuItemAndDrawNext {
    _currentTouch = CGPointMake(NIL_FLOAT, NIL_FLOAT);
    [self.menuItemRects addObject:[NSValue valueWithCGRect:self.currentMenuItemRect]];
    self.currentMenuItemRect = CGRectMake(NIL_FLOAT, NIL_FLOAT, NIL_FLOAT, NIL_FLOAT);
}

#pragma mark -
#pragma mark Gesture recognizers

- (void)pinchGesture:(UIPinchGestureRecognizer *)gesture {
    
    if(gesture.state == UIGestureRecognizerStateBegan){
        gesture.scale = self.drawScale;
    } else if(gesture.state == UIGestureRecognizerStateChanged){
        self.drawScale = gesture.scale;
        CGPoint midPoint = [gesture locationInView:nil];
        CGFloat x = midPoint.x + self.drawScale * (self.frame.origin.x - midPoint.x);
        CGFloat y = midPoint.y + self.drawScale * (self.frame.origin.y - midPoint.y);
        self.drawOffset = CGPointMake(x,y);
        
    }
}

- (void)tapGesture:(UITapGestureRecognizer *)gesture {
}

- (void)panGesture:(UIPanGestureRecognizer *)gesture {
    
    
    if(self.drawState == ReceiptViewDrawMenuItems &&
       gesture.numberOfTouches == 1){
        
        if(gesture.state == UIGestureRecognizerStateBegan ||
           gesture.state == UIGestureRecognizerStateChanged) {
            [self addMenuItemPoint:[gesture locationInView:nil]];
        } else {
            ULog(@"panGesture.state unknown[%d]", gesture.state);
        }
    } else if(gesture.numberOfTouches == 2){
        if(gesture.state == UIGestureRecognizerStateBegan ||
           gesture.state == UIGestureRecognizerStateChanged) {

            self.drawOffset = CGPointMake(self.drawOffset.x + [gesture translationInView:nil].x,
                                          self.drawOffset.y + [gesture translationInView:nil].y);

            [gesture setTranslation:CGPointMake(0,0) inView:nil];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];

    if([touches count] == 1 && self.drawState == ReceiptViewDrawMenuItems) {
        [self addMenuItemPoint:[touch locationInView:nil]];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
}


#pragma mark - Draw Methods


- (void) drawReceiptImage:(CGContextRef) context {
    UIGraphicsPushContext(context);
    CGRect rect = CGRectMake(self.drawOffset.x, self.drawOffset.y, self.frame.size.width * self.drawScale, self.frame.size.height * self.drawScale);
    [self.image drawInRect:rect];
    UIGraphicsPopContext();
}

- (void) drawMenuItems:(CGContextRef) context {
    
    UIGraphicsPushContext(context);

    // draw current rectanlgle
    [self.redTransparent setFill];
    [[UIColor blackColor] setStroke];
    if(self.currentMenuItemRect.origin.x != NIL_FLOAT) {
        CGContextFillRect(context, [self reverseTranslateAndScaleRect:self.currentMenuItemRect]);
        CGContextStrokeRect(context, [self reverseTranslateAndScaleRect:self.currentMenuItemRect]);
    }
    
    // draw previous rectanlgles
    [self.blueTransparent setFill];
    int i=0;
    while(i < [self.menuItemRects count]) {
        CGRect rect = [[self.menuItemRects objectAtIndex:i] CGRectValue];
        CGContextFillRect(context, [self reverseTranslateAndScaleRect:rect]);
        CGContextStrokeRect(context, [self reverseTranslateAndScaleRect:rect]);
        i++;
    }

    UIGraphicsPopContext();
}

- (void)drawRect:(CGRect)rect {
    
    //no point in drawing anything if you have no image
    if(!self.image) {
        return;
    }
    
    //get context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //draw various receipt objects
    [self drawReceiptImage:context];
    [self drawMenuItems:context];    
}


#pragma mark -
#pragma mark InitMethods

- (void)setup {
    [self clearView];
    self.multipleTouchEnabled = YES;
    self.image = [UIImage imageNamed:@"dimt.jpg"];
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

#pragma mark -
#pragma mark PrivateMethods

@end
