//
//  AbeloViewController.h
//  Abelo
//
//  Created by Alasdair McCall on 06/09/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "AbeloBillItemViewController.h"
#import "AbeloPartyMemberViewController.h"
#import "AbeloMainView.h"

@interface AbeloViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, AbeloPartyMemberProtocol, AbeloBillItemViewProtocol, AbeloMainViewDelegate, UIPopoverControllerDelegate>

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet AbeloMainView *mainView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *okButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;

@end
