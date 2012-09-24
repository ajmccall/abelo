//
//  AbeloViewController.m
//  Abelo
//
//  Created by Alasdair McCall on 06/09/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import "AbeloViewController.h"
#import "AbeloBill.h"
#import "MRGLog.h"
#import "AbeloReceiptView.h"
#import "AbeloPartyMembersView.h"

@interface AbeloViewController ()

+ (NSString *) GenerateRandStringLength:(int) len;

@property (nonatomic) AbeloBill *bill;
@property (nonatomic) UIPopoverController *popover;

@end

@implementation AbeloViewController

@synthesize receiptView = _receiptView;
@synthesize partyMembersView = _partyMembersView;

#pragma mark - Property synthesizers/declarations
@synthesize toolbar = _toolbar;
@synthesize bill = _bill;
@synthesize popover = _popover;

- (void)setReceiptView:(AbeloReceiptView *)receiptView {
    _receiptView = receiptView;
    _receiptView.delegate = self;
}

- (AbeloBill *)bill {
    if(_bill){
        _bill = [[AbeloBill alloc] init];
    }
    return _bill;
}

#pragma mark - Setup

- (UIPopoverController *)popover {
    if(!_popover) {
        _popover = [[UIPopoverController alloc] initWithContentViewController:self];
    }
    return _popover;
}

- (void) setup {
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setup];
}

- (void)viewDidUnload
{
    [self setReceiptView:nil];
    [self setToolbar:nil];
    [self setPartyMembersView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - Button Actions

- (IBAction)addGuestAction:(id)sender {
    [self.partyMembersView addPartyMemberWithName:[AbeloViewController GenerateRandStringLength:3]];    
}


#pragma mark - Camera

- (void) initialiseCamera {

    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        DLog(@"No camera found")
        return;
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = NO;
    
    [self presentViewController:imagePickerController
                       animated:YES
                     completion:^(void){
                     }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *originalImage, *editedImage, *imageToSave;
    
    editedImage = (UIImage *) [info objectForKey:UIImagePickerControllerEditedImage];
    originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (editedImage) {
        imageToSave = editedImage;
    } else {
        imageToSave = originalImage;
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark - ReceiptViewDelegate protocol

- (UIImage *)getImage {
    return [UIImage imageNamed:@"dimt.jpg"];
}

- (void) addMenuItemWithIndex:(int) index {
    
}

- (void) clearMenuItemWithIndex:(int) index {
    
}

# pragma mark - Private methods

NSString *letters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";

+ (NSString *) GenerateRandStringLength:(int) len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    
    return randomString;
}
@end
