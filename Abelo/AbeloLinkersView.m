//
//  AbeloLinkersView.m
//  Abelo
//
//  Created by Alasdair McCall on 26/09/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import "AbeloLinkersView.h"

typedef struct Linker {
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    CGPoint startPoint;
    CGPoint endPoint;
} Linker;


#pragma mark - AbeloLinkerView PRIVATE interface
@interface AbeloLinkersView()

@property (nonatomic) CGPoint currentLinkerStartPoint;
@property (nonatomic) CGPoint currentLinkerEndPoint;
@property (nonatomic) NSMutableArray *linkers;

- (void) clearCurrentLinkerPoints;

@end

#pragma mark - AbeloLinkerView implementation
@implementation AbeloLinkersView

@synthesize linkers = _linkers;

#pragma mark - Property synthesis declatations
@synthesize currentLinkerStartPoint = _currentLinkerStartPoint;
@synthesize currentLinkerEndPoint = _currentLinkerEndPoint;

#pragma mark - Property synthesis implementations

- (void)setCurrentLinkerStartPoint:(CGPoint)currentLinkerStartPoint {
    _currentLinkerStartPoint = currentLinkerStartPoint;
    [self setNeedsDisplay];
}

- (void)setCurrentLinkerEndPoint:(CGPoint)currentLinkerEndPoint {
    _currentLinkerEndPoint = currentLinkerEndPoint;
    [self setNeedsDisplay];
}

- (NSMutableArray *)linkers {
    if(!_linkers){
        _linkers = [NSMutableArray array];
    }
    return _linkers;
}

#pragma mark - Public methods

- (void)startLinkerFromPoint:(CGPoint)startPoint {
    self.currentLinkerStartPoint = startPoint;
}

- (void)addToCurrentLinkerPoint:(CGPoint)aPoint {
    self.currentLinkerEndPoint = aPoint;
}

- (void)setCurrentLinkerWithColor:(UIColor *)color {
    // from
    // http://stackoverflow.com/a/11599453/179843
    
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
    // iOS 5
    if ([color respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [color getRed:&red green:&green blue:&blue alpha:&alpha];
    } else {
        // < iOS 5
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        red = components[0];
        green = components[1];
        blue = components[2];
        alpha = components[3];
    }
    
    Linker linker = {
        red, green, blue, alpha, self.currentLinkerStartPoint, self.currentLinkerEndPoint
    };

    [self.linkers addObject:[NSValue value:&linker withObjCType:@encode(Linker)]];
    [self clearCurrentLinkerPoints];
}

-(BOOL) isDrawing {
    return self.currentLinkerStartPoint.x != -1;
}

#pragma mark - Draw methods

#define POINT_RADIUS 12.0

- (CGRect) makeRectForPoint:(CGPoint) point {
    return CGRectMake(point.x - POINT_RADIUS/2, point.y - POINT_RADIUS/2, POINT_RADIUS, POINT_RADIUS);
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor redColor] setFill];
    [[UIColor blackColor] setStroke];
    
    if(self.currentLinkerStartPoint.x != -1){
        CGContextMoveToPoint(context, self.currentLinkerStartPoint.x, self.currentLinkerStartPoint.y);
        CGContextStrokeEllipseInRect(context, [self makeRectForPoint:self.currentLinkerStartPoint]);
        CGContextFillEllipseInRect(context, [self makeRectForPoint:self.currentLinkerStartPoint]);
        
        if(self.currentLinkerEndPoint.x != -1){
            CGContextBeginPath(context);
            CGContextMoveToPoint(context, self.currentLinkerStartPoint.x, self.currentLinkerStartPoint.y);
            CGContextAddLineToPoint(context, self.currentLinkerEndPoint.x, self.currentLinkerEndPoint.y);
            CGContextStrokePath(context);
            CGContextStrokeEllipseInRect(context, [self makeRectForPoint:self.currentLinkerEndPoint]);
            CGContextFillEllipseInRect(context, [self makeRectForPoint:self.currentLinkerEndPoint]);
        }
    }
    
    int i=0;
    while(i<[self.linkers count]) {
        struct Linker linker;
        [[self.linkers objectAtIndex:i] getValue:&linker];
        
        [[UIColor colorWithRed:linker.red green:linker.green blue:linker.blue alpha:linker.alpha] setFill];
        CGContextStrokeEllipseInRect(context, [self makeRectForPoint:linker.startPoint]);
        CGContextFillEllipseInRect(context, [self makeRectForPoint:linker.startPoint]);
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, linker.startPoint.x, linker.startPoint.y);
        CGContextAddLineToPoint(context, linker.endPoint.x, linker.endPoint.y);
        CGContextStrokePath(context);
        CGContextStrokeEllipseInRect(context, [self makeRectForPoint:linker.endPoint]);
        CGContextFillEllipseInRect(context, [self makeRectForPoint:linker.endPoint]);
        i++;
    }
    
}

#pragma mark - Private methods

- (void)clearCurrentLinkerPoints{
    self.currentLinkerStartPoint = CGPointMake(-1, -1);
}

#pragma mark - View initialisation
-(void) setupView {
    _currentLinkerStartPoint = CGPointMake(-1, -1);
    _currentLinkerEndPoint = CGPointMake(-1, -1);
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupView];
}

@end
