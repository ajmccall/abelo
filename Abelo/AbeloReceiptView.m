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

@interface AbeloReceiptView ()

@property (nonatomic) CGFloat leftMenuItemsBounds;
@property (nonatomic) CGFloat rightMenuItemsBounds;

@property (nonatomic) CGFloat drawScale;
@property (nonatomic) CGPoint drawOffset;

@property (nonatomic) CGPoint currentTouch;

@property (nonatomic) CGRect currentMenuItemRect;
@property (nonatomic) NSMutableArray *menuItemRects;

@property (nonatomic, readonly) UIColor *redTransparent;
@property (nonatomic, readonly) UIColor *blueTransparent;
@property (nonatomic, readonly) UIColor *greenTransparent;

- (CGPoint) translateAndScalePoint:(CGPoint) p;

@end

@implementation AbeloReceiptView

#define NIL_FLOAT -1
#define DEFAULT_MENU_ITEM_HEIGHT 40.0
#define BOUNDS_LINE_WIDTH 2.0
#define MAX_SCALE 5.0

#pragma mark -
#pragma mark Props

@synthesize image = _image;
@synthesize currentMenuItemRect = _currentMenuItemRect;
@synthesize currentTouch = _currentTouch;

@synthesize menuItemRects;
@synthesize drawState;
@synthesize drawOffset = _drawOffset;
@synthesize drawScale = _drawScale;
//not in use
@synthesize rightMenuItemsBounds;
@synthesize leftMenuItemsBounds;

- (void)setCurrentTouch:(CGPoint)currentTouch {
    _currentTouch = [self translateAndScalePoint:currentTouch];
}

- (void)setCurrentMenuItemRect:(CGRect)currentMenuItemRect {
    _currentMenuItemRect = currentMenuItemRect;
    [self setNeedsDisplay];
}

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

- (UIColor *)redTransparent {
    return [UIColor colorWithRed:255 green:0 blue:0 alpha:0.3];
}

- (UIColor *)greenTransparent {
    return [UIColor colorWithRed:0 green:255 blue:0 alpha:0.3];
}

- (UIColor *)blueTransparent {
    return [UIColor colorWithRed:0 green:0 blue:255 alpha:0.3];
}

#pragma mark -
#pragma mark Methods Implementations

- (void)clearView {
    
    self.drawState = RecieptViewDrawNone;
    
    self.leftMenuItemsBounds = NIL_FLOAT;
    self.rightMenuItemsBounds = NIL_FLOAT;
    _currentMenuItemRect = CGRectMake(NIL_FLOAT, NIL_FLOAT, NIL_FLOAT, NIL_FLOAT);
    self.menuItemRects = [NSMutableArray array];
    
    _drawOffset = CGPointMake(0,0);
    _currentTouch = CGPointMake(NIL_FLOAT, NIL_FLOAT);
    _drawScale = 1.0;
    _image = nil;
    [self setNeedsDisplay];
}

- (void) setMenuItemsBoundsPoint1:(CGFloat)p1 point2:(CGFloat)p2 {
    
    // error checking
    CGFloat frameWidth = self.frame.size.width;
    if(p1 < 0 || p2 < 0 || p1 > frameWidth || p2 > frameWidth || p1 == p2) {
        return;
    }
    
    // set the left/right bounds and setNeedsLayout
    if(p1 < p2) {
        self.leftMenuItemsBounds = p1;
        self.rightMenuItemsBounds = p2;
    } else {
        self.leftMenuItemsBounds = p2;
        self.rightMenuItemsBounds = p1;
    }
    
    // could optimise here by specifying the rectangle to use
//    [self setNeedsDisplayInRect:CGRectMake(self.leftMenuItemsBounds, 0, self.rightMenuItemsBounds, self.frame.size.height)];
    [self setNeedsDisplay];
}

- (CGPoint) translateAndScalePoint:(CGPoint) p {
    return CGPointMake((p.x - self.drawOffset.x) / self.drawScale, (p.y - self.drawOffset.y) / self.drawScale);
//    return p;
}

- (CGRect) translateAndScaleRect:(CGRect) rect {
    return CGRectMake(self.drawScale * rect.origin.x + self.drawOffset.x,
                      self.drawScale * rect.origin.y + self.drawOffset.y,
                      rect.size.width * self.drawScale, rect.size.height * self.drawScale);
//    return rect;
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
    
//    if(self.drawState == RecieptViewDrawPriceBounds){
//        if(gesture.numberOfTouches != 2) {
//            return;
//        }
//        
//        if(gesture.state == UIGestureRecognizerStateBegan ||
//           gesture.state == UIGestureRecognizerStateChanged){
//            [self setMenuItemsBoundsPoint1:[gesture locationOfTouch:0 inView:nil].x point2:[gesture locationOfTouch:1 inView:nil].x];
//        }
//    } else  {
    if(gesture.state == UIGestureRecognizerStateBegan){
        gesture.scale = self.drawScale;
    } else if(gesture.state == UIGestureRecognizerStateChanged){
        self.drawScale = gesture.scale;
        CGPoint midPoint = [gesture locationInView:nil];
        CGFloat x = midPoint.x + self.drawScale * (self.frame.origin.x - midPoint.x);
        CGFloat y = midPoint.y + self.drawScale * (self.frame.origin.y - midPoint.y);
        self.drawOffset = CGPointMake(x,y);
        
    }
//    }
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

- (void)tapGesture:(UITapGestureRecognizer *)gesture {
}

- (void)panGesture:(UIPanGestureRecognizer *)gesture {
    
    
    if(self.drawState == RecieptViewDrawMenuItems &&
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
//            DLog(@"drawOffset(%g, %g)", self.drawOffset.x, self.drawOffset.y);
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];

//    DLog(@"point(%g,%g) number[%d]", [touch locationInView:nil].x, [touch locationInView:nil].y, [touches count]);
    if([touches count] == 1 && self.drawState == RecieptViewDrawMenuItems) {
        [self addMenuItemPoint:[touch locationInView:nil]];
//        self.currentTouch = [touch locationInView:nil];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
}

#pragma mark -
#pragma mark Draw Methods


- (void) drawReceiptImage:(CGContextRef) context {
    UIGraphicsPushContext(context);
    CGRect rect = CGRectMake(self.drawOffset.x, self.drawOffset.y, self.frame.size.width * self.drawScale, self.frame.size.height * self.drawScale);
    [self.image drawInRect:rect];
    UIGraphicsPopContext();
}

- (void) drawMenuItemsBounds:(CGContextRef) context {
    //check if you need to draw anything else
    if(self.leftMenuItemsBounds == NIL_FLOAT || self.rightMenuItemsBounds == NIL_FLOAT){
        return;
    }
    
    UIGraphicsPushContext(context);
    //set line width/stroke
    CGContextSetLineWidth(context, BOUNDS_LINE_WIDTH);
    [[UIColor redColor] setStroke];
    
    //draw left bounds
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, self.leftMenuItemsBounds - BOUNDS_LINE_WIDTH, self.frame.origin.y);
    CGContextAddLineToPoint(context, self.leftMenuItemsBounds - BOUNDS_LINE_WIDTH, self.frame.size.height);
    CGContextStrokePath(context);
    
    //draw right bounds
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, self.rightMenuItemsBounds, self.frame.origin.y);
    CGContextAddLineToPoint(context, self.rightMenuItemsBounds, self.frame.size.height);
    CGContextStrokePath(context);

    UIGraphicsPopContext();
}

- (void) drawMenuItems:(CGContextRef) context {
    
    UIGraphicsPushContext(context);
//    DLog(@"currRect(%g, %g, %g, %g), array[%d]",
//         self.currentMenuItemRect.origin.x,
//         self.currentMenuItemRect.origin.y,
//         self.currentMenuItemRect.size.width,
//         self.currentMenuItemRect.size.height,
//         [self.menuItemRects count]);

    
    [self.redTransparent setFill];
    [[UIColor blackColor] setStroke];
    
    if(self.currentMenuItemRect.origin.x != NIL_FLOAT) {
        CGContextFillRect(context, [self translateAndScaleRect:self.currentMenuItemRect]);
        CGContextStrokeRect(context, [self translateAndScaleRect:self.currentMenuItemRect]);
    }
    
    [self.blueTransparent setFill];
    int i=0;
    while(i < [self.menuItemRects count]) {
        CGRect rect = [[self.menuItemRects objectAtIndex:i] CGRectValue];
        CGContextFillRect(context, [self translateAndScaleRect:rect]);
        CGContextStrokeRect(context, [self translateAndScaleRect:rect]);
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
    [self drawMenuItemsBounds:context];
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
