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
    CGPoint receiptPoint;
    CGPoint partyMemberPoint;
} Linker;


#pragma mark - AbeloLinkerView PRIVATE interface
@interface AbeloLinkersView()

@property (nonatomic) CGPoint currentLinkerPointStart;
@property (nonatomic) CGPoint currentLinkerPointEnd;
@property (nonatomic) NSMutableArray *linkers;
@property (nonatomic) BOOL startLinkerPointInReceipt;

- (void) clearCurrentLinkerPoints;

@end

#pragma mark - AbeloLinkerView implementation
@implementation AbeloLinkersView

@synthesize linkers = _linkers;

#pragma mark - Property synthesis declatations
@synthesize currentLinkerPointStart = _currentLinkerPointStart;
@synthesize currentLinkerPointEnd = _currentLinkerPointEnd;
@synthesize receiptViewRect = _receiptViewRect;
@synthesize partyMembersViewRect = _partyMembersViewRect;
@synthesize startLinkerPointInReceipt;

#pragma mark - Property synthesis implementations

- (void)setCurrentLinkerPointStart:(CGPoint)currentLinkerPointStart {
    _currentLinkerPointStart = currentLinkerPointStart;
    [self setNeedsDisplay];
}

- (void)setCurrentLinkerPointEnd:(CGPoint)currentLinkerPointEnd {
    _currentLinkerPointEnd = currentLinkerPointEnd;
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
    if(CGRectContainsPoint(self.receiptViewRect, startPoint)){
        self.startLinkerPointInReceipt = YES;
        startPoint = [self translateAndScalePoint:startPoint];
    } else{
        self.startLinkerPointInReceipt = NO;
    }
    
    self.currentLinkerPointStart = startPoint;
}

- (void)addToCurrentLinkerPoint:(CGPoint)aPoint {
    self.currentLinkerPointEnd = aPoint;
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
        red, green, blue, alpha, self.currentLinkerPointStart, self.currentLinkerPointEnd
    };
    
    //need to switch them around for the scale/offset transform
    if(!startLinkerPointInReceipt){
        linker.receiptPoint = self.currentLinkerPointEnd;
        linker.partyMemberPoint = self.currentLinkerPointStart;
    }

    [self.linkers addObject:[NSValue value:&linker withObjCType:@encode(Linker)]];
    [self clearCurrentLinkerPoints];
}

-(BOOL) isDrawing {
    return self.currentLinkerPointStart.x != -1;
}

- (void)clearCurrentLinkers {
    self.currentLinkerPointStart = CGPointMake(-1, -1);
    self.currentLinkerPointEnd = CGPointMake(-1, -1);
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
    
    if(self.currentLinkerPointStart.x != -1){
        CGContextMoveToPoint(context, self.currentLinkerPointStart.x, self.currentLinkerPointStart.y);
        CGContextStrokeEllipseInRect(context, [self makeRectForPoint:self.currentLinkerPointStart]);
        CGContextFillEllipseInRect(context, [self makeRectForPoint:self.currentLinkerPointStart]);
        
        if(self.currentLinkerPointEnd.x != -1){
            CGContextBeginPath(context);
            CGContextMoveToPoint(context, self.currentLinkerPointStart.x, self.currentLinkerPointStart.y);
            CGContextAddLineToPoint(context, self.currentLinkerPointEnd.x, self.currentLinkerPointEnd.y);
            CGContextStrokePath(context);
            CGContextStrokeEllipseInRect(context, [self makeRectForPoint:self.currentLinkerPointEnd]);
            CGContextFillEllipseInRect(context, [self makeRectForPoint:self.currentLinkerPointEnd]);
        }
    }
    
    int i=0;
    while(i < [self.linkers count]) {
        struct Linker linker;
        [[self.linkers objectAtIndex:i] getValue:&linker];
        
        CGPoint receiptPoint = [self reverseTranslateAndScalePoint:linker.receiptPoint];
        CGPoint partyMemberPoint = linker.partyMemberPoint;
        
        [[UIColor colorWithRed:linker.red green:linker.green blue:linker.blue alpha:linker.alpha] setFill];
        
        CGContextStrokeEllipseInRect(context, [self makeRectForPoint:receiptPoint]);
        CGContextFillEllipseInRect(context, [self makeRectForPoint:receiptPoint]);
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, receiptPoint.x, receiptPoint.y);
        CGContextAddLineToPoint(context, partyMemberPoint.x, partyMemberPoint.y);
        CGContextStrokePath(context);
        CGContextStrokeEllipseInRect(context, [self makeRectForPoint:partyMemberPoint]);
        CGContextFillEllipseInRect(context, [self makeRectForPoint:partyMemberPoint]);
        i++;
    }
    
}


#pragma mark - Private methods

- (void)clearCurrentLinkerPoints{
    self.currentLinkerPointStart = CGPointMake(-1, -1);
}

#pragma mark - View initialisation
-(void) setupView {
    _currentLinkerPointStart = CGPointMake(-1, -1);
    _currentLinkerPointEnd = CGPointMake(-1, -1);
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
