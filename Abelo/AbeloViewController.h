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


@interface AbeloViewController : UIViewController<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ReceiptViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *addGuestView;
@property (weak, nonatomic) IBOutlet UILabel *addGuestLabel;
@property (weak, nonatomic) IBOutlet UITextField *addGuestInput;
@property (weak, nonatomic) IBOutlet UIButton *addGuestButton;

@property (weak, nonatomic) IBOutlet AbeloReceiptView *receiptView;
@end
