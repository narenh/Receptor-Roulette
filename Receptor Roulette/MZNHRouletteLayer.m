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
#define APC_SCALE 0.4

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
	if( (self=[super initWithColor:ccc4(120, 225, 255, 255)])) {
        tcellSprites = [[NSMutableArray alloc] init];
        receptorSprites = [[NSMutableArray alloc] init];
        score = 0;
        
		[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
		CGSize size = [[CCDirector sharedDirector] winSize];
        NSLog(@"WinSize: %@",NSStringFromCGSize(size));
        scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"SCORE: %d",score] fontName:@"Futura-Medium" fontSize:20];
        scoreLabel.position = ccp(60, 300);
        [self addChild:scoreLabel];
        
        apc = [CCSprite spriteWithFile:@"APC.png"];
        apc.color = ccc3(150, 50, 255);
        apc.scale = APC_SCALE;
        apc.position = ccp(590, size.height/2);
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
    CCAction *scaleAction = [CCScaleTo actionWithDuration: 0.4 scale:0 ];
    [cell runAction:scaleAction];
    [tcellSprites removeObject:cell];
    if (dirty) score--;
    else score++;
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
        [self removeCell:selSprite dirty:!selSprite.bad];
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
- (BOOL)handleMatch:(MZNHTCellSprite *)cell {
    for (MZNHAPCReceptorSprite *rec in receptorSprites) {
        if ([rec.peptide isEqualToString:[cell.peptide substringToIndex:2]]) {
            CGRect recBox = rec.boundingBox;
            recBox.origin = [rec.parent convertToWorldSpace:rec.position];
            if (CGRectIntersectsRect(cell.boundingBox, recBox)) {
                if (selSprite == cell) selSprite = nil;
                [self removeCell:cell dirty:NO];
                return YES;
            }
        }
    }
    return NO;
}

- (void)update:(ccTime)dt {
	CGSize size = [[CCDirector sharedDirector] winSize];
    CGRect apcBounds = apc.boundingBox;
    
    apc.rotation -= .3;
    [scoreLabel setString:[NSString stringWithFormat:@"SCORE: %d",score]];
    
	for (MZNHTCellSprite *cell in tcellSprites) {
        // T-Cell Motion
        cell.position = ccpAdd(cell.position, ccp(dt * 40.0, 0));
        cell.rotation = [self angleAtPosition: cell.position];
        if (cell.position.x >= (size.width + cell.contentSize.width)) {
            [tcellSprites removeObject: cell];
            [self removeChild: cell cleanup:YES];
            break;
        }
        //T-Cell Intersection
        if (CGRectIntersectsRect(cell.boundingBox, apcBounds) && cell.bad) {
            [self removeCell:cell dirty:YES];
            break;
        }
        if([self handleMatch:cell]) break;
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
	[self schedule: @selector(spawnTCell:) interval: 1.0];
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
