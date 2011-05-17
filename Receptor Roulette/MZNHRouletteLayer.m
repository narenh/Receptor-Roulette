//
//  HelloWorldLayer.m
//  Receptor Roulette
//
//  Created by Naren Hazareesingh on 5/10/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// Import the interfaces
#import "MZNHRouletteLayer.h"

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
		[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
		CGSize size = [[CCDirector sharedDirector] winSize];
        receptor = [CCSprite spriteWithFile:@"Receptor.png"];
        receptor.scale = 8;
        receptor.position = ccp(720, size.height/2);
        [self addChild:receptor];
	}
	return self;
}


// Finds sprite that has been touched
- (void)selectSpriteForTouch:(CGPoint)touchLocation {
    CCSprite * newSprite = nil;
    for (CCSprite *sprite in movableSprites) {
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

-(CGFloat)angleAtPosition:(CGPoint)position {
	if (abs(160 - position.y) < 2) {
		return 0.0;
	} else {
		return 90 * (atanf((600 - position.x) / (160 - position.y)) + M_PI * (abs(position.y-160)/(position.y-160))/2);
	}
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

/*- (void)ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    UITouch* touch = [touches anyObject];
    CGPoint location = [self convertTouchToNodeSpace:touch];
    CGRect spriteRect = planet1.boundingBox;
    if(CGRectContainsPoint(spriteRect, location)) {
        // particularSprite touched
        NSLog(@"touched planet1");
    }
}*/

- (void) update: (ccTime) dt
{
	CGSize size = [[CCDirector sharedDirector] winSize];

	for (CCSprite * cell in movableSprites) {
		cell.position = ccpAdd(cell.position, ccp(dt * 40.0, 0));
		cell.rotation = [self angleAtPosition: cell.position];
		
		if (cell.position.x >= (size.width + cell.contentSize.width)) {
			[movableSprites removeObject: cell];
			[self removeChild: cell cleanup:YES];
		}
	}
}

- (void) spawnTCell: (ccTime) dt
{
	// FIXME: Add increasing probabilities based on total time passed
	if (arc4random() & 1) {
		CCSprite * cell = [CCSprite spriteWithFile: @"T-Cell_Draft1.png"];
		CGSize size = [[CCDirector sharedDirector] winSize];
		cell.position = ccp(0.0, ((float)arc4random()/(2.0*RAND_MAX)) *
							(size.height - cell.contentSize.height * 2)
							+ cell.contentSize.height );
		cell.scale = 0.0;
		CCAction * scaleAction = [CCScaleTo actionWithDuration: 0.2 scale: 1.0 ];
		[cell runAction: scaleAction];
		[movableSprites addObject: cell];
		[self addChild: cell];
	}
}

- (void) onEnter
{
	[super onEnter];
	[self scheduleUpdate];
	[self schedule: @selector(spawnTCell:) interval: 1.0];
}

- (void) onExit
{
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
    [movableSprites release];
    movableSprites = nil;
	[super dealloc];
}
@end
