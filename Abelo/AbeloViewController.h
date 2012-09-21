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

@class AbeloPartyMembersView;

@interface AbeloViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, ReceiptViewDelegate>

@property (weak, nonatomic) IBOutlet AbeloReceiptView *receiptView;
@property (weak, nonatomic) IBOutlet AbeloPartyMembersView *partyMembersView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@end
