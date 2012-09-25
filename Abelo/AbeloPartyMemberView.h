//
//  AbeloPartyMemberView.h
//  Abelo
//
//  Created by Alasdair McCall on 24/09/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AbeloPartyMemberView : UIView

@property (nonatomic) NSString *name;
@property (nonatomic) float total;

- (void) setColor:(UIColor *) color;

@end
