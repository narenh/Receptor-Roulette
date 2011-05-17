//
//  HelloWorldLayer.h
//  Receptor Roulette
//
//  Created by Naren Hazareesingh on 5/10/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface MZNHRouletteLayer : CCLayerColor
{
    CCSprite *receptor;
    CCSprite * selSprite;
    NSMutableArray * tcellSprites;
    NSMutableArray * receptorSprites;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
-(CGFloat)angleAtPosition:(CGPoint)position;

@end
