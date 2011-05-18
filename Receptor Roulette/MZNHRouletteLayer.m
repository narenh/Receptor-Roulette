//
//  HelloWorldLayer.m
//  Receptor Roulette
//
//  Created by Naren Hazareesingh on 5/10/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// Import the interfaces
#import "MZNHRouletteLayer.h"
#import "MZNHTCellSprite.h"
#import "MZNHAPCReceptorSprite.h"

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
        
		[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
		CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCLabelTTF *score = [CCLabelTTF labelWithString:@"Score: 143" fontName:@"Helvetica" fontSize:15];
        score.position = ccp(50, 300);
        [self addChild:score];
        
        apc = [CCSprite spriteWithFile:@"APC.png"];
        apc.color = ccc3(255, 100, 100);
        apc.scale = APC_SCALE;
        apc.position = ccp(590, size.height/2);
        [self addChild:apc];
        
       /* NSArray *images = [NSArray arrayWithObjects:@"APC_SP.png",
                           @"APC_TG.png",
                           @"APC_TP.png",
                           @"APC_TB.png",
                           @"APC_SP.png",
                           @"APC_SG.png",
                           @"APC_TP.png",
                           @"APC_TB.png",
                           @"APC_SP.png",
                           @"APC_SB.png",
                           @"APC_TP.png",
                           @"APC_SB.png", nil];       
        for(int i = 0; i < [images count]; ++i) {
            NSString *image = [images objectAtIndex:i];
            CCSprite *sprite = [CCSprite spriteWithFile:image];
            
            float angle = i* M_PI * 2 / [images count];
            float radius = apc.contentSize.width/2 + 20;
            sprite.scale = TCELL_SCALE/APC_SCALE;*/

		NSArray * peptides = [[[NSArray arrayWithArray:[MZNHAPCReceptorSprite peptideNames]]
							  arrayByAddingObjectsFromArray: [MZNHAPCReceptorSprite peptideNames]]
                              arrayByAddingObjectsFromArray:[MZNHAPCReceptorSprite peptideNames]];
        for(int i = 0; i < [peptides count]; ++i) {
			MZNHAPCReceptorSprite * sprite = [MZNHAPCReceptorSprite receptorSpriteWithPeptide: [peptides objectAtIndex: i]];

            float angle = i* M_PI * 2 / [peptides count];
            float radius = apc.contentSize.width/2;
            sprite.scale = 2;

            [apc addChild:sprite];
            sprite.position = ccp(radius + radius*cos(angle),radius + radius*sin(angle));//ccp(50*cos(angle), 50*sin(angle));
            sprite.rotation = 180 + -180 * angle / M_PI;
            [receptorSprites addObject:sprite];
        }
        /*images = [NSArray arrayWithObjects:@"Tc_TG.png",
                           @"Tc_TG.png",
                           @"Tc_TG.png",
                           @"Tc_TG.png",
                           @"Tc_TG.png",
                           @"Tc_TG.png", nil];       
        for(int i = 0; i < images.count; ++i) {
            NSString *image = [images objectAtIndex:i];
            CCSprite *sprite = [CCSprite spriteWithFile:image];
            float offsetFraction = ((float)(i+1))/(images.count+1);
            sprite.position = ccp(size.width*offsetFraction, random()%310);
            sprite.scale = .7;
            sprite.rotation = [self angleAtPosition:sprite.position];
            [self addChild:sprite];
            [tcellSprites addObject:sprite];
        }*/
	}
	return self;
}


// Finds sprite that has been touched
- (void)selectSpriteForTouch:(CGPoint)touchLocation {
    CCSprite * newSprite = nil;
    for (CCSprite *sprite in tcellSprites) {
        if (CGRectContainsPoint(sprite.boundingBox, touchLocation)) {            
            newSprite = sprite;
            break;
        }
    }    
    if (newSprite != selSprite) {            
        selSprite = newSprite;
    }
}

//On touchDownInside, 'selects' sprite
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event { 
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    [self selectSpriteForTouch:touchLocation];      
    return TRUE;    
}
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    if (touch.tapCount == 2) {
        [self selectSpriteForTouch:touchLocation];
        selSprite.color = ccc3(200, 0, 0);
        CCAction *scaleAction = [CCScaleTo actionWithDuration: 0.4 scale:0 ];
		[selSprite runAction:scaleAction];
        [tcellSprites removeObject:selSprite];
    }
	selSprite = nil;
}

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

- (void)update:(ccTime)dt {
	CGSize size = [[CCDirector sharedDirector] winSize];
    apc.rotation -= .3;
	for (MZNHTCellSprite *cell in tcellSprites) {
		if(selSprite != cell) {
            cell.position = ccpAdd(cell.position, ccp(dt * 40.0, 0));
            cell.rotation = [self angleAtPosition: cell.position];
        }
		
		else if (cell.position.x >= (size.width + cell.contentSize.width)) {
			[tcellSprites removeObject: cell];
			[self removeChild: cell cleanup:YES];
		}
        else {
			for (MZNHAPCReceptorSprite * rec in receptorSprites) {
				if (![rec.peptide isEqualToString: cell.peptide]) continue;
				CGRect recBox = rec.boundingBox;
				recBox.origin = [rec.parent convertToWorldSpace:rec.position];
				if (CGRectIntersectsRect(cell.boundingBox, recBox)) {
					if (selSprite == cell) selSprite = nil;
					// Dangerous: we are looping through the same array
					cell.color = ccc3(0, 200, 0);
                    CCAction *scaleAction = [CCScaleTo actionWithDuration: 0.4 scale:0 ];
                    [cell runAction:scaleAction];
                    [tcellSprites removeObject:cell];
					//[self removeChild:cell cleanup: YES];
					break;
				}
			}
		}
	}
}

/*- (void)spawnTCell:(ccTime)dt {
    NSArray *images = [NSArray arrayWithObjects:@"TC_SB.png", @"TC_SB_.png",
                       @"TC_SB.png", @"TC_SB_.png",
                       @"TC_SB.png", @"TC_SB_.png",
                       @"TC_TB.png", @"TC_TB_.png",
                       @"TC_TG.png", @"TC_TG_.png",
                       @"TC_TP.png", @"TC_TP_.png", nil];
    float i = random() % ([images count]-1);
	// FIXME: Add increasing probabilities based on total time passed
	if (random() & 1) {
		CCSprite * cell = [CCSprite spriteWithFile: [images objectAtIndex:i]];
		CGSize size = [[CCDirector sharedDirector] winSize];
		cell.position = ccp(0.0, ((float)random()/(2.0*RAND_MAX)) *
							(size.height - cell.contentSize.height * 2)
							+ cell.contentSize.height );*/
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
