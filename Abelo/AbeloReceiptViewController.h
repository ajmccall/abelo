//
//  AbeloReceiptViewController.h
//  Abelo
//
//  Created by Alasdair McCall on 11/09/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AbeloBill;

@interface AbeloReceiptViewController : UIViewController

@property (nonatomic, weak) AbeloBill *bill;
@property (nonatomic, weak) UIImage *image;



@end
