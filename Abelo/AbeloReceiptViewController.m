//
//  AbeloReceiptViewController.m
//  Abelo
//
//  Created by Alasdair McCall on 11/09/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import "AbeloReceiptViewController.h"
#import "AbeloReceiptView.h"

@interface AbeloReceiptViewController ()

@property (nonatomic, weak) AbeloReceiptView *receiptView;

@end

@implementation AbeloReceiptViewController

@synthesize bill = _bill;
@synthesize image = _image;
@synthesize receiptView = _receiptView;

- (void) setImage:(UIImage *)image {
    _image = image;
    
    
    [self.receiptView setNeedsDisplay];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
