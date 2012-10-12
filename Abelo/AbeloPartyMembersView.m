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
@property (nonatomic) NSMutableArray *partyMembers;
@property (nonatomic) UILabel *touchView;

@end

#define ADD_PARTY_MEMBER_LABEL_TAG 314

@implementation AbeloPartyMembersView

@synthesize partyMembers = _partyMembers;
@synthesize newPartyMemberViewPosition = _newPartyMemberViewPosition;
@synthesize touchView = _touchView;

- (NSMutableArray *)partyMembers {
    if(!_partyMembers){
        _partyMembers = [NSMutableArray array];
    }
    return _partyMembers;
}

#pragma mark - Method implementations

- (id) addPartyMemberWithName:(NSString *)name andColor:(UIColor *) color{
    
    AbeloPartyMemberView *view = [[AbeloPartyMemberView alloc] init];
    view.frame = MRGRectMakeSetXY(0, self.newPartyMemberViewPosition, view.frame);
    view.frame = MRGRectMakeSetWidth(self.frame.size.width, view.frame);
    view.name = name;
    view.total = 0;
    
    [view setColor:color];

    self.newPartyMemberViewPosition = self.newPartyMemberViewPosition + view.frame.size.height;
    
    self.touchView.frame = MRGRectMakeSetY(self.newPartyMemberViewPosition, self.touchView.frame);

    [self.partyMembers addObject:view];
    [self addSubview:view];
    
    return view;
}

#pragma mark - AbeloTouchableViewsProtocol

- (NSArray *)uiViewsAtPoint:(CGPoint)point {
    NSMutableArray *array = [NSMutableArray array];
    
    int i = 0;
    while(i < [self.partyMembers count]){
        if(CGRectContainsPoint(((UILabel *)[self.partyMembers objectAtIndex:i]).frame, point)){
            [array addObject:[self.partyMembers objectAtIndex:i]];
        }
        i++;
    }
    
    return array;
}

- (id)anyUIViewAtPoint:(CGPoint)point {
    
    if(CGRectContainsPoint(self.touchView.frame, point)){
        return self.touchView;
    }

    int i = 0;
    while(i < [self.partyMembers count]){
        if(CGRectContainsPoint(((UILabel *)[self.partyMembers objectAtIndex:i]).frame, point)){
            return [self.partyMembers objectAtIndex:i];
        }
        i++;
    }
    
    return nil;
}

#pragma mark - Initialise

- (void) setup {
    _touchView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, [AbeloPartyMemberView defaultViewHeight])];
    _touchView.textAlignment = UITextAlignmentCenter;
    _touchView.text = @"Drag/Tap here to add party members";
    _touchView.lineBreakMode = NSLineBreakByWordWrapping;
    _touchView.numberOfLines = 2;
    _touchView.font = [_touchView.font fontWithSize:14];
    _touchView.backgroundColor = [UIColor lightGrayColor];

    [self.partyMembers addObject:_touchView];
    [self addSubview:_touchView];
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
