//
//  MZNHAPCReceptor.m
//  Receptor Roulette
//
//  Created by Michael Victor Zink on 5/17/11.
//  Copyright 2011 Trustees of the University of Chicago. All rights reserved.
//

#import "MZNHAPCReceptorSprite.h"

/** The filename format for receptor images:
 MZNH_APC_[peptide].png
 where [peptide] comes from peptideNames */
static NSString * spriteFilenameFormat = @"MZNH_APC_%@.png";

/** A lazily populated array of valid peptide names */
static NSArray * peptideNames = nil;

@implementation MZNHAPCReceptorSprite

@synthesize peptide;

+ (MZNHAPCReceptorSprite *) receptorSpriteWithPeptide: (NSString *) peptideName
{
	MZNHAPCReceptorSprite * rec = [MZNHAPCReceptorSprite spriteWithFile:
								   [NSString stringWithFormat: spriteFilenameFormat, peptideName]];
	rec.peptide = peptideName;
	return rec;
}

/** Returns the array of valid peptide names. If necessary, populates it first. */
+ (NSArray *) peptideNames
{
	if (! peptideNames) {
		peptideNames = [[NSArray alloc] initWithObjects: @"SB", @"SG", @"SP", @"TB", @"TG", @"TP", nil];
	}
	return peptideNames;
}

@end
