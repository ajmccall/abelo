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
#import "MRGRectMake.h"

// enum to control the drawing state of the recipet view
enum ViewsDrawState {
    ViewsDrawStateStart = 0,
    ViewsDrawStateImage = 1,
    ViewsDrawStateBillItems = 2,
    ViewsDrawStateTotal = 3,
    ViewsDrawStateLinking = 4
} typedef ViewsDrawState;

#pragma mark - AbeloViewController PRIVATE interface
@interface AbeloViewController ()

@property (nonatomic) AbeloBill *bill;
@property (nonatomic) UIPopoverController *popover;
@property (nonatomic) ViewsDrawState viewsDrawState;

- (void) showPartyMemberViewControllerAtView:(id) view;
- (void) showBillItemViewControllerAtView:(id) view;

@end

#pragma mark - AbeloViewController implementation
@implementation AbeloViewController

@synthesize toolbar = _toolbar;
@synthesize backButton = _backButton;
@synthesize okButton = _okButton;
@synthesize nextButton = _nextButton;
@synthesize mainView = _mainView;

#pragma mark - Property synthesize declarations
@synthesize popover = _popover;
@synthesize bill = _bill;

#pragma mark - Property synthesize implementations

- (AbeloBill *)bill {
    if(!_bill){
        _bill = [[AbeloBill alloc] init];
    }
    return _bill;
}

- (UIPopoverController *)popover {
    if(!_popover) {
        _popover = [[UIPopoverController alloc] initWithContentViewController:self];
    }
    _popover.delegate = self;
    return _popover;
}

#pragma mark - Implmentations

- (void) showPartyMemberViewControllerAtView:(id) viewId {
    
    // instantiate the viewController
    AbeloPartyMemberViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AbeloPartyMemberViewController"];
    vc.delegate = self;
    self.popover.contentViewController = vc;
    self.popover.popoverContentSize = CGSizeMake(320, 120);

    // set party member view congtroller properties.
    vc.partyMemberViewId = viewId;
    // if party member already exists, set name, billItems and total to display
    if([self.bill partyMemberNameForId:viewId]){
        vc.name = [self.bill partyMemberNameForId:viewId];
        vc.billItems = [self.bill partyMemberBillItemsForId:viewId];
        vc.total = [self.bill partyMemberTotalForId:viewId];
        vc.color = [self.bill partyMemberColorForId:viewId];
    }
    
    // determine the rect of the partyMember view, and translate that according to the main
    // view so that the popoverVC displays properly
    CGRect rect = ((UIView *) viewId).frame;
    rect = [self.mainView translatePartyMemberRectInMainView:rect];
    
    //display
    [self.popover presentPopoverFromRect:rect inView:self.mainView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

- (void) showBillItemViewControllerAtView:(id) viewId {

    // instantiate the viewController
    AbeloBillItemViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AbeloBillItemViewController"];
    vc.delegate = self;
    self.popover.contentViewController = vc;
    self.popover.popoverContentSize = CGSizeMake(320, 240);

    // set bill item view controller properties
    vc.billItemViewId = viewId;
    
    //if bill item exists, set total
    if([self.bill billItemExistForId:viewId]){
        vc.total = [self.bill billItemTotalForId:viewId];
    }
    
    CGRect rect = [((NSValue *)viewId) CGRectValue];
    vc.image = [self.mainView getImageForRect:rect];
    [self.popover presentPopoverFromRect:[self.mainView scaleAndTranslateRectIfNecessary:rect] inView:self.mainView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}


#pragma mark - ViewController initialise

- (void) setup {
    self.backButton.enabled = NO;
    self.okButton.enabled = NO;
    self.mainView.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setup];
}

- (void)viewDidUnload
{
    [self setToolbar:nil];
    [self setBackButton:nil];
    [self setOkButton:nil];
    [self setNextButton:nil];
    [self setMainView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - Outlet Actions

- (IBAction)backButtonAction:(id) sender {
    switch (self.viewsDrawState) {
        default:
            break;
    }

    if(self.viewsDrawState != ViewsDrawStateStart){
        self.viewsDrawState--;
    }
}

- (IBAction)nextButtonAction:(id) sender{
    
    if(self.viewsDrawState != ViewsDrawStateLinking){
        self.viewsDrawState++;
    }
    
    switch (self.viewsDrawState) {
        case ViewsDrawStateStart:
        case ViewsDrawStateImage:
            self.mainView.image = [UIImage imageNamed:@"dimt.jpg"];
            [self nextButtonAction:sender];
            break;
        default:
            break;
    }
}

- (IBAction)okButtonAction:(id) sender {
}


- (IBAction)testDummyAction:(id)sender {
}

#pragma mark - Gesture recognizers


#define ARC4RANDOM_MAX 0x100000000

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
#pragma mark - AbeloMainViewDelegate

- (void)showPartyMemberController:(AbeloMainView *)sender forViewId:(id)viewId {
    [self showPartyMemberViewControllerAtView:viewId];
}

- (void)showBillItemController:(AbeloMainView *)sender forViewId:(id)viewId {
    [self showBillItemViewControllerAtView:viewId];
}

- (void)addBillItem:(AbeloMainView *)sender forBillItemViewId:(id)billItemViewId toPartyMemberWithViewId:(id)partyMemberViewId {
    
    if([self.bill partyMemberNameForId:partyMemberViewId]){
        [self.bill addBillItemWithId:billItemViewId
                 toPartyMemberWithId:partyMemberViewId
                      withPercentage:1.0];
        
        [self.mainView updatePartyMemberId:partyMemberViewId
                                 withTotal:[self.bill partyMemberTotalForId:partyMemberViewId]
                            andNumberItems:[self.bill numberOfItemsForPartyMemberForId:partyMemberViewId]];
    }
    
}

#pragma mark - AbeloPartyMemberProtocol

- (void)setPartyMember:(AbeloPartyMemberViewController *)sender withName:(NSString *)name andColor:(UIColor *)color {
    
    //if partyMember exists, then update view
    if([self.bill partyMemberNameForId:sender.partyMemberViewId]){
        //update the bill model
        [self.bill setPartyMemberWithId:sender.partyMemberViewId name:name color:color];
        //update ui
        [self.mainView updatePartyMemberId:sender.partyMemberViewId withName:name andColor:sender.view.backgroundColor];
    } else {
        // else add new partyMember
        id viewId = [self.mainView addPartyMemberWithName:name andColor:color];
        [self.bill setPartyMemberWithId:viewId name:name color:color];
    }
    
    [self.popover dismissPopoverAnimated:YES];
}

- (void)editPartyMember:(AbeloPartyMemberViewController *)sender withNewName:(NSString *)newName andNewColor:(UIColor *)newColor {
    //if partyMember exists, then update view
    if([self.bill partyMemberNameForId:sender.partyMemberViewId]){
        //update the bill model
        [self.bill setPartyMemberWithId:sender.partyMemberViewId name:newName color:newColor];
        //update ui
        [self.mainView updatePartyMemberId:sender.partyMemberViewId withName:newName andColor:sender.view.backgroundColor];
    }
}

- (void)deletePartyMember:(AbeloPartyMemberViewController *)sender {
    
}

- (void) cancelViewController:(AbeloPartyMemberViewController *)sender {
    [self.popover dismissPopoverAnimated:YES];
}

#pragma mark - AbeloBillItemViewProtocol

- (void)setBillItem:(AbeloBillItemViewController *)sender withAmount:(int)billItemAmount{
    [self.bill setBillItemWithId:sender.billItemViewId withTotal:billItemAmount];
    [self.mainView setCurrentRectAsBillItem];
    [self.popover dismissPopoverAnimated:YES];
}

- (void) editBilItem:(AbeloBillItemViewController *)sender withNewAmount:(int)billItemAmount {
    if([self.bill billItemExistForId:sender.billItemViewId]){
        [self.bill setBillItemWithId:sender.billItemViewId withTotal:billItemAmount];
    }
}

- (void)deleteBillItem:(AbeloBillItemViewController *)sender{
    [self.popover dismissPopoverAnimated:YES];
}

- (void) cancelController:(AbeloBillItemViewController *)sender {
    [self.popover dismissPopoverAnimated:YES];
    if(![self.bill billItemExistForId:sender.billItemViewId]){
        [self.mainView clearCurrentBillItem];
    }
}

#pragma mark - UIPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    [self.popover dismissPopoverAnimated:YES];
}


# pragma mark - Private methods

@end
