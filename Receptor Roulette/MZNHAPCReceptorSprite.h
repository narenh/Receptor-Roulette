//
//  MZNHAPCReceptor.h
//  Receptor Roulette
//
//  Created by Michael Victor Zink on 5/17/11.
//  Copyright 2011 Trustees of the University of Chicago. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MZNHAPCReceptorSprite : CCSprite {
    NSString * peptide;
}

@property(nonatomic, retain) NSString * peptide;

+ (MZNHAPCReceptorSprite *) receptorSpriteWithPeptide: (NSString *) peptideName;
+ (NSArray *) peptideNames;

@end
