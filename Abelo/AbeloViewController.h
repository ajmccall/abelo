//
//  AbeloViewController.h
//  Abelo
//
//  Created by Alasdair McCall on 06/09/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AbeloViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *addGuestView;
@property (weak, nonatomic) IBOutlet UILabel *addGuestLabel;
@property (weak, nonatomic) IBOutlet UITextField *addGuestInput;
@property (weak, nonatomic) IBOutlet UIButton *addGuestButton;

@end
