//
//  CCSprite+getBounds.m
//  Receptor Roulette
//
//  Created by Michael Victor Zink on 5/17/11.
//  Copyright 2011 Trustees of the University of Chicago. All rights reserved.
//

#import "CCSprite+getBounds.h"


@implementation CCSprite (CCSprite_getBounds)

- (CGRect) bounds {
	CGSize s = [self contentSize];
	s.width *= scaleX_;
	s.height *= scaleY_;
	return CGRectMake(position_.x - s.width * anchorPoint_.x,
					  position_.y - s.height * anchorPoint_.y,
					  s.width,
					  s.height);
}

@end
