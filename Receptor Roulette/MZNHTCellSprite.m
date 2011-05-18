//
//  MZNHTCell.m
//  Receptor Roulette
//
//  Created by Michael Victor Zink on 5/17/11.
//  Copyright 2011 Trustees of the University of Chicago. All rights reserved.
//

#import "MZNHTCellSprite.h"

static NSString * spriteFilenameFormat = @"TC_%@.png";
static NSArray * peptideNames = nil;

@implementation MZNHTCellSprite

@synthesize peptide, bad;

+ (MZNHTCellSprite *) randomTCellSprite {
	NSUInteger i = random() % ([[MZNHTCellSprite peptideNames] count]-1);
	NSString * peptideName = [[MZNHTCellSprite peptideNames] objectAtIndex: i];
	MZNHTCellSprite * cell = [MZNHTCellSprite spriteWithFile: [NSString stringWithFormat: spriteFilenameFormat, peptideName]];
	cell.peptide = peptideName;
	CGSize size = [[CCDirector sharedDirector] winSize];
	cell.position = ccp(0.0, ((float)arc4random()/(2.0*RAND_MAX)) *
						(size.height - cell.contentSize.height * 2)
						+ cell.contentSize.height );
    if (random()%20 < 4) {
        cell.bad = YES;
        cell.color = ccc3(255, 120, 0);
    } 
	return cell;
}

+ (NSArray *) peptideNames
{
	if (! peptideNames)
		peptideNames = [[NSArray alloc] initWithObjects: @"SB", @"SG", @"SP", @"TB", @"TG", @"TP", @"SB_", @"SG_", @"SP_", @"TB_", @"TG_", @"TP_", nil];
	return peptideNames;
}

@end
