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

@synthesize peptide;

+ (MZNHTCellSprite *) randomTCellSprite
{
	NSUInteger i = random() % ([[MZNHTCellSprite peptideNames] count]-1);
	NSString * peptideName = [[MZNHTCellSprite peptideNames] objectAtIndex: i];
	MZNHTCellSprite * cell = [MZNHTCellSprite spriteWithFile: [NSString stringWithFormat: spriteFilenameFormat, peptideName]];
	cell.peptide = peptideName;
	CGSize size = [[CCDirector sharedDirector] winSize];
	cell.position = ccp(0.0, ((float)arc4random()/(2.0*RAND_MAX)) *
						(size.height - cell.contentSize.height * 2)
						+ cell.contentSize.height );
	return cell;
}

+ (NSArray *) peptideNames
{
	if (! peptideNames)
		peptideNames = [[NSArray alloc] initWithObjects: @"SB", @"TB", @"TG", @"TP", nil];
	return peptideNames;
}

@end
