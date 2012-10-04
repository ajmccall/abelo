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
#import "AbeloLinkersView.h"
#import "AbeloPartyMembersView.h"
#import "AbeloMainView.h"

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

+ (NSString *) GenerateRandStringLength:(int) len;

@property (nonatomic) AbeloBill *bill;
@property (nonatomic) UIPopoverController *popover;
@property (nonatomic) UIGestureRecognizer *panGesture;
@property (nonatomic) ViewsDrawState viewsDrawState;

- (void) showPartyMemberViewController;
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
@synthesize panGesture = _panGesture;
@synthesize popover = _popover;
@synthesize bill = _bill;

#pragma mark - Property synthesize implementations

- (AbeloBill *)bill {
    if(!_bill){
        _bill = [[AbeloBill alloc] init];
    }
    return _bill;
}

- (UIGestureRecognizer *)panGesture {
    if(!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    }
    return _panGesture;
}

- (UIPopoverController *)popover {
    if(!_popover) {
        _popover = [[UIPopoverController alloc] initWithContentViewController:self];
    }
    _popover.delegate = self;
    return _popover;
}

#pragma mark - Implmentations

- (void) showPartyMemberViewController {
    
    AbeloAddPartyMemberViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AbeloAddPartyMemberViewController"];
    vc.delegate = self;
    self.popover.contentViewController = vc;
    self.popover.popoverContentSize = CGSizeMake(320, 120);
    [self.popover presentPopoverFromBarButtonItem:self.okButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

- (void) showBillItemViewControllerAtView:(id) viewId {
    AbeloBillItemViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AbeloBillItemViewController"];
    vc.delegate = self;
    self.popover.contentViewController = vc;
    
    CGRect rect = [((NSValue *)viewId) CGRectValue];
    vc.image = [self.mainView getImageForRect:rect];
    vc.billItemViewId = viewId;
    self.popover.popoverContentSize = CGSizeMake(320, 240);
    [self.popover presentPopoverFromRect:rect inView:self.mainView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}


#pragma mark - ViewController initialise

- (void) setup {
    self.backButton.enabled = NO;
    self.okButton.enabled = NO;
    [self.view addGestureRecognizer:self.panGesture];

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
//        case ViewsDrawStateBillItems:
//            if([self.mainView clearLastBillItem]) {
//                return;
//            }
//            [self.view removeGestureRecognizer:self.panGesture];
//            [self.mainView clearView];
//            self.okButton.enabled = NO;
//            self.backButton.enabled = NO;
//
//            self.viewsDrawState--;
//            break;
//        case ViewsDrawStateTotal:
//            if([self.mainView clearLastBillItem]) {
//                return;
//            }
//            break;
//        case ViewsDrawStateImage:
//        case ViewsDrawStateStart:
//        case ViewsDrawStateLinking:
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
        case ViewsDrawStateBillItems:
            self.okButton.enabled = YES;
            self.backButton.enabled = YES;
            break;
        case ViewsDrawStateTotal:
            [self.mainView setCurrentRectAsTotal];
            break;
        case ViewsDrawStateLinking:
            self.okButton.enabled = NO;
            self.nextButton.enabled = NO;
            break;
        default:
            break;
    }
}

- (IBAction)okButtonAction:(id) sender {
    switch (self.viewsDrawState) {
        case ViewsDrawStateBillItems: {
            [self.bill addBillItemWithId:[self.mainView setCurrentRectAsBillItem] withTotal:5.50];
            break;
        }
        case ViewsDrawStateTotal:
            [self.mainView setCurrentRectAsTotal];
            break;
        case ViewsDrawStateImage:
        case ViewsDrawStateStart:
        case ViewsDrawStateLinking:
        default:
            break;
    }
}


- (IBAction)testDummyAction:(id)sender {
}

#pragma mark - Gesture recognizers

#define ARC4RANDOM_MAX 0x100000000

- (void)panGesture:(UIPanGestureRecognizer *)gesture {
    
    CGPoint touchInMainView = [gesture locationInView:self.mainView];
    
    if(gesture.numberOfTouches == 0){

        if(self.viewsDrawState == ViewsDrawStateLinking && self.mainView.isDrawing){
            [self.mainView addToCurrentLinkerPoint:touchInMainView];
            [self.mainView setCurrentLinkerWithColor:[UIColor colorWithRed:((double)arc4random() / ARC4RANDOM_MAX)
                                                                     green:((double)arc4random() / ARC4RANDOM_MAX)
                                                                      blue:((double)arc4random() / ARC4RANDOM_MAX)
                                                                     alpha:0.8]
             ];
        } else if(self.viewsDrawState == ViewsDrawStateBillItems) {
            
            id someUI = [self.mainView anyUIViewAtPoint:touchInMainView];
            if(someUI){
                if([someUI isKindOfClass:[NSValue class]]){
                    [self showBillItemViewControllerAtView:someUI];
                }
            }
            
        }
    } else if(gesture.numberOfTouches == 1){
        if(self.viewsDrawState == ViewsDrawStateBillItems){
            
            if(gesture.state == UIGestureRecognizerStateBegan ||
               gesture.state == UIGestureRecognizerStateChanged) {
                [self.mainView addPointToCurrentRect:touchInMainView];
            } else {
                ULog(@"panGesture.state unknown[%d]", gesture.state);
            }
        } else if(self.viewsDrawState == ViewsDrawStateTotal){
            
            if(gesture.state == UIGestureRecognizerStateBegan ||
               gesture.state == UIGestureRecognizerStateChanged) {
                [self.mainView addPointToCurrentRect:touchInMainView];
            } else {
                ULog(@"panGesture.state unknown[%d]", gesture.state);
            }
        } else if(self.viewsDrawState == ViewsDrawStateLinking) {
            
            if(gesture.state == UIGestureRecognizerStateBegan ||
               gesture.state == UIGestureRecognizerStateChanged) {
                [self.mainView addToCurrentLinkerPoint:touchInMainView];
            } else {
                DLog(@"gesture.state[%d] unknow", gesture.state);
            }
        }
    } else if(gesture.numberOfTouches == 2){
        [self.mainView panGesture:gesture];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    CGPoint touchPoint = [[touches anyObject] locationInView:self.mainView];
    
    // add touch if we are drawing menu itme rectaganles or the total rectangles
    if([touches count] == 1){
        if(self.viewsDrawState == ViewsDrawStateBillItems ||
           self.viewsDrawState == ViewsDrawStateTotal) {
            [self.mainView addPointToCurrentRect:touchPoint];
        } else if(self.viewsDrawState == ViewsDrawStateLinking){
            
            //check that a uiView exists
            if([self.mainView anyUIViewAtPoint:touchPoint]){
                if([self.bill billItemExistForViewId:[[self.mainView uiViewsAtPoint:touchPoint] objectAtIndex:0]]){
                    [self.mainView startLinkerFromPoint:touchPoint];
                }
            }
       }
    }
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

#pragma mark - UIPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    //check viewController to see which VC it came from in order to
    // determine if anything needs to be done
    [self.popover dismissPopoverAnimated:YES];
}

#pragma mark - AbeloAddPartyMemberProtocol

- (void)addPartyMember:(AbeloAddPartyMemberViewController *)sender withName:(NSString *)name andColor:(UIColor *)color {
    [self.bill addPartyMemberWithViewId:[self.mainView addPartyMemberWithName:name andColor:color] withName:name];
    [self.popover dismissPopoverAnimated:YES];
}

- (void) cancelAddPartyMember:(AbeloAddPartyMemberViewController *)sender {
    [self.popover dismissPopoverAnimated:YES];
}

#pragma mark - AbeloBillItemViewProtocol

- (void)addBillItem:(AbeloBillItemViewController *)sender withAmount:(float)billItemAmount withBillItemViewId:(id)viewId{
    [self.bill addBillItemWithId:viewId withTotal:billItemAmount];
    [self.popover dismissPopoverAnimated:YES];
}

- (void)removeBillItem:(AbeloBillItemViewController *)sender forBillItemView:(id)view{
    [self.popover dismissPopoverAnimated:YES];
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
