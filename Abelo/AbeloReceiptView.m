//
//  AbeloReceiptView.m
//  Abelo
//
//  Created by Alasdair McCall on 11/09/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import "AbeloReceiptView.h"
#import "MRGLog.h"

#define NIL_FLOAT -1
#define MAX_SCALE 5.0

#pragma mark - AbeloReceiptView PRIVATE interface
@interface AbeloReceiptView ()

@property (nonatomic) CGPoint currentTouch;
@property (nonatomic) CGRect currentMenuItemRect;
@property (nonatomic) int lastSetMenuItemId;
@property (nonatomic) NSMutableDictionary *menuItems;

@property (nonatomic) CGRect totalRect;

@property (nonatomic, readonly) UIColor *redTransparent;
@property (nonatomic, readonly) UIColor *blueTransparent;
@property (nonatomic, readonly) UIColor *greenTransparent;

- (CGPoint) translateAndScalePoint:(CGPoint) p;

@end

#pragma mark - AbeloReceiptView implementation
@implementation AbeloReceiptView

@synthesize image = _image;

#pragma mark - Property synthesis declarations
@synthesize currentMenuItemRect = _currentMenuItemRect;
@synthesize currentTouch = _currentTouch;
@synthesize totalRect = _totalRect;
@synthesize menuItems;
@synthesize drawState = _drawState;
@synthesize drawOffset = _drawOffset;
@synthesize drawScale = _drawScale;

#pragma mark - Property synthesis implementation
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

- (void)setCurrentMenuItemRect:(CGRect)currentMenuItemRect {
    _currentMenuItemRect = currentMenuItemRect;
    [self setNeedsDisplay];
}

- (void)setCurrentTouch:(CGPoint)currentTouch {
    _currentTouch = [self translateAndScalePoint:currentTouch];
}

- (void) setTotalRect:(CGRect)totalRect {
    _totalRect = totalRect;
    [self setNeedsDisplay];
}

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
        while(!foundRectContainingPoint && (key = [enumerate nextObject])) {
            
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


#pragma mark -View initialisation
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
    [super awakeFromNib];
    [self setup];
}

- (void) setCurrentRectAsMenuItemWithId:(int) menuItemId {
    if(self.drawState == AbeloReceiptViewDrawStateMenuItems){
        [self.menuItems setObject:[NSValue valueWithCGRect:self.currentMenuItemRect] forKey:[NSNumber numberWithInt:menuItemId]];
        self.lastSetMenuItemId = menuItemId;
    }
    
    _currentTouch = CGPointMake(NIL_FLOAT, NIL_FLOAT);
    self.currentMenuItemRect = CGRectMake(NIL_FLOAT, NIL_FLOAT, NIL_FLOAT, NIL_FLOAT);
}

- (void)setCurrentRectAsTotal {
    self.totalRect = self.currentMenuItemRect;
    _currentTouch = CGPointMake(NIL_FLOAT, NIL_FLOAT);
    self.currentMenuItemRect = CGRectMake(NIL_FLOAT, NIL_FLOAT, NIL_FLOAT, NIL_FLOAT);
}


- (BOOL)clearLastMenuItem {
    if(self.currentMenuItemRect.size.width != NIL_FLOAT){
        self.currentMenuItemRect = CGRectMake(NIL_FLOAT, NIL_FLOAT, NIL_FLOAT, NIL_FLOAT);
        return YES;
    } else {
        
        if(self.drawState == AbeloReceiptViewDrawStateMenuItems){
            if([self.menuItems count] > 0){
                
                if([self.menuItems objectForKey:[NSNumber numberWithInt:self.lastSetMenuItemId]]){
                    [self.menuItems removeObjectForKey:[NSNumber numberWithInt:self.lastSetMenuItemId]];
                } else {
                    self.lastSetMenuItemId--;
                    while(self.lastSetMenuItemId > 0){
                        if([self.menuItems objectForKey:[NSNumber numberWithInt:self.lastSetMenuItemId]]){
                            [self.menuItems removeObjectForKey:[NSNumber numberWithInt:self.lastSetMenuItemId]];
                            break;
                        }
                        self.lastSetMenuItemId--;
                    }
                }
                
                //notify the controller that you removed the menu item
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
