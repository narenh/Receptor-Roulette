//
//  MZNHTCell.m
//  Receptor Roulette
//
//  Created by Michael Victor Zink on 5/17/11.
//  Copyright 2011 Trustees of the University of Chicago. All rights reserved.
//

#import "MZNHTCellSprite.h"

static NSArray * spriteImages = nil;

@implementation MZNHTCellSprite

@synthesize peptide;

+ (MZNHTCellSprite *) randomTCellSprite
{
	NSUInteger i = random() % ([spriteImages count]-1);
	MZNHTCellSprite * cell = [MZNHTCellSprite spriteWithFile: [spriteImages objectAtIndex:i]];
	cell.peptide = i;
	CGSize size = [[CCDirector sharedDirector] winSize];
	cell.position = ccp(0.0, ((float)arc4random()/(2.0*RAND_MAX)) *
						(size.height - cell.contentSize.height * 2)
						+ cell.contentSize.height );
	return cell;
}

+ (void) initialize
{
	if (! spriteImages) {
		spriteImages = [[NSArray alloc] initWithObjects:@"TC_SB.png", @"TC_SB_.png",
						@"TC_SB.png", @"TC_SB_.png",
						@"TC_SB.png", @"TC_SB_.png",
						@"TC_TB.png", @"TC_TB_.png",
						@"TC_TG.png", @"TC_TG_.png",
						@"TC_TP.png", @"TC_TP_.png", nil];
	}
}

@end
