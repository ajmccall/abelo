//
//  AbeloViewController.m
//  Abelo
//
//  Created by Alasdair McCall on 06/09/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import "AbeloViewController.h"
#import "AbeloBill.h"
#import "AbeloUtilities.h"
#import "AbeloReceiptView.h"

@interface AbeloViewController ()

- (void) hideAddGuestView;
- (void) showAddGuestView;
- (void) addGuestViewWithName:(NSString *) guestName;

@property (nonatomic) AbeloBill *bill;
@property (nonatomic) CGPoint newLabelPoint;

@property (nonatomic) NSMutableArray *partyMemberViews;
@property (nonatomic) UIPopoverController *popover;

@property (nonatomic) AbeloCreationState creationState;

@end

@implementation AbeloViewController


@synthesize addGuestView;
@synthesize addGuestLabel;
@synthesize addGuestInput;
@synthesize addGuestButton;
@synthesize receiptView = _receiptView;

- (void)setReceiptView:(AbeloReceiptView *)receiptView {
    _receiptView = receiptView;
    [self.receiptView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:_receiptView action:@selector(panGesture:)]];
    [self.receiptView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:_receiptView action:@selector(pinchGesture:)]];

}

@synthesize partyMemberViews = _partyMemberViews;
@synthesize bill = _bill;
@synthesize popover = _popover;

- (NSMutableArray *)partyMemberViews {
    if(!_partyMemberViews) {
        _partyMemberViews = [[NSMutableArray alloc] init];
    }
    return _partyMemberViews;
}

- (UIPopoverController *)popover {
    if(!_popover) {
        _popover = [[UIPopoverController alloc] initWithContentViewController:self];
    }
    return _popover;
}

- (AbeloBill *)bill {
    if(_bill){
        _bill = [[AbeloBill alloc] init];
    }
    return _bill;
}

- (void) setup {
    [self hideAddGuestView];
    
    //testing
    self.creationState = AbeloCreationState2MenuItems;
    self.receiptView.drawState = ReceiptViewDrawMenuItems;
    
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
    [self setReceiptView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (IBAction)addGuestButtonPressed {
    [self showAddGuestView];
}

- (IBAction)addGuestInputAction:(UITextField *)sender {
    [self hideAddGuestView];
    [self addGuestViewWithName:sender.text];
}


- (void) addGuestViewWithName:(NSString *)guestName {
    [self.bill addPartyEntity:guestName];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.newLabelPoint.x, self.newLabelPoint.y, 87, 33)];
    label.text = guestName;
    [self.view addSubview:label];
    [self.view setNeedsDisplay];
    self.newLabelPoint = CGPointMake(self.newLabelPoint.x, self.newLabelPoint.y + 33);
    [self.partyMemberViews addObject:label];
}

# pragma mark -
# pragma mark Button actions

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
    
    self.receiptView.image = imageToSave;
    [self incrementCreationStep];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)decrementCreationStep {
    if(self.creationState != AbeloCreationState0Start) {
        self.creationState--;
    }
    
    switch (self.creationState) {
        case AbeloCreationState5End:
        case AbeloCreationState4PartyMembers:
        case AbeloCreationState3Total:
        case AbeloCreationState2MenuItems:
        case AbeloCreationState1Image:
        case AbeloCreationState0Start:
        default:
            break;
    }
}

- (IBAction)incrementCreationStep {
    if(self.creationState != AbeloCreationState5End){
        self.creationState++;
    }
    
    switch (self.creationState) {
        case AbeloCreationState1Image:
            [self initialiseCamera];
            break;
        case AbeloCreationState2MenuItems:
            self.receiptView.drawState = ReceiptViewDrawMenuItems;
            break;
        case AbeloCreationState3Total:
        case AbeloCreationState4PartyMembers:
        case AbeloCreationState5End:
        default:
            break;
    }
}

- (IBAction)okButtonAction {
    switch (self.creationState) {
        case AbeloCreationState2MenuItems:
            break;
        case AbeloCreationState1Image:
        case AbeloCreationState3Total:
        case AbeloCreationState4PartyMembers:
        case AbeloCreationState5End:
        default:
            break;
    }
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
