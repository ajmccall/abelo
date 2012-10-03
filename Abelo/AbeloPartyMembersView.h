//
//  AbeloPartyMembersView.h
//  Abelo
//
//  Created by Alasdair McCall on 21/09/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbeloTouchableViewProtocol.h"

@protocol AbeloPartyMembersViewProtocol

- (void) addPartyMember:(id) sender;

@end


@interface AbeloPartyMembersView : UIView<AbeloTouchableViewProtocol>

@property (nonatomic, weak) id<AbeloPartyMembersViewProtocol> delegate;

-(id) addPartyMemberWithName:(NSString *)name;

@end

