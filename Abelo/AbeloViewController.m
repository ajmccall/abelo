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

#pragma mark - ViewController initialise

- (UIPopoverController *)popover {
    if(!_popover) {
        _popover = [[UIPopoverController alloc] initWithContentViewController:self];
    }
    return _popover;
}

- (void) setup {
    self.backButton.enabled = NO;
    self.okButton.enabled = NO;
    [self.mainView partyMembersViewDelegate:self];
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

- (IBAction)addGuestAction:(id)sender {
    NSString *name = [AbeloViewController GenerateRandStringLength:3];
    [self.bill addPartyMemberWithName:name];
    [self.mainView addPartyMemberWithName:name];
}

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
            [self.bill addBillItem:@"fake name" withTotal:5.50];
            [self.mainView setCurrentRectAsBillItem];
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
    
    if(gesture.numberOfTouches == 0
       && self.viewsDrawState == ViewsDrawStateLinking &&
       self.mainView.isDrawing){
        [self.mainView addToCurrentLinkerPoint:[gesture locationInView:self.mainView]];
        [self.mainView setCurrentLinkerWithColor:[UIColor colorWithRed:((double)arc4random() / ARC4RANDOM_MAX)
                                                                 green:((double)arc4random() / ARC4RANDOM_MAX)
                                                                  blue:((double)arc4random() / ARC4RANDOM_MAX)
                                                                 alpha:0.8]
         ];
    } else if(gesture.numberOfTouches == 1){
        if(self.viewsDrawState == ViewsDrawStateBillItems){
            
            if(gesture.state == UIGestureRecognizerStateBegan ||
               gesture.state == UIGestureRecognizerStateChanged) {
                [self.mainView addPointToCurrentRect:[gesture locationInView:self.mainView]];
            } else {
                ULog(@"panGesture.state unknown[%d]", gesture.state);
            }
        } else if(self.viewsDrawState == ViewsDrawStateTotal){
            
            if(gesture.state == UIGestureRecognizerStateBegan ||
               gesture.state == UIGestureRecognizerStateChanged) {
                [self.mainView addPointToCurrentRect:[gesture locationInView:self.mainView]];
            } else {
                ULog(@"panGesture.state unknown[%d]", gesture.state);
            }
        } else if(self.viewsDrawState == ViewsDrawStateLinking) {
            
            if(gesture.state == UIGestureRecognizerStateBegan ||
               gesture.state == UIGestureRecognizerStateChanged) {
                [self.mainView addToCurrentLinkerPoint:[gesture locationInView:self.mainView]];
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
    UITouch *touch = [touches anyObject];
    
    // add touch if we are drawing menu itme rectaganles or the total rectangles
    if([touches count] == 1){
        if(self.viewsDrawState == ViewsDrawStateBillItems ||
           self.viewsDrawState == ViewsDrawStateTotal) {
            [self.mainView addPointToCurrentRect:[touch locationInView:self.mainView]];
        } else if(self.viewsDrawState == ViewsDrawStateLinking){
           [self.mainView startLinkerFromPoint:[touch locationInView:self.mainView]];
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


#pragma mark - ReceiptViewDelegate protocol

- (UIImage *)getImage {
    return [UIImage imageNamed:@"dimt.jpg"];
}

- (void) addBillItemWithIndex:(int) index {
}

- (void) clearBillItemWithIndex:(int) index {
    
}

#pragma mark - PartyMembersViewDelegate protocol

- (void)addPartyMember:(id)sender {
    [self addGuestAction:sender];
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
