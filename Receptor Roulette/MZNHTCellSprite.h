//
//  MZNHTCell.h
//  Receptor Roulette
//
//  Created by Michael Victor Zink on 5/17/11.
//  Copyright 2011 Trustees of the University of Chicago. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MZNHTCellSprite : CCSprite {
    NSString * peptide;
    BOOL autoreactive;
	BOOL functional;
}

@property(nonatomic, retain) NSString *peptide;
@property(nonatomic) BOOL autoreactive;
@property(nonatomic) BOOL functional;

+ (MZNHTCellSprite *) randomTCellSprite;
+ (NSArray *) peptideNames;

@end
