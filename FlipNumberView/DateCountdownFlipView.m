//
//  CountdownFlipView.m
//  OneTwoThree
//
//  Created by Markus Emrich on 12.03.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DateCountdownFlipView.h"


@implementation DateCountdownFlipView

- (id)init
{
    return [self initWithTargetDate: [NSDate date]];
}


- (id)initWithTargetDate: (NSDate*) targetDate
{
    self = [super initWithFrame: CGRectZero];
    if (self)
    {
        mFlipNumberViewDay    = [[GroupedFlipNumberView alloc] initWithFlipNumberViewCount: 3];
        mFlipNumberViewHour   = [[GroupedFlipNumberView alloc] initWithFlipNumberViewCount: 2];
        mFlipNumberViewMinute = [[GroupedFlipNumberView alloc] initWithFlipNumberViewCount: 2];
        mFlipNumberViewSecond = [[GroupedFlipNumberView alloc] initWithFlipNumberViewCount: 2];
        
        mFlipNumberViewDay.delegate    = self;
        mFlipNumberViewHour.delegate   = self;
        mFlipNumberViewMinute.delegate = self;
        mFlipNumberViewSecond.delegate = self;
        
        mFlipNumberViewHour.maximumValue = 23;
        mFlipNumberViewMinute.maximumValue = 59;
        mFlipNumberViewSecond.maximumValue = 59;
        
        [self setZDistance: 60];
        
        CGRect frame = mFlipNumberViewHour.frame;
        CGFloat spacing = floorf(frame.size.width*0.1);
        
        self.frame = CGRectMake(0, 0, frame.size.width*4+spacing*3, frame.size.height);
        
        frame.origin.x += frame.size.width + spacing;
        mFlipNumberViewHour.frame = frame;
        frame.origin.x += frame.size.width + spacing;
        mFlipNumberViewMinute.frame = frame;
        frame.origin.x += frame.size.width + spacing;
        mFlipNumberViewSecond.frame = frame;
        
        [self addSubview: mFlipNumberViewDay];
        [self addSubview: mFlipNumberViewHour];
        [self addSubview: mFlipNumberViewMinute];
        [self addSubview: mFlipNumberViewSecond];
        
        [self setTargetDate: targetDate];
        
        [mFlipNumberViewSecond animateDownWithTimeInterval: 1.0];
    }
    return self;
}

- (void)dealloc
{
    [mFlipNumberViewDay release];
    [mFlipNumberViewHour release];
    [mFlipNumberViewMinute release];
    [mFlipNumberViewSecond release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark DEBUG

- (void) setDebugValues
{
    // DEBUG
    
    mFlipNumberViewHour.maximumValue = 2;
    mFlipNumberViewMinute.maximumValue = 2;
    mFlipNumberViewSecond.maximumValue = 4;
    
    mFlipNumberViewHour.intValue = 2;
    mFlipNumberViewMinute.intValue = 2;
    mFlipNumberViewSecond.intValue = 4;
    
    [mFlipNumberViewSecond animateDownWithTimeInterval: 0.5];
}

#pragma mark -

- (void) setZDistance: (NSUInteger) zDistance
{
    [mFlipNumberViewDay setZDistance: zDistance];
    [mFlipNumberViewHour setZDistance: zDistance];
    [mFlipNumberViewMinute setZDistance: zDistance];
    [mFlipNumberViewSecond setZDistance: zDistance];
}

- (void) setTargetDate: (NSDate*) targetDate
{
    NSUInteger flags = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents* dateComponents = [[NSCalendar currentCalendar] components: flags fromDate: [NSDate date] toDate: targetDate options: 0];
    
    mFlipNumberViewDay.intValue    = [dateComponents day];
    mFlipNumberViewHour.intValue   = [dateComponents hour];
    mFlipNumberViewMinute.intValue = [dateComponents minute];
    mFlipNumberViewSecond.intValue = [dateComponents second];
}

- (void) setFrame: (CGRect) rect
{
    [super setFrame: rect];
    
    CGFloat digitWidth = rect.size.width/10.0;
    CGFloat margin     = digitWidth/3.0;
    CGFloat currentX   = 0;
    
    mFlipNumberViewDay.frame = CGRectMake(currentX, 0, digitWidth*3, rect.size.height);
    currentX   += mFlipNumberViewDay.frame.size.width;
    
    for (GroupedFlipNumberView* view in [NSArray arrayWithObjects: mFlipNumberViewHour, mFlipNumberViewMinute, mFlipNumberViewSecond, nil])
    {
        currentX   += margin;
        view.frame = CGRectMake(currentX, 0, digitWidth*2, rect.size.height);
        currentX   += view.frame.size.width;
    }
}


#pragma mark -
#pragma mark GroupedFlipNumberViewDelegate


- (void) groupedFlipNumberView: (GroupedFlipNumberView*) groupedFlipNumberView willChangeToValue: (NSUInteger) newValue
{
//    LOG(@"ToValue: %d", newValue);
    
    GroupedFlipNumberView* animateView = nil;
    
    if (groupedFlipNumberView == mFlipNumberViewSecond) {
        animateView = mFlipNumberViewMinute;
    }
    else if (groupedFlipNumberView == mFlipNumberViewMinute) {
        animateView = mFlipNumberViewHour;
    }
    else if (groupedFlipNumberView == mFlipNumberViewHour) {
        animateView = mFlipNumberViewDay;
    }
    
    if (animateView != nil)
    {
        if (groupedFlipNumberView.currentDirection == eFlipDirectionDown && newValue == groupedFlipNumberView.maximumValue)
        {
            [animateView animateToPreviousNumber];
        }
        else if (groupedFlipNumberView.currentDirection == eFlipDirectionUp && newValue == 0)
        {
            [animateView animateToNextNumber];
        }
    }
}


- (void) groupedFlipNumberView: (GroupedFlipNumberView*) groupedFlipNumberView didChangeValue: (NSUInteger) newValue animated: (BOOL) animated
{
}

@end
