//
//  FBPuzzleGame.h
//  FBPuzzle
//
//  Created by Sergey Gavrilyuk on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    EFBPuzzleGameMoveDirectionLeft,
    EFBPuzzleGameMoveDirectionRight,
    EFBPuzzleGameMoveDirectionUp,
    EFBPuzzleGameMoveDirectionDown
} EFBPuzzleGameMoveDirection;

@interface NSIndexPath(FBPuzzleGame) 
+(id) indexPathForColumn:(NSUInteger) column forRow:(NSUInteger)row;

@property (nonatomic, readonly) NSUInteger row;
@property (nonatomic, readonly) NSUInteger column;

@end

@interface FBPuzzleGame : NSObject
{
    NSUInteger _dimension;
    
    NSMutableArray* _tiles;
    NSIndexPath* _skippedIndexPath;
    
    NSMutableSet* _wrongTiles;
}

-(void) initializeGameWithDimension:(NSUInteger) dimension 
         withSkippedTileAtIndexPath:(NSIndexPath*)indexPath;

-(BOOL) canMoveTileAtIndexPath:(NSIndexPath*) indexPath 
                   inDirection:(EFBPuzzleGameMoveDirection) direction;

-(void) moveTileAtIndexPath:(NSIndexPath*)indexPath 
                inDirection:(EFBPuzzleGameMoveDirection) direction;

-(NSIndexPath*) realIndexOfTileAtIndexPath:(NSIndexPath*)indexPath;

@property (nonatomic, readonly) NSIndexPath* skippedTileIndexPath;
@property (nonatomic, readonly) NSUInteger dimension;

@end
