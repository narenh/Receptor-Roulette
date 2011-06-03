//
//  MZNHTCell.h
//  Receptor Roulette
//
//  Created by Michael Victor Zink on 5/17/11.
//  Copyright 2011 Trustees of the University of Chicago. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

/** A CCSprite with additional information about TCells */
@interface MZNHTCellSprite : CCSprite {
    NSString * peptide;
    BOOL autoreactive;
	BOOL functional;
}

/** The name of the peptide for this cell.
 See +[MZNHTCellSprite peptideNames] for valid peptides. */
@property(nonatomic, retain) NSString *peptide;
/** Autoreactive TCells should not be selected for */
@property(nonatomic) BOOL autoreactive;
/** Nonfunctional TCells do not have a coreceptor and should not be selected for */
@property(nonatomic) BOOL functional;

/** Generates a TCell with random peptide, autoreactivity, and functionality,
 placing it randomly along the left side of the screen. */
+ (MZNHTCellSprite *) randomTCellSprite;

/** The list of valid peptide names. Each one should have a corresponding image
 in the Resources/T-Cells and Resources/HD groups. */
+ (NSArray *) peptideNames;

@end
