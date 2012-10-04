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
@property (nonatomic) CGRect currentBillItemRect;
@property (nonatomic) NSMutableArray *billItems;
@property (nonatomic) CGRect totalRect;
@property (nonatomic, readonly) UIColor *redTransparent;
@property (nonatomic, readonly) UIColor *blueTransparent;
@property (nonatomic, readonly) UIColor *greenTransparent;

@end

#pragma mark - AbeloReceiptView implementation
@implementation AbeloReceiptView

@synthesize image = _image;

#pragma mark - Property synthesis declarations
@synthesize currentBillItemRect = _currentBillItemRect;
@synthesize currentTouch = _currentTouch;
@synthesize totalRect = _totalRect;
@synthesize billItems;

#pragma mark - Property synthesis implementation
- (void)setImage:(UIImage *)image {
    
    switch ([image imageOrientation]) {
        case UIImageOrientationUp:
            _image = image;
            break;
        default:
            _image = [UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationUp];
            break;
    }
    _image = image;
    
    [self setNeedsDisplay];
}

- (void)setCurrentBillItemRect:(CGRect)currentBillItemRect {
    _currentBillItemRect = currentBillItemRect;
    [self setNeedsDisplay];
}

- (void)setCurrentTouch:(CGPoint)currentTouch {
    _currentTouch = [self translateAndScalePoint:currentTouch];
}

- (void) setTotalRect:(CGRect)totalRect {
    _totalRect = totalRect;
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
    
    _currentBillItemRect = CGRectMake(NIL_FLOAT, NIL_FLOAT, NIL_FLOAT, NIL_FLOAT);
    self.billItems = [NSMutableArray array];
    
    _currentTouch = CGPointMake(NIL_FLOAT, NIL_FLOAT);
    self.drawOffset = CGPointMake(0,0);
    self.drawScale = 1.0;
    _image = nil;
    [self setNeedsDisplay];
}

- (void) addPointToCurrentRect:(CGPoint) fingerPoint {
    
    fingerPoint = [self translateAndScalePoint:fingerPoint];
    
    CGRect fingerRect = [self CGRectMakeFromFingerPoint:fingerPoint];
    
    if(self.currentBillItemRect.size.width != NIL_FLOAT){
        self.currentBillItemRect = CGRectUnion(self.currentBillItemRect, fingerRect);
        return;
    }

    bool foundRectContainingPoint = NO;
    
    int i = 0;
    while(!foundRectContainingPoint && i < [billItems count]) {
        CGRect rect = [[billItems objectAtIndex:i] CGRectValue];
        if(CGRectContainsPoint(rect, fingerPoint)) {
            foundRectContainingPoint = YES;
        } else {
            i++;
        }
    }
    
    if(!foundRectContainingPoint) {
        self.currentBillItemRect = fingerRect;
    } else {
        CGRect rect = [[self.billItems objectAtIndex:i] CGRectValue];
        self.currentBillItemRect = CGRectUnion(fingerRect, rect);
        [self.billItems removeObjectAtIndex:i];
    }

    [self setNeedsDisplay];
}

- (void) addPointToTotalRect:(CGPoint) fingerPoint {
    fingerPoint = [self translateAndScalePoint:fingerPoint];
    
    CGRect fingerRect = [self CGRectMakeFromFingerPoint:fingerPoint];
    
    if(self.currentBillItemRect.size.width != NIL_FLOAT){
        self.currentBillItemRect = CGRectUnion(self.currentBillItemRect, fingerRect);
        return;
    }

    if(CGRectContainsPoint(self.totalRect, fingerPoint)) {
        self.currentBillItemRect = self.totalRect;
    } else {
        self.currentBillItemRect = fingerRect;
    }

    [self setNeedsDisplay];
}

- (void)clearCurrentRect {
    self.currentBillItemRect = CGRectMake(NIL_FLOAT, NIL_FLOAT, NIL_FLOAT, NIL_FLOAT);
}

- (UIImage *)getImageForRect:(CGRect)rect {

    CGFloat imageToDisplayRectScaleX = self.frame.size.width / self.image.size.width;
    CGFloat imageToDisplayRectScaleY = self.frame.size.height / self.image.size.height;
    
    rect = CGRectMake(rect.origin.x / imageToDisplayRectScaleX,
                      rect.origin.y / imageToDisplayRectScaleY,
                      rect.size.width / imageToDisplayRectScaleX,
                      rect.size.height / imageToDisplayRectScaleY);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.image.CGImage, rect);
    
    UIImage *ret = [UIImage imageWithCGImage:imageRef];
    
    // since CGImageRef is a Core Graphics object, not managed by ARC hnce needs to be released
    CGImageRelease(imageRef);
    
    return ret;
}

#pragma mark - Draw Methods
- (void) drawReceiptImage:(CGContextRef) context {
    UIGraphicsPushContext(context);
    CGRect rect = CGRectMake(self.drawOffset.x, self.drawOffset.y, self.frame.size.width * self.drawScale, self.frame.size.height * self.drawScale);
    [self.image drawInRect:rect];
    UIGraphicsPopContext();
}

- (void) drawBillItems:(CGContextRef) context {
    
    UIGraphicsPushContext(context);

    // draw current rectanlgle
    [[UIColor blackColor] setStroke];
    if(self.currentBillItemRect.size.width != NIL_FLOAT) {
        [self.greenTransparent setFill];
        CGContextFillRect(context, [self reverseTranslateAndScaleRect:self.currentBillItemRect]);
        CGContextStrokeRect(context, [self reverseTranslateAndScaleRect:self.currentBillItemRect]);
    }
    
    // draw previous rectanlgles
    [self.blueTransparent setFill];

    int i=0;
    while(i < [billItems count]){
        CGRect rect = [[self.billItems objectAtIndex:i] CGRectValue];
        CGContextFillRect(context, [self reverseTranslateAndScaleRect:rect]);
        CGContextStrokeRect(context, [self reverseTranslateAndScaleRect:rect]);
        i++;
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
    [self drawBillItems:context];
}

#pragma mark - AbeloTouchableViewProtocol

- (id)anyUIViewAtPoint:(CGPoint)point {
    
    point = [self translateAndScalePoint:point];
    if(CGRectContainsPoint(self.currentBillItemRect, point)){
        return [NSValue valueWithCGRect:self.currentBillItemRect];
    }
    
    int i = 0;
    while(i < [self.billItems count]) {
        if(CGRectContainsPoint([[self.billItems objectAtIndex:i] CGRectValue], point)) {
            break;
        }
        i++;
    }
    
    if(i == [self.billItems count]) {
        return nil;
    } else {
        return [self.billItems objectAtIndex:i];
    }
}

- (NSArray *)uiViewsAtPoint:(CGPoint)point {
    NSMutableArray *array = [NSMutableArray array];
    point = [self translateAndScalePoint:point];

    int i = 0;
    while(i < [self.billItems count]) {
        if(CGRectContainsPoint([[self.billItems objectAtIndex:i] CGRectValue], point)) {
            [array addObject:[self.billItems objectAtIndex:i]];
        }
        i++;
    }
    
    return array;
}

#pragma mark - View initialisation
- (void)setup {
    [self clearView];
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

- (id) setCurrentRectAsBillItem {
    NSValue *ret = [NSValue valueWithCGRect:self.currentBillItemRect];
    [self.billItems addObject:ret];
    
    _currentTouch = CGPointMake(NIL_FLOAT, NIL_FLOAT);
    self.currentBillItemRect = CGRectMake(NIL_FLOAT, NIL_FLOAT, NIL_FLOAT, NIL_FLOAT);

    return ret;
}

- (void) setTotalRect {
    _currentTouch = CGPointMake(NIL_FLOAT, NIL_FLOAT);
    self.currentBillItemRect = CGRectMake(NIL_FLOAT, NIL_FLOAT, NIL_FLOAT, NIL_FLOAT);
}

- (id)setCurrentRectAsTotal {
    self.totalRect = self.currentBillItemRect;
    _currentTouch = CGPointMake(NIL_FLOAT, NIL_FLOAT);
    self.currentBillItemRect = CGRectMake(NIL_FLOAT, NIL_FLOAT, NIL_FLOAT, NIL_FLOAT);
    
    return [NSValue valueWithCGRect:self.totalRect];
}


- (BOOL) clearLastBillItemAndReturnSuccess {
    if(self.currentBillItemRect.size.width != NIL_FLOAT){
        self.currentBillItemRect = CGRectMake(NIL_FLOAT, NIL_FLOAT, NIL_FLOAT, NIL_FLOAT);
        return YES;
    } else {
        
        if([self.billItems count] > 0){
            
            [self.billItems removeLastObject];
            
            //notify the controller that you removed the menu item
            [self setNeedsDisplay];
            return YES;
        } else {
            return NO;
        }
    }
    
    return NO;
}

-(BOOL) clearTotalAndReturnSuccess {
    if(self.currentBillItemRect.size.width != NIL_FLOAT){
        self.currentBillItemRect = CGRectMake(NIL_FLOAT, NIL_FLOAT, NIL_FLOAT, NIL_FLOAT);
        return YES;
    } else {
        if(self.totalRect.size.width == NIL_FLOAT) {
            return NO;
        } else {
            self.totalRect = CGRectMake(NIL_FLOAT, NIL_FLOAT, NIL_FLOAT, NIL_FLOAT);
            return YES;
        }
    }
}

@end
