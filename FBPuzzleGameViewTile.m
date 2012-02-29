//
//  FBPuzzleGameViewTile.m
//  FBPuzzle
//
//  Created by Sergey Gavrilyuk on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FBPuzzleGameViewTile.h"
#import <QuartzCore/QuartzCore.h>

@implementation FBPuzzleGameViewTile
@synthesize currentPosition;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1.0;
    }
    return self;
}

-(void)dealloc
{
    self.currentPosition = nil;
    [super dealloc];
}


-(void) setFrame:(CGRect)frame
{
    [super setFrame:frame];

}
@end
