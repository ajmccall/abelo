//
//  AbeloBillItemViewController.h
//  Abelo
//
//  Created by Alasdair McCall on 04/10/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AbeloBillItemViewController;

@protocol AbeloBillItemViewProtocol

- (void) setBillItem:(AbeloBillItemViewController *) sender withAmount:(int) billItemAmount;
- (void) editBilItem:(AbeloBillItemViewController *) sender withNewAmount:(int) billItemAmount;
- (void) deleteBillItem:(AbeloBillItemViewController *) sender;
- (void) cancelController:(AbeloBillItemViewController *) sender;

@end

@interface AbeloBillItemViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, weak) id<AbeloBillItemViewProtocol> delegate;
@property (nonatomic) UIImage *image;
@property (nonatomic) int total;
@property (nonatomic) id billItemViewId;

@property (nonatomic) IBOutlet UIImageView *billImageView;
@property (weak, nonatomic) IBOutlet UITextField *poundsTextField;
@property (weak, nonatomic) IBOutlet UITextField *pencesTextField;
@property (weak, nonatomic) IBOutlet UIStepper *poundsStepper;
@property (weak, nonatomic) IBOutlet UIStepper *pencesStepper;

@end