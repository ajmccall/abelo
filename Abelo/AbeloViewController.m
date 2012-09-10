//
//  AbeloViewController.m
//  Abelo
//
//  Created by Alasdair McCall on 06/09/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import "AbeloViewController.h"
#import "AbeloBill.h"

@interface AbeloViewController ()

- (void) hideAddGuestView;
- (void) showAddGuestView;
- (void) addGuestViewWithName:(NSString *) guestName;

@property (nonatomic) AbeloBill *bill;
@property (nonatomic) CGPoint newLabelPoint;

@property (nonatomic) NSMutableArray *guestViews;

@end

@implementation AbeloViewController

@synthesize addGuestView;
@synthesize addGuestLabel;
@synthesize addGuestInput;
@synthesize addGuestButton;

@synthesize guestViews = _guestViews;
@synthesize bill = _bill;

+ (void)initialize {
    
}

- (NSMutableArray *)guestViews {
    if(!_guestViews) {
        _guestViews = [[NSMutableArray alloc] init];
    }
    return _guestViews;
}

- (AbeloBill *)bill {
    if(_bill){
        _bill = [[AbeloBill alloc] init];
    }
    return _bill;
}

- (void) setup {
    [self hideAddGuestView];
    
    CGRect buttonRect = addGuestButton.frame;
    self.newLabelPoint =  CGPointMake(buttonRect.origin.x, buttonRect.origin.y + buttonRect.size.height);
    self.addGuestInput.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setup];
}

- (void)viewDidUnload
{
    [self setAddGuestView:nil];
    [self setAddGuestLabel:nil];
    [self setAddGuestInput:nil];

    [self setAddGuestButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (IBAction)addGuestButtonPressed {
    [self showAddGuestView];
}

- (IBAction)addGuestInputAction:(UITextField *)sender {
    [self hideAddGuestView];
    [self addGuestViewWithName:sender.text];
}


- (void) addGuestViewWithName:(NSString *)guestName {
    int index = [self.bill addPartyEntity:guestName];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.newLabelPoint.x, self.newLabelPoint.y, 87, 33)];
    label.text = guestName;
    [self.view addSubview:label];
    
    [self.view setNeedsDisplay];
    self.newLabelPoint = CGPointMake(self.newLabelPoint.x, self.newLabelPoint.y + 33);
}

# pragma mark -
# pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(![self.addGuestInput.text isEqualToString:@""]) {
        [self.addGuestInput resignFirstResponder];
    }
    return YES;
}


# pragma mark -
# pragma mark Private methods

- (void) setGuestViewVisibility:(BOOL) visibile {
    self.addGuestInput.hidden = !visibile;
    self.addGuestLabel.hidden = !visibile;
    self.addGuestView.hidden = !visibile;
    
    self.addGuestButton.enabled = !visibile;
}

- (void)hideAddGuestView {
    [self setGuestViewVisibility:NO];
}

- (void)showAddGuestView {
    [self setGuestViewVisibility:YES];
    self.addGuestInput.text = @"";
}
@end
