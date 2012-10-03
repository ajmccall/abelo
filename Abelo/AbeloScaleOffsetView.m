//
//  AbeloScaleOffSetView.m
//  Abelo
//
//  Created by Alasdair McCall on 03/10/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import "AbeloScaleOffsetView.h"
#define MAX_SCALE 5.0

#pragma mark - AbeloScaleOffSetView implementation

@implementation AbeloScaleOffsetView

@synthesize drawOffset = _drawOffset;
@synthesize drawScale = _drawScale;

#pragma mark - Property synthesis implementation

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

- (CGPoint) translateAndScalePoint:(CGPoint) p {
    return CGPointMake((p.x - self.drawOffset.x) / self.drawScale, (p.y - self.drawOffset.y) / self.drawScale);
}

- (CGPoint) reverseTranslateAndScalePoint:(CGPoint) p {
    return CGPointMake(self.drawScale * p.x + self.drawOffset.x,
                       self.drawScale * p.y + self.drawOffset.y);
}

- (CGRect) reverseTranslateAndScaleRect:(CGRect) rect {
    return CGRectMake(self.drawScale * rect.origin.x + self.drawOffset.x,
                      self.drawScale * rect.origin.y + self.drawOffset.y,
                      rect.size.width * self.drawScale, rect.size.height * self.drawScale);
}

#define DEFAULT_FINGER_DIM 6.0
- (CGRect) CGRectMakeFromFingerPoint:(CGPoint) p {
    return CGRectMake(p.x,
                      p.y,
                      DEFAULT_FINGER_DIM,
                      DEFAULT_FINGER_DIM);
}

#pragma mark - Implementation methods

+ (CGFloat)maximumScale {
    return MAX_SCALE;
}

- (void)setupView {
    
}

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        [self setupView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupView];
}
@end
