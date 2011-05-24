//
//  MZNHTCell.m
//  Receptor Roulette
//
//  Created by Michael Victor Zink on 5/17/11.
//  Copyright 2011 Trustees of the University of Chicago. All rights reserved.
//

#import "MZNHTCellSprite.h"

static NSString * spriteFilenameFormat = @"MZNH_TC_%@%@.png";
static NSArray * peptideNames = nil;

@implementation MZNHTCellSprite

@synthesize peptide, autoreactive, functional;

+ (MZNHTCellSprite *) randomTCellSprite {
	NSUInteger i = random() % ([[MZNHTCellSprite peptideNames] count]-1);
	NSString * peptideName = [[MZNHTCellSprite peptideNames] objectAtIndex: i];
	BOOL functional = (random() & 1) ? YES : NO;
	MZNHTCellSprite * cell = [MZNHTCellSprite spriteWithFile:
							  [NSString stringWithFormat: spriteFilenameFormat,
							   peptideName, (functional ? @"" : @"_")]];
	cell.peptide = peptideName;
	cell.functional = functional;
	CGSize size = [[CCDirector sharedDirector] winSize];
	cell.position = ccp(0.0, ((float)arc4random()/(2.0*RAND_MAX)) *
						(size.height - cell.contentSize.height * 2)
						+ cell.contentSize.height );
    if (random()%20 < 4) {
        cell.autoreactive = YES;
		cell.functional = NO;
        cell.color = ccc3(255, 120, 0);
    }
	return cell;
}

+ (NSArray *) peptideNames
{
	if (! peptideNames)
		peptideNames = [[NSArray alloc] initWithObjects: @"SB", @"SG", @"SP", @"TB", @"TG", @"TP", nil];
	return peptideNames;
}

@end
