//
//  PuzzleGameView.h
//  FBPuzzle
//
//  Created by Sergey Gavrilyuk on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBPuzzleGame.h"


@class FBPuzzleGameViewTile;
@class FBPuzzleGameView;


@protocol FBPuzzleGameViewDelegate <NSObject>

-(FBPuzzleGameViewTile*) gameView:(FBPuzzleGameView*)gameVIew tileForIndexPath:(NSIndexPath*) indexPath;
-(NSUInteger) gameDimensionForGameView:(FBPuzzleGameView*)gameVIew;
-(NSIndexPath*) tileIndexToSkipForGameView:(FBPuzzleGameView*)gameVIew;

-(BOOL) gameView:(FBPuzzleGameView*) gameView 
canMoveTileAtIndexPath:(NSIndexPath*) indexPath 
     inDirection:(EFBPuzzleGameMoveDirection) direction;

-(void) gameView:(FBPuzzleGameView*) gameView 
didMoveTileAtIndexPath:(NSIndexPath*) indexPath  
     inDirection:(EFBPuzzleGameMoveDirection) direction;
@end



@interface FBPuzzleGameView : UIView<UIGestureRecognizerDelegate>
{
    NSMutableArray* _tiles;

    NSUInteger _dimension;
    
    UIView* _shadowsView;
    
    
    
    
}


@property (nonatomic, assign) id<FBPuzzleGameViewDelegate> delegate;

-(void) loadGameView;

@end
