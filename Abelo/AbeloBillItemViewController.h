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

- (void) addBillItem:(AbeloBillItemViewController *) sender withAmount:(float) billItemAmount withBillItemViewId:(id) viewId;
- (void) removeBillItem:(AbeloBillItemViewController *) sender forBillItemView:(id) view;

@end

@interface AbeloBillItemViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, weak) id<AbeloBillItemViewProtocol> delegate;
@property (nonatomic) UIImage *image;
@property (nonatomic) id billItemViewId;

@property (nonatomic) IBOutlet UIImageView *billImageView;
@property (weak, nonatomic) IBOutlet UITextField *poundsTextField;
@property (weak, nonatomic) IBOutlet UITextField *pencesTextField;
@property (weak, nonatomic) IBOutlet UIStepper *poundsStepper;
@property (weak, nonatomic) IBOutlet UIStepper *pencesStepper;

@end