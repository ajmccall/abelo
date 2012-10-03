//
//  AbeloPartyMembersView.h
//  Abelo
//
//  Created by Alasdair McCall on 21/09/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbeloTouchableViewProtocol.h"

@interface AbeloPartyMembersView : UIView<AbeloTouchableViewProtocol>

-(id) addPartyMemberWithName:(NSString *)name andColor:(UIColor *) color;

@end

