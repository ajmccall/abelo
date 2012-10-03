//
//  AbeloAddPartyMemberViewController.m
//  Abelo
//
//  Created by Alasdair McCall on 03/10/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import "AbeloAddPartyMemberViewController.h"
#import "MRGRectMake.h"

@interface AbeloAddPartyMemberViewController ()

@end

@implementation AbeloAddPartyMemberViewController

#pragma mark - Private
#define ARC4RANDOM_MAX 0x100000000

+ (UIColor *) generatePartyMemberColor {
    return [UIColor colorWithRed:((double)arc4random() / ARC4RANDOM_MAX)
                           green:((double)arc4random() / ARC4RANDOM_MAX)
                            blue:((double)arc4random() / ARC4RANDOM_MAX)
                           alpha:0.8];
}

#pragma mark - Property synthesize

@synthesize delegate = _delegate;

#pragma mark - Actions

- (IBAction)colorAction:(id)sender {
    self.view.backgroundColor = [AbeloAddPartyMemberViewController generatePartyMemberColor];
    [self.view setNeedsDisplay];
}

#pragma mark - UITextFieldDelegate

- (void) textFieldDidEndEditing:(UITextField *)textField {
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(![self.textInput.text isEqualToString:@""]){
        [self.delegate addPartyMember:self withName:self.textInput.text andColor:self.view.backgroundColor];
    }
    [self.textInput resignFirstResponder];
    return YES;
}

#pragma mark - ViewController initialisation

-(void) setupViewController {
    [self colorAction:nil];
    self.textInput.delegate = self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
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
    [self setTextInput:nil];
    [super viewDidUnload];
}
@end
