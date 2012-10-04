//
//  AbeloBillItemViewController.m
//  Abelo
//
//  Created by Alasdair McCall on 04/10/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import "AbeloBillItemViewController.h"
#import "MRGLog.h"
#import "MRGRectMake.h"

#define BUTTON_YES_TAG 1
#define BUTTON_NO_TAG -1
#define STEPPER_POUNDS_TAG 1
#define STEPPER_PENCE_TAG -1

#pragma mark - AbeloBillItemViewController PRIVATE interface

@interface AbeloBillItemViewController ()

@end

#pragma mark - AbeloBillItemViewController implementation

@implementation AbeloBillItemViewController

#pragma mark - Property synthesis

@synthesize delegate = _delegate;
@synthesize billItemViewId = _billItemViewId;

@synthesize image = _image;

#pragma mark - Property synthesis implementation


- (void)setImage:(UIImage *)image {
    
    _image = [image copy];
    NSData *imageData = UIImagePNGRepresentation(_image);
    
    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/test.png"];
    // identity the home directory and file name
    [imageData writeToFile:jpgPath atomically:YES];

    self.billImageView.image = _image;
    [self.billImageView setNeedsDisplay];
    [self.view setNeedsDisplay];
}

#pragma mark - IBOutlet Actions

- (IBAction)stepperAction:(UIStepper*)sender {
    if(sender.tag == STEPPER_POUNDS_TAG) {
        self.poundsTextField.text = [NSString stringWithFormat:@"%d", (int)sender.value];
    } else {
        self.pencesTextField.text = [NSString stringWithFormat:@"%d", (int)sender.value];
    }
}

- (IBAction)buttonAction:(UIButton *)sender {
    if(sender.tag == BUTTON_YES_TAG) {
        float amount = [self.poundsTextField.text intValue] + ((float)[self.pencesTextField.text intValue] / 100);
        [self.delegate addBillItem:self withAmount:amount withBillItemViewId:self.billItemViewId];
    } else {
        [self.delegate removeBillItem:self forBillItemView:self.billItemViewId];
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}




#pragma mark - ViewController initialization

-(void) setSteppers {
    self.poundsStepper.value = [self.poundsTextField.text intValue];
    self.pencesStepper.value = [self.pencesTextField.text intValue];
}

-(void)setupViewController {
    self.view.frame = CGRectMake(0, 0, 320, self.pencesStepper.frame.origin.y + self.pencesStepper.frame.size.height + 20);
    
    CGFloat midX = 320 / 2;
    
    self.poundsTextField.frame = MRGRectMakeSetX(midX - self.poundsTextField.frame.size.width - 5,
                                                 self.poundsTextField.frame);
    self.pencesTextField.frame = MRGRectMakeSetX(midX + 5,
                                                 self.poundsTextField.frame);
    self.poundsStepper.frame = MRGRectMakeSetX(midX - self.poundsStepper.frame.size.width - 5,
                                               self.poundsStepper.frame);
    self.pencesStepper.frame = MRGRectMakeSetX(midX +5,
                                               self.pencesStepper.frame);
    
    // http://stackoverflow.com/a/10794377/179843
    // and if works answer
    // http://stackoverflow.com/questions/11555393/how-to-use-the-numberpad-from-iphone-on-ipad
//    self.poundsTextField.keyboardType = UIKeyboardTypeDecimalPad;
//    self.pencesTextField.keyboardType = UIKeyboardTypeDecimalPad;
    
    [self setSteppers];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self setupViewController];
    }
    return self;
}

- (void)awakeFromNib {
    [self setupViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setBillImageView:nil];
    [self setPoundsTextField:nil];
    [self setPencesTextField:nil];
    [self setPoundsStepper:nil];
    [self setPencesStepper:nil];
    [super viewDidUnload];
}
@end
