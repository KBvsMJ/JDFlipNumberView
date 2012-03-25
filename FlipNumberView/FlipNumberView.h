//
//  FlipNumberView.h
//  OneTwoThree
//
//  Created by Markus Emrich on 26.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef enum
{
	eFlipStateFirstHalf,
	eFlipStateSecondHalf
} eFlipState;

typedef enum
{
	eFlipDirectionUp,
	eFlipDirectionDown
} eFlipDirection;

@protocol FlipNumberViewDelegate;

#pragma mark -

@interface FlipNumberView : UIView
{
	id<FlipNumberViewDelegate> delegate;
	
	NSTimer* mTimer;
	
	NSArray* mTopImages;
	NSArray* mBottomImages;
	
	UIImageView* mImageViewTop;
	UIImageView* mImageViewBottom;
	UIImageView* mImageViewFlip;
	
    NSUInteger mMaxValue;
	NSUInteger mCurrentValue;
	eFlipState mCurrentState;
	eFlipDirection mCurrentDirection;
	CGFloat mCurrentAnimationDuration;
}

@property (nonatomic, assign) id<FlipNumberViewDelegate> delegate;
@property (nonatomic, readonly) eFlipDirection currentDirection;
@property (nonatomic, readonly) CGFloat currentAnimationDuration;
@property (nonatomic, assign) NSUInteger intValue;
@property (nonatomic, assign) NSUInteger maxValue;

- (id) initWithIntValue: (NSUInteger) startNumber;

- (void) setZDistance: (NSUInteger) zDistance;

- (NSUInteger) nextValue;
- (NSUInteger) previousValue;

// basic animation
- (void) animateToNextNumber;
- (void) animateToNextNumberWithDuration: (CGFloat) duration;
- (void) animateToPreviousNumber;
- (void) animateToPreviousNumberWithDuration: (CGFloat) duration;

// timed animation
- (void) animateUpWithTimeInterval: (NSTimeInterval) timeInterval;
- (void) animateDownWithTimeInterval: (NSTimeInterval) timeInterval;

// cancel all animations
- (void) stopAnimation;

@end


#pragma mark -
#pragma mark delegate


@protocol FlipNumberViewDelegate <NSObject>
@optional
- (void) flipNumberView: (FlipNumberView*) flipNumberView willChangeToValue: (NSUInteger) newValue;
- (void) flipNumberView: (FlipNumberView*) flipNumberView didChangeValue: (NSUInteger) newValue animated: (BOOL) animated;
@end;