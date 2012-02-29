//
//  FBPuzzleGame.m
//  FBPuzzle
//
//  Created by Sergey Gavrilyuk on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FBPuzzleGame.h"


@implementation NSIndexPath(FBPuzzleGame) 
+(id) indexPathForColumn:(NSUInteger) column forRow:(NSUInteger)row
{
    NSUInteger indexes[2] = {row, column};
    return [NSIndexPath indexPathWithIndexes:indexes length:2];
}


-(NSUInteger)row
{
    return [self indexAtPosition:1];
}

-(NSUInteger)column
{
    return [self indexAtPosition:0];
}

@end


@implementation FBPuzzleGame
@synthesize skippedTileIndexPath = _skippedIndexPath;

-(id)init
{
    self = [super init];
    if(self)
    {
    }
    return self;
}

-(void)dealloc
{
    [_tiles release];
    [super dealloc];
}

-(void)initializeGameWithDimension:(NSUInteger)dimension
        withSkippedTileAtIndexPath:(NSIndexPath*)indexPath
{
    [_skippedIndexPath release];
    _skippedIndexPath = [indexPath retain];
    
    _dimension = dimension;
    [_tiles release];
    _tiles = [[NSMutableArray alloc] initWithCapacity:dimension*dimension];
    for(NSUInteger row = 0; row < dimension; ++row)
    {
        for(NSUInteger column = 0; column < dimension; ++column)
        {
            NSIndexPath* indexPath = [NSIndexPath indexPathForColumn:column forRow:row];
            if([indexPath isEqual:_skippedIndexPath])
                [_tiles addObject:[NSNull null]];
            else
                [_tiles addObject:indexPath];
        }
    }
}

-(BOOL)canMoveTileAtIndexPath:(NSIndexPath *)indexPath 
                  inDirection:(EFBPuzzleGameMoveDirection)direction
{
    if(_skippedIndexPath.row !=indexPath.row && _skippedIndexPath.column != _skippedIndexPath.column)
        return NO;
    if(_skippedIndexPath.column == indexPath.column)
    {
        if((_skippedIndexPath.row > indexPath.row && direction == EFBPuzzleGameMoveDirectionDown) ||
           (_skippedIndexPath.row < indexPath.row && direction == EFBPuzzleGameMoveDirectionUp))
            return YES;
    }
    else if(_skippedIndexPath.row == indexPath.row)
    {
        if((_skippedIndexPath.column > indexPath.column && direction == EFBPuzzleGameMoveDirectionRight) ||
           (_skippedIndexPath.column < indexPath.column && direction == EFBPuzzleGameMoveDirectionLeft))
            return YES;
    }
    
    return NO;
}

-(void)moveTileAtIndexPath:(NSIndexPath *)indexPath
               inDirection:(EFBPuzzleGameMoveDirection)direction
{
    if(![self canMoveTileAtIndexPath:indexPath inDirection:direction])
         return;
    
    if(_skippedIndexPath.column == indexPath.column)
    {
        NSUInteger index = indexPath.column+indexPath.row*_dimension;
        NSInteger step = (direction == EFBPuzzleGameMoveDirectionUp)?-1:1;
        
        NSMutableArray* tempStack = [[NSMutableArray alloc] init];
        [tempStack addObject:[NSNull null]];
        
        NSIndexPath* tile = [_tiles objectAtIndex:index];
        while(![tile isEqual:[NSNull null]])
        {
            [tempStack addObject:tile];
            index += step*_dimension;
            tile = [_tiles objectAtIndex:index];
        }
        while([tempStack count])
        {
            [_tiles replaceObjectAtIndex:index withObject:[tempStack lastObject]];
            [tempStack removeLastObject];
            index -= step*_dimension;
        }
        [tempStack release];
        
    }
    else if(_skippedIndexPath.row == indexPath.row)
    {
        NSUInteger index = indexPath.column+indexPath.row*_dimension;
        NSInteger step = (direction == EFBPuzzleGameMoveDirectionLeft)?-1:1;
        
        NSMutableArray* tempStack = [[NSMutableArray alloc] init];
        [tempStack addObject:[NSNull null]];
        
        NSIndexPath* tile = [_tiles objectAtIndex:index];
        while(![tile isEqual:[NSNull null]])
        {
            [tempStack addObject:tile];
            index += step;
            tile = [_tiles objectAtIndex:index];
        }
        while([tempStack count])
        {
            [_tiles replaceObjectAtIndex:index withObject:[tempStack lastObject]];
            [tempStack removeLastObject];
            index -= step;
        }
        [tempStack release];

    }
}


@end
