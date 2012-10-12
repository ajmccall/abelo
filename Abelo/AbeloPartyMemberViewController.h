//
//  AbeloPartyMemberViewController
//  Abelo
//
//  Created by Alasdair McCall on 03/10/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AbeloPartyMemberViewController;

@protocol AbeloPartyMemberProtocol

- (void) setPartyMember:(AbeloPartyMemberViewController *) sender withName:(NSString *) name andColor:(UIColor *) color;
- (void) editPartyMember:(AbeloPartyMemberViewController *) sender withNewName:(NSString *) newName andNewColor:(UIColor *) newColor;
- (void) deletePartyMember:(AbeloPartyMemberViewController *) sender;
- (void) cancelViewController:(AbeloPartyMemberViewController *) sender;

@end

@interface AbeloPartyMemberViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textInput;
@property (weak, nonatomic) id<AbeloPartyMemberProtocol> delegate;

@property (nonatomic) NSString *name;
@property (nonatomic) NSArray *billItems;
@property (nonatomic) float total;
@property (nonatomic) id partyMemberViewId;
@property (nonatomic) UIColor *color;

@end
