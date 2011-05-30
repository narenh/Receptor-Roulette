//
//  HelloWorldLayer.m
//  Receptor Roulette
//
//  Created by Naren Hazareesingh on 5/10/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// Import the interfaces
#import "MZNHRouletteLayer.h"


#define TCELL_SCALE 0.7
#define APC_SCALE 0.50

// HelloWorldLayer implementation
@implementation MZNHRouletteLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MZNHRouletteLayer *layer = [MZNHRouletteLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
    // ccc4(120, 225, 255, 255) old cyan color
	if( (self=[super initWithColor:ccc4(120, 225, 255, 255)])) {
        tcellSprites = [[NSMutableArray alloc] init];
        receptorSprites = [[NSMutableArray alloc] init];
        score = 0;
        
		[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
		CGSize size = [[CCDirector sharedDirector] winSize];
        scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"SCORE: %d",score] fontName:@"Futura-Medium" fontSize:20];
        scoreLabel.position = ccp(60, 300);
        [self addChild:scoreLabel];
        
        apc = [CCSprite spriteWithFile:@"MZNH_APC.png"];
        //apc.color = ccc3(150, 50, 255);
        //apc.color = ccc3(150, 0, 200); purple
        apc.color = ccc3(255,0,0);
        apc.scale = APC_SCALE;
        apc.position = ccp(660, size.height/2);
        apcRadius = apc.boundingBox.size.width/2;
        
        [self addChild:apc];
        
		NSArray * peptides = [[[NSArray arrayWithArray:[MZNHAPCReceptorSprite peptideNames]]
							  arrayByAddingObjectsFromArray: [MZNHAPCReceptorSprite peptideNames]]
                              arrayByAddingObjectsFromArray:[MZNHAPCReceptorSprite peptideNames]];
        for(int i = 0; i < [peptides count]; ++i) {
			MZNHAPCReceptorSprite *sprite = [MZNHAPCReceptorSprite receptorSpriteWithPeptide:[peptides objectAtIndex:i]];

            float angle = i* M_PI * 2 / [peptides count];
            float radius = apc.contentSize.width/2;
            sprite.scale = TCELL_SCALE/APC_SCALE;

            [apc addChild:sprite];
            sprite.position = ccp(radius + radius*cos(angle),radius + radius*sin(angle));
            sprite.rotation = 180 + -180 * angle / M_PI;
            [receptorSprites addObject:sprite];
        }

		// Add audio sound
		CFBundleRef bundle = CFBundleGetMainBundle();
		CFURLRef res = CFBundleCopyResourceURL(bundle, CFSTR("Pop1"), CFSTR("wav"), NULL);
		AudioServicesCreateSystemSoundID(res, &popSoundID);
	}
	return self;
}


// Finds sprite that has been touched
- (void)selectSpriteForTouch:(CGPoint)touchLocation {
    MZNHTCellSprite *newSprite = nil;
    for (MZNHTCellSprite *sprite in tcellSprites) {
        if (CGRectContainsPoint(sprite.boundingBox, touchLocation)) {            
            newSprite = sprite;
            break;
        }
    }    
    if (newSprite != selSprite) {            
        selSprite = newSprite;
    }
}

- (void)removeCell:(MZNHTCellSprite *)cell dirty:(BOOL)dirty {
    if (dirty) cell.color = ccc3(200, 0, 0);
    else cell.color = ccc3(0, 200, 0);
    CCAction *scaleAction = [CCSequence actions:[CCScaleTo actionWithDuration:0.2 scale:.9],
                             [CCScaleTo actionWithDuration:0.4 scale:0], nil];
    [cell runAction:scaleAction];

    [tcellSprites removeObject:cell];
    if (dirty) score--;
    else AudioServicesPlaySystemSound(popSoundID);
}

//On touchDownInside, 'selects' sprite
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event { 
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    [self selectSpriteForTouch:touchLocation];      
    return TRUE;    
}
//Handles double tap
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    if (touch.tapCount == 2) {
        [self selectSpriteForTouch:touchLocation];
		BOOL dirty;
		if (selSprite.autoreactive) {
			dirty = NO;
		} else {
			dirty = selSprite.functional;
		}
        [self removeCell:selSprite dirty:dirty];
    }
	selSprite = nil;
}

//Returns the angle a sprite should be facing at a point
- (CGFloat)angleAtPosition:(CGPoint)position {
    return -35*cos(position.y*M_PI/320)+350*pow(M_E, position.x*-.014);
}

// handles movement
- (void)panForTranslation:(CGPoint)translation {    
    if (selSprite) {
        CGPoint newPos = ccpAdd(selSprite.position, translation);
        selSprite.position = newPos;
        selSprite.rotation = [self angleAtPosition:newPos];
    }  
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {       
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    
    CGPoint translation = ccpSub(touchLocation, oldTouchLocation);    
    [self panForTranslation:translation];  
}

- (BOOL)tCellCollidesWithReceptor:(MZNHTCellSprite *)cell {
    for (MZNHAPCReceptorSprite *rec in receptorSprites) {
        float dist = ccpDistance([rec.parent convertToWorldSpace:rec.position], cell.position);
        float collision = rec.contentSize.width/2 + cell.contentSize.height/2;
		if (dist < collision - 20) {
			if (selSprite == cell) selSprite = nil;
            if (cell.functional && [cell.peptide isEqualToString:rec.peptide]) {
                [tcellSprites removeObject:cell];
                MZNHTCellSprite *newSprite = [MZNHTCellSprite spriteWithTexture:[cell texture]];
                newSprite.position = CGPointMake(-30, rec.contentSize.height/2);
                [self removeChild:cell cleanup:YES];
                [rec addChild:newSprite];
                score += 2;
                break;
            }
            else {
                [self removeCell:cell dirty:YES];
            }
			return YES;
		}
    }
    return NO;
}

- (BOOL)tCellCollidesWithAPC:(MZNHTCellSprite *)cell {
    if (ccpDistance(cell.position, apc.position) < apcRadius+20) {
        [self removeCell:cell dirty:YES];
        return YES;
    }
    return NO;
}

- (void)update:(ccTime)dt {
    //NSLog(@"%d",random());
	CGSize size = [[CCDirector sharedDirector] winSize];
    apc.rotation -= .3;
    [scoreLabel setString:[NSString stringWithFormat:@"SCORE: %d",score]];
    
	for (MZNHTCellSprite *cell in tcellSprites) {
		// T-Cell Motion
		if (cell != selSprite) {
			cell.position = ccpAdd(cell.position, ccp(dt * 40.0, 0));
		}
        cell.rotation = [self angleAtPosition: cell.position];
        if (cell.position.x >= (size.width + cell.contentSize.width)) {
            [tcellSprites removeObject: cell];
            [self removeChild: cell cleanup:YES];
            break;
        }
        
        //T-Cell Intersection
        if ([self tCellCollidesWithAPC:cell]) break;
        if([self tCellCollidesWithReceptor:cell]) break;
	}
    for (MZNHAPCReceptorSprite *rec in receptorSprites) {
        CGPoint recPos = [rec.parent convertToWorldSpace:rec.position];
        if (rec.children != NULL && recPos.x > 500 ) [rec removeAllChildrenWithCleanup:YES];
                                               
    }
}

- (void) spawnTCell: (ccTime) dt {
	// FIXME: Add increasing probabilities based on total time passed
	if (random() & 1) {
		MZNHTCellSprite * cell = [MZNHTCellSprite randomTCellSprite];
		cell.scale = 0.0;
		CCAction * scaleAction = [CCScaleTo actionWithDuration: 0.2 scale:TCELL_SCALE ];
		[cell runAction: scaleAction];
		[tcellSprites addObject: cell];
		
		[self addChild: cell];
	}
}

- (void)onEnter {
	[super onEnter];
	[self scheduleUpdate];
	[self schedule: @selector(spawnTCell:) interval: 1.2];
}

- (void)onExit {
	[self unscheduleUpdate];
	[self unschedule: @selector(spawnTCell:)];
	[super onExit];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    [tcellSprites release];
    tcellSprites = nil;
	[super dealloc];
}
@end
