//
//  AbeloViewController.h
//  Abelo
//
//  Created by Alasdair McCall on 06/09/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>

@class AbeloReceiptView;

enum AbeloCreationState {
    AbeloCreationState0Start = 0,
    AbeloCreationState1Image = 1,
    AbeloCreationState2MenuItems = 2,
    AbeloCreationState3Total = 3,
    AbeloCreationState4PartyMembers = 4,
    AbeloCreationState5End = 5
} typedef AbeloCreationState;

@interface AbeloViewController : UIViewController<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *addGuestView;
@property (weak, nonatomic) IBOutlet UILabel *addGuestLabel;
@property (weak, nonatomic) IBOutlet UITextField *addGuestInput;
@property (weak, nonatomic) IBOutlet UIButton *addGuestButton;

@property (weak, nonatomic) IBOutlet AbeloReceiptView *receiptView;
@end
