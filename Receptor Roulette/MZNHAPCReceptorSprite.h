//
//  MZNHAPCReceptor.h
//  Receptor Roulette
//
//  Created by Michael Victor Zink on 5/17/11.
//  Copyright 2011 Trustees of the University of Chicago. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

/** A CCSprite with convenience methods and additional
 info specific to APC receptor sprites */
@interface MZNHAPCReceptorSprite : CCSprite {
    NSString * peptide;
}

/** The name of the peptide for this receptor.
 See +[MZNHAPCReceptorSprite peptideNames] for valid peptides.*/
@property(nonatomic, retain) NSString * peptide;

/** Produces a sprite with the appropriate image for the given peptide. */
+ (MZNHAPCReceptorSprite *) receptorSpriteWithPeptide: (NSString *) peptideName;

/** The list of valid peptide names. Each one should have a corresponding image
 in the Resources/Receptors and Resources/HD groups. */
+ (NSArray *) peptideNames;

@end
