//
//  AbeloViewController.h
//  Abelo
//
//  Created by Alasdair McCall on 06/09/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "AbeloReceiptView.h"
#import "AbeloPartyMembersView.h"
#import "AbeloAddPartyMemberViewController.h"

@class AbeloMainView;

@interface AbeloViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, AbeloAddPartyMemberProtocol, UIPopoverControllerDelegate>

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet AbeloMainView *mainView;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *okButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@end
