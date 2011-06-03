//
//  MZNHTCell.m
//  Receptor Roulette
//
//  Created by Michael Victor Zink on 5/17/11.
//  Copyright 2011 Trustees of the University of Chicago. All rights reserved.
//

#import "MZNHTCellSprite.h"

#define ARC4RANDOM_MAX 0x100000000


/** The format of image files for each peptide:
 MZNH_Tc_[peptide][functional_flag].png
 [functional_flag] should be an underscore character (_) if
 the TCell is not functional */
static NSString * spriteFilenameFormat = @"MZNH_Tc_%@%@.png";

/** The peptideNames array is lazily populated in +peptideNames below */
static NSArray * peptideNames = nil;

@implementation MZNHTCellSprite

@synthesize peptide, autoreactive, functional;

+ (MZNHTCellSprite *) randomTCellSprite {
	// Pick a random peptide name
	NSUInteger i = random() % ([[MZNHTCellSprite peptideNames] count]-1);
	NSString * peptideName = [[MZNHTCellSprite peptideNames] objectAtIndex: i];

	// There is an arbitrary 7-in-20 (35%) chance a TCell is nonfunctional
	BOOL functional = (random() % 20 > 7 ) ? YES : NO;

	// The sprite is initalized with the appropriate imagename.
	// cocos2d will handle caching sprites.
	MZNHTCellSprite * cell = [MZNHTCellSprite spriteWithFile:
							  [NSString stringWithFormat: spriteFilenameFormat,
							   peptideName, (functional ? @"" : @"_")]];
	cell.peptide = peptideName;
	cell.functional = functional;

	// Place the sprite randomly along the left edge of the screen
	CGSize size = [[CCDirector sharedDirector] winSize];
	cell.position = ccp(0.0, ((float)arc4random()/ARC4RANDOM_MAX) *
						(size.height - cell.contentSize.height * 2)
						+ cell.contentSize.height );

    // There is an arbitrary 4-in-20 (20%) chance that a TCell is autoreactive
	// and therefore nonfunctional. We discolor it.
	if (random()%20 < 4) {
        cell.autoreactive = YES;
		cell.functional = NO;
        cell.color = ccc3(255, 120, 0);
    }

	return cell;
}

+ (NSArray *) peptideNames
{
	// Only instantiate the array if it doesn't exist yet
	if (! peptideNames)
		peptideNames = [[NSArray alloc] initWithObjects: @"SB", @"SG", @"SP", @"TB", @"TG", @"TP", nil];
	return peptideNames;
}

@end
