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

#pragma mark - AbeloViewController PRIVATE interface
@interface AbeloViewController ()

+ (NSString *) GenerateRandStringLength:(int) len;

@property (nonatomic) AbeloBill *bill;
@property (nonatomic) UIPopoverController *popover;
@property (nonatomic) UIGestureRecognizer *pinchGesture;
@property (nonatomic) UIGestureRecognizer *panGesture;

@end

#pragma mark - AbeloViewController implementation
@implementation AbeloViewController

@synthesize toolbar = _toolbar;
@synthesize backButton = _backButton;
@synthesize okButton = _okButton;
@synthesize nextButton = _nextButton;

#pragma mark - Property synthesize declarations
@synthesize receiptView = _receiptView;
@synthesize partyMembersView = _partyMembersView;
@synthesize panGesture = _panGesture;
@synthesize pinchGesture = _pinchGesture;
@synthesize popover = _popover;
@synthesize bill = _bill;

#pragma mark - Property synthesize implementations

- (void)setReceiptView:(AbeloReceiptView *)receiptView {
    _receiptView = receiptView;
}

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

- (UIGestureRecognizer *)pinchGesture {
    if(!_pinchGesture) {
        _pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
    }
    return _pinchGesture;
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
    [self setBackButton:nil];
    [self setOkButton:nil];
    [self setNextButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - Outlet Actions

- (IBAction)addGuestAction:(id)sender {
    NSString *name = [AbeloViewController GenerateRandStringLength:3];
    [self.bill addPartyMemberWithName:name];
    [self.partyMembersView addPartyMemberWithName:name];
}

- (IBAction)backButtonAction:(id) sender {
    switch (self.receiptView.drawState) {
        case AbeloReceiptViewDrawStateMenuItems:
            if([self.receiptView clearLastMenuItem]) {
                return;
            }
            [self.view removeGestureRecognizer:self.panGesture];
            [self.view removeGestureRecognizer:self.pinchGesture];
            [self.receiptView clearView];
            self.okButton.enabled = NO;
            self.backButton.enabled = NO;

            self.receiptView.drawState--;
            break;
        case AbeloReceiptViewDrawStateTotal:
            if([self.receiptView clearLastMenuItem]) {
                return;
            }
            break;
        case AbeloReceiptViewDrawStateImage:
        case AbeloReceiptViewDrawStateStart:
        case AbeloReceiptViewDrawStateFinished:
        default:
            break;
    }

    if(self.receiptView.drawState != AbeloReceiptViewDrawStateStart){
        self.receiptView.drawState--;
    }
}

- (IBAction)nextButtonAction:(id) sender {
    if(self.receiptView.drawState != AbeloReceiptViewDrawStateFinished){
        self.receiptView.drawState++;
    }
    
    switch (self.receiptView.drawState) {
        case AbeloReceiptViewDrawStateStart:
        case AbeloReceiptViewDrawStateImage:
            self.receiptView.image = [UIImage imageNamed:@"dimt.jpg"];
            [self nextButtonAction:sender];
            break;
        case AbeloReceiptViewDrawStateMenuItems:
            [self.view addGestureRecognizer:self.panGesture];
            [self.view addGestureRecognizer:self.pinchGesture];
            self.okButton.enabled = YES;
            self.backButton.enabled = YES;
            break;
        case AbeloReceiptViewDrawStateTotal:
            [self.receiptView setCurrentRectAsTotal];
            break;
        case AbeloReceiptViewDrawStateFinished:
            self.okButton.enabled = NO;
            self.nextButton.enabled = NO;
            [self.view removeGestureRecognizer:self.panGesture];
            [self.view removeGestureRecognizer:self.pinchGesture];
            break;
        default:
            break;
    }
}

- (IBAction)okButtonAction:(id) sender {
    switch (self.receiptView.drawState) {
        case AbeloReceiptViewDrawStateMenuItems: {
            int menuItemId = [self.bill addBillItem:@"fake name" withTotal:5.50];
            [self.receiptView setCurrentRectAsMenuItemWithId:menuItemId];
            break;
        }
        case AbeloReceiptViewDrawStateTotal:
            [self.receiptView setCurrentRectAsTotal];
            break;
        case AbeloReceiptViewDrawStateImage:
        case AbeloReceiptViewDrawStateStart:
        case AbeloReceiptViewDrawStateFinished:
        default:
            break;
    }
}

#pragma mark - Gesture recognizers

- (void)pinchGesture:(UIPinchGestureRecognizer *)gesture {
    
    if(gesture.state == UIGestureRecognizerStateBegan){
        gesture.scale = self.receiptView.drawScale;
    } else if(gesture.state == UIGestureRecognizerStateChanged){
        self.receiptView.drawScale = gesture.scale;
        CGPoint midPoint = [gesture locationInView:self.receiptView];
        CGFloat x = midPoint.x + self.receiptView.drawScale * (self.receiptView.frame.origin.x - midPoint.x);
        CGFloat y = midPoint.y + self.receiptView.drawScale * (self.receiptView.frame.origin.y - midPoint.y);
        self.receiptView.drawOffset = CGPointMake(x,y);
        
    }
}

- (void)panGesture:(UIPanGestureRecognizer *)gesture {
    
    if(self.receiptView.drawState == AbeloReceiptViewDrawStateMenuItems &&
       gesture.numberOfTouches == 1){
        
        if(gesture.state == UIGestureRecognizerStateBegan ||
           gesture.state == UIGestureRecognizerStateChanged) {
            [self.receiptView addPointToCurrentRect:[gesture locationInView:self.receiptView]];
        } else {
            ULog(@"panGesture.state unknown[%d]", gesture.state);
        }
    } if(self.receiptView.drawState == AbeloReceiptViewDrawStateTotal &&
         gesture.numberOfTouches == 1){
        
        if(gesture.state == UIGestureRecognizerStateBegan ||
           gesture.state == UIGestureRecognizerStateChanged) {
            [self.receiptView addPointToCurrentRect:[gesture locationInView:self.receiptView]];
        } else {
            ULog(@"panGesture.state unknown[%d]", gesture.state);
        }
    } else if(gesture.numberOfTouches == 2){
        if(gesture.state == UIGestureRecognizerStateBegan ||
           gesture.state == UIGestureRecognizerStateChanged) {
            
            self.receiptView.drawOffset = CGPointMake(self.receiptView.drawOffset.x + [gesture translationInView:self.receiptView].x,
                                          self.receiptView.drawOffset.y + [gesture translationInView:self.receiptView].y);
            
            [gesture setTranslation:CGPointMake(0,0) inView:self.receiptView];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    
    // add touch if we are drawing menu itme rectaganles or the total rectangles
    if([touches count] == 1 &&
       CGRectContainsPoint(self.receiptView.frame, [touch locationInView:self.receiptView]) &&
       (self.receiptView.drawState == AbeloReceiptViewDrawStateMenuItems ||
        self.receiptView.drawState == AbeloReceiptViewDrawStateTotal)) {
           
//           DLog(@"touch[%d] at p(%g, %g)", [touches count], [touch locationInView:self.receiptView].x, [touch locationInView:self.receiptView].y);
           [self.receiptView addPointToCurrentRect:[touch locationInView:self.receiptView]];
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
