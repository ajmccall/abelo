//
//  AbeloTouchabvleViewProtocol.h
//  Abelo
//
//  Created by Alasdair McCall on 03/10/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AbeloTouchableViewProtocol <NSObject>

- (id) anyUIViewAtPoint:(CGPoint) point;
- (NSArray *) uiViewsAtPoint:(CGPoint) point;

@end
