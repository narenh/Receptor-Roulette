//
//  MZNHAPCReceptor.m
//  Receptor Roulette
//
//  Created by Michael Victor Zink on 5/17/11.
//  Copyright 2011 Trustees of the University of Chicago. All rights reserved.
//

#import "MZNHAPCReceptorSprite.h"

static NSString * spriteFilenameFormat = @"MZNH_APC_%@.png";
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

+ (NSArray *) peptideNames
{
	if (! peptideNames) {
		peptideNames = [[NSArray alloc] initWithObjects: @"SB", @"SG", @"SP", @"TB", @"TG", @"TP", nil];
	}
	return peptideNames;
}

@end
