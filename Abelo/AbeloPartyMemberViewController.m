//
//  AbeloPartyMemberViewController.m
//  Abelo
//
//  Created by Alasdair McCall on 03/10/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import "AbeloPartyMemberViewController.h"
#import "MRGRectMake.h"

@interface AbeloPartyMemberViewController ()

@end

@implementation AbeloPartyMemberViewController

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
@synthesize partyMemberViewId = _partyMemberViewId;
@synthesize total = _total;
@synthesize billItems = _bilItems;
@synthesize name = _name;
@synthesize color = _color;

#pragma mark - Properties synthesis implementations

- (void)setName:(NSString *)name {
    _name = name;
    self.textInput.text = name;
}

- (void)setColor:(UIColor *)color {
    _color = color;
    self.view.backgroundColor = color;
    [self.view setNeedsDisplay];
}


#pragma mark - Actions

- (IBAction)colorAction:(id)sender {
    self.color = [AbeloPartyMemberViewController generatePartyMemberColor];
    [self.delegate editPartyMember:self withNewName:self.name andNewColor:self.color];
}

#pragma mark - UITextFieldDelegate

- (void) textFieldDidEndEditing:(UITextField *)textField {
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(![self.textInput.text isEqualToString:@""]){
        [self.delegate setPartyMember:self withName:self.textInput.text andColor:self.view.backgroundColor];
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
