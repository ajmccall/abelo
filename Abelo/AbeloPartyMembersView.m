//
//  AbeloPartyMembersView.m
//  Abelo
//
//  Created by Alasdair McCall on 21/09/2012.
//  Copyright (c) 2012 Alasdair McCall. All rights reserved.
//

#import "AbeloPartyMembersView.h"
#import "AbeloPartyMemberView.h"
#import "MRGRectMake.h"

@interface AbeloPartyMembersView ()

@property (nonatomic) CGFloat newPartyMemberViewPosition;
@property (nonatomic) int labelIndex;
@property (nonatomic) NSMutableDictionary *partyMembers;
@property (nonatomic) IBOutlet UILabel *addPartyMemberLabel;
@end

#define ADD_PARTY_MEMBER_LABEL_TAG 314

@implementation AbeloPartyMembersView

@synthesize labelIndex = _labelIndex;
@synthesize partyMembers = _partyMembers;
@synthesize newPartyMemberViewPosition = _newPartyMemberViewPosition;
@synthesize addPartyMemberLabel = _addPartyMemberLabel;

@synthesize delegate = _delegate;

#pragma mark - Method implementations

- (void)addPartyMemberWithName:(NSString *)name {
    
    AbeloPartyMemberView *view = [[AbeloPartyMemberView alloc] init];
    view.frame = MRGRectMakeSetXY(0, self.newPartyMemberViewPosition, view.frame);
    view.frame = MRGRectMakeSetWidth(self.frame.size.width, view.frame);
    view.name = name;
    view.total = 0;
    
    if(self.labelIndex % 2 == 0) {
        [view setColor:[UIColor yellowColor]];
    } else {
        [view setColor:[UIColor cyanColor]];
    }

    self.labelIndex++;
    self.newPartyMemberViewPosition = self.newPartyMemberViewPosition + view.frame.size.height;

    [self.partyMembers setObject:view forKey:[NSNumber numberWithInt:self.labelIndex]];
    [self addSubview:view];
    self.addPartyMemberLabel.frame = MRGRectMakeDeltaY(view.frame.size.height, self.addPartyMemberLabel.frame);
}

#pragma mark - Touch Events

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:self];
    if(CGRectContainsPoint(self.addPartyMemberLabel.frame, touchPoint)) {
        [self.delegate addPartyMember:self];
//        [self addPartyMemberWithName:@"ADD"];
    }
}


#pragma mark - Initialise

- (void) setup {
    
    _addPartyMemberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width , [AbeloPartyMemberView defaultViewHeight])];
    _addPartyMemberLabel.text = @"Add Guest";
    _addPartyMemberLabel.textAlignment = UITextAlignmentCenter;
    _addPartyMemberLabel.tag = ADD_PARTY_MEMBER_LABEL_TAG;
    
    self.newPartyMemberViewPosition = 0;
    [self addSubview:_addPartyMemberLabel];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [self setup];
}

@end
