//
//  AbeloAddPartyMemberViewController.h
//  Abelo
//
//  Created by Alasdair McCall on 03/10/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AbeloAddPartyMemberViewController;

@protocol AbeloAddPartyMemberProtocol

- (void) addPartyMember:(AbeloAddPartyMemberViewController *) sender withName:(NSString *) name andColor:(UIColor *) color;
- (void) cancelAddPartyMember:(AbeloAddPartyMemberViewController *) sender;

@end

@interface AbeloAddPartyMemberViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textInput;
@property (weak, nonatomic) id<AbeloAddPartyMemberProtocol> delegate;

@end
