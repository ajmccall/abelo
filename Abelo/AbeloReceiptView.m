//
//  AbeloReceiptView.m
//  Abelo
//
//  Created by Alasdair McCall on 11/09/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import "AbeloReceiptView.h"
#import "MRGLog.h"

typedef struct MenuItemTuple{
    CGPoint topLeft, bottomRight;
} MenuItemTuple;

#pragma mark - Constants

#define NIL_FLOAT -1
#define MAX_SCALE 5.0

@interface AbeloReceiptView ()

//@property (nonatomic) CGFloat drawScale;
//@property (nonatomic) CGPoint drawOffset;

@property (nonatomic) CGPoint currentTouch;
@property (nonatomic) CGRect currentMenuItemRect;
@property (nonatomic) int currentMenuItemKey;
@property (nonatomic) NSMutableDictionary *menuItems;

@property (nonatomic) CGRect totalRect;

@property (nonatomic, readonly) UIColor *redTransparent;
@property (nonatomic, readonly) UIColor *blueTransparent;
@property (nonatomic, readonly) UIColor *greenTransparent;

//@property (nonatomic) UIButton *nextButton;
//@property (nonatomic) UIButton *backButton;
//@property (nonatomic) UIButton *okButton;

//@property (nonatomic) UIGestureRecognizer *pinchGesture;
//@property (nonatomic) UIGestureRecognizer *panGesture;

- (CGPoint) translateAndScalePoint:(CGPoint) p;
- (BOOL) clearLastMenuItem;

//- (IBAction)nextButtonAction:(id) sender;

@end

@implementation AbeloReceiptView

@synthesize image = _image;

#pragma mark - Property synthesis

- (void)setImage:(UIImage *)image {
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
//@synthesize nextButton = _nextButton;
//@synthesize backButton = _backButton;
//@synthesize okButton = _okButton;

//current touch, current rect & total rect
@synthesize currentMenuItemRect = _currentMenuItemRect;

- (void)setCurrentMenuItemRect:(CGRect)currentMenuItemRect {
    _currentMenuItemRect = currentMenuItemRect;
    [self setNeedsDisplay];
}

@synthesize currentTouch = _currentTouch;

- (void)setCurrentTouch:(CGPoint)currentTouch {
    _currentTouch = [self translateAndScalePoint:currentTouch];
}

@synthesize totalRect = _totalRect;

- (void) setTotalRect:(CGRect)totalRect {
    _totalRect = totalRect;
    [self setNeedsDisplay];
}

//drawing properties
@synthesize menuItems;
@synthesize drawState = _drawState;
@synthesize drawOffset = _drawOffset;
@synthesize drawScale = _drawScale;

- (void)setDrawOffset:(CGPoint)drawOffset {
    
    //check we're not trying to make hte offset too far outside of the view
    if(drawOffset.x > 0){
        drawOffset.x = 0;
    } else if(0 - drawOffset.x + self.frame.size.width > self.drawScale * self.frame.size.width){
        drawOffset.x = 0 + self.frame.size.width * (1 - self.drawScale);
    }

    if(drawOffset.y > 0){
        drawOffset.y = 0;
    } else if(0 - drawOffset.y + self.frame.size.height > self.drawScale * self.frame.size.height){
        drawOffset.y = 0 + self.frame.size.height * (1 - self.drawScale);
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

////uiGestures
//@synthesize panGesture = _panGesture;
//@synthesize pinchGesture = _pinchGesture;
//
//- (UIGestureRecognizer *)panGesture {
//    if(!_panGesture) {
//        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
//    }
//    return _panGesture;
//}
//
//- (UIGestureRecognizer *)pinchGesture {
//    if(!_pinchGesture) {
//        _pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
//    }
//    return _pinchGesture;
//}

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
    
    _currentMenuItemRect = CGRectMake(NIL_FLOAT, NIL_FLOAT, NIL_FLOAT, NIL_FLOAT);
    self.menuItems = [NSMutableDictionary dictionary];
    
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
    return CGRectMake(p.x,
                      p.y,
                      DEFAULT_FINGER_DIM,
                      DEFAULT_FINGER_DIM);
}

- (void) addPointToCurrentRect:(CGPoint) fingerPoint {
    
    fingerPoint = [self translateAndScalePoint:fingerPoint];
    
    CGRect fingerRect = [self CGRectMakeFromFingerPoint:fingerPoint];
    
    if(self.currentMenuItemRect.size.width != NIL_FLOAT){
        self.currentMenuItemRect = CGRectUnion(self.currentMenuItemRect, fingerRect);
        return;
    }

    if(self.drawState == AbeloReceiptViewDrawStateMenuItems){
        bool foundRectContainingPoint = NO;
        
        NSEnumerator *enumerate = [self.menuItems keyEnumerator];
        NSNumber *key;
        while((key = [enumerate nextObject]) && !foundRectContainingPoint) {
            
            CGRect rect = [[self.menuItems objectForKey:key] CGRectValue];
            if(CGRectContainsPoint(rect, fingerPoint)) {
                foundRectContainingPoint = YES;
            }
        }
        
        if(!foundRectContainingPoint) {
            self.currentMenuItemRect = fingerRect;
        } else {
            CGRect rect = [[self.menuItems objectForKey:key] CGRectValue];
            self.currentMenuItemRect = CGRectUnion(fingerRect, rect);
            [self.delegate clearMenuItemWithIndex:[key intValue]];
            [self.menuItems removeObjectForKey:key];
        }
    } else if(self.drawState == AbeloReceiptViewDrawStateTotal) {
        
        if(CGRectContainsPoint(self.totalRect, fingerPoint)) {
            self.currentMenuItemRect = self.totalRect;
        } else {
            self.currentMenuItemRect = fingerRect;
        }
        
    }

    [self setNeedsDisplay];
}

#pragma mark -
#pragma mark Gesture recognizers

//- (void)pinchGesture:(UIPinchGestureRecognizer *)gesture {
//    
//    if(gesture.state == UIGestureRecognizerStateBegan){
//        gesture.scale = self.drawScale;
//    } else if(gesture.state == UIGestureRecognizerStateChanged){
//        self.drawScale = gesture.scale;
//        CGPoint midPoint = [gesture locationInView:self];
//        CGFloat x = midPoint.x + self.drawScale * (self.frame.origin.x - midPoint.x);
//        CGFloat y = midPoint.y + self.drawScale * (self.frame.origin.y - midPoint.y);
//        self.drawOffset = CGPointMake(x,y);
//        
//    }
//}
//
//- (void)panGesture:(UIPanGestureRecognizer *)gesture {
//    
//    
//    if(self.drawState == AbeloReceiptViewDrawStateMenuItems &&
//       gesture.numberOfTouches == 1){
//        
//        if(gesture.state == UIGestureRecognizerStateBegan ||
//           gesture.state == UIGestureRecognizerStateChanged) {
//            [self addPointToCurrentRect:[gesture locationInView:self]];
//        } else {
//            ULog(@"panGesture.state unknown[%d]", gesture.state);
//        }
//    } if(self.drawState == AbeloReceiptViewDrawStateTotal &&
//         gesture.numberOfTouches == 1){
//        
//        if(gesture.state == UIGestureRecognizerStateBegan ||
//           gesture.state == UIGestureRecognizerStateChanged) {
//            [self addPointToCurrentRect:[gesture locationInView:self]];
//        } else {
//            ULog(@"panGesture.state unknown[%d]", gesture.state);
//        }
//    } else if(gesture.numberOfTouches == 2){
//        if(gesture.state == UIGestureRecognizerStateBegan ||
//           gesture.state == UIGestureRecognizerStateChanged) {
//
//            self.drawOffset = CGPointMake(self.drawOffset.x + [gesture translationInView:self].x,
//                                          self.drawOffset.y + [gesture translationInView:self].y);
//
//            [gesture setTranslation:CGPointMake(0,0) inView:self];
//        }
//    }
//}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [super touchesBegan:touches withEvent:event];
//    UITouch *touch = [touches anyObject];
//
//    // add touch if we are drawing menu itme rectaganles or the total rectangles
//    if([touches count] == 1 &&
//       (self.drawState == AbeloReceiptViewDrawStateMenuItems ||
//        self.drawState == AbeloReceiptViewDrawStateTotal)) {
//           
//        DLog(@"touch[%d] at p(%g, %g)", [touches count], [touch locationInView:self].x, [touch locationInView:self].y);
//        [self addPointToCurrentRect:[touch locationInView:self]];
//    }
//}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
}

#pragma mark - Button actions

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
    [[UIColor blackColor] setStroke];
    if(self.currentMenuItemRect.size.width != NIL_FLOAT) {
        [self.greenTransparent setFill];
        CGContextFillRect(context, [self reverseTranslateAndScaleRect:self.currentMenuItemRect]);
        CGContextStrokeRect(context, [self reverseTranslateAndScaleRect:self.currentMenuItemRect]);
    }
    
    // draw previous rectanlgles
    [self.blueTransparent setFill];

    NSEnumerator *enumerator = [self.menuItems keyEnumerator];
    NSNumber *key;
    while(key = [enumerator nextObject]){
        CGRect rect = [[self.menuItems objectForKey:key] CGRectValue];
        CGContextFillRect(context, [self reverseTranslateAndScaleRect:rect]);
        CGContextStrokeRect(context, [self reverseTranslateAndScaleRect:rect]);
    }

    if(self.totalRect.size.width != NIL_FLOAT) {
        [self.redTransparent setFill];
        CGContextFillRect(context, [self reverseTranslateAndScaleRect:self.totalRect]);
        CGContextStrokeRect(context, [self reverseTranslateAndScaleRect:self.totalRect]);
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

- (void) setupButtons {
    
//    if(!_nextButton){
//        _nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        _nextButton.frame = CGRectMake(18, self.frame.size.height - 57, 85, 37);
//        [_nextButton setTitle:@"Next" forState:UIControlStateNormal];
//        [_nextButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_nextButton];
//    }
// 
//    if(!_backButton) {
//        _backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        _backButton.frame = CGRectMake(470, self.frame.size.height - 57, 85, 37);
//        [_backButton setTitle:@"Back" forState:UIControlStateNormal];
//        [_backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_backButton];
//    }
// 
//    if(!_okButton){
//        _okButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        _okButton.frame = CGRectMake(261, self.frame.size.height - 57, 85, 37);
//        [_okButton setTitle:@"Ok" forState:UIControlStateNormal];
//        [_okButton addTarget:self action:@selector(okButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_okButton];
//    }
}

- (void)setup {
    [self clearView];
    
    self.drawState = AbeloReceiptViewDrawStateStart;
    self.multipleTouchEnabled = YES;
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

- (void)setCurrentMenuItemAndDrawNext {
    _currentTouch = CGPointMake(NIL_FLOAT, NIL_FLOAT);
    [self.menuItems setObject:[NSValue valueWithCGRect:self.currentMenuItemRect] forKey:[NSNumber numberWithInt:self.currentMenuItemKey]];
    self.currentMenuItemKey++;
    
//    [self.menuItems addObject:[NSValue valueWithCGRect:self.currentMenuItemRect]];
    self.currentMenuItemRect = CGRectMake(NIL_FLOAT, NIL_FLOAT, NIL_FLOAT, NIL_FLOAT);
}

- (BOOL)clearLastMenuItem {
    if(self.currentMenuItemRect.size.width != NIL_FLOAT){
        self.currentMenuItemRect = CGRectMake(NIL_FLOAT, NIL_FLOAT, NIL_FLOAT, NIL_FLOAT);
        return YES;
    } else {
        
        if(self.drawState == AbeloReceiptViewDrawStateMenuItems){
            if([self.menuItems count] > 0){
                //notify the controller that you removed the menu item
                [self.delegate clearMenuItemWithIndex:(self.currentMenuItemKey - 1)];
                [self.menuItems removeObjectForKey:[NSNumber numberWithInt:(self.currentMenuItemKey - 1)]];
                [self setNeedsDisplay];
                return YES;
            } else {
                return NO;
            }
        } else if(self.drawState == AbeloReceiptViewDrawStateTotal){
            
            if(self.totalRect.size.width == NIL_FLOAT) {
                return NO;
            } else {
                self.totalRect = CGRectMake(NIL_FLOAT, NIL_FLOAT, NIL_FLOAT, NIL_FLOAT);
                return YES;
            }
        }
    }
    
    return NO;
}

@end
