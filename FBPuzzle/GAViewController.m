//
//  GAViewController.m
//  FBPuzzle
//
//  Created by Sergey Gavrilyuk on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GAViewController.h"
#import "FBPuzzleGameViewTile.h"
#import "GAAppDelegate.h"

@implementation GAViewController
@synthesize puzzleGameView;


////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - View lifecycle
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.puzzleGameView.delegate = self;
    
    [self.puzzleGameView loadGameView];

}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.puzzleGameView = nil;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)dealloc
{
    self.puzzleGameView = nil;
    [super dealloc];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController methods
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}
////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Puzzle game view delegate methods
////////////////////////////////////////////////////////////////////////////////////////////////////

-(NSUInteger)gameDimensionForGameView:(FBPuzzleGameView *)gameVIew
{
    return [(GAAppDelegate*)[UIApplication sharedApplication].delegate puzzleGame].dimension;
}

-(FBPuzzleGameViewTile *)gameView:(FBPuzzleGameView *)gameVIew 
                 tileForIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath isEqual:
        [(GAAppDelegate*)[UIApplication sharedApplication].delegate puzzleGame].skippedTileIndexPath])
        return nil;
    
    FBPuzzleGameViewTile* tile = [[FBPuzzleGameViewTile alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    return [tile autorelease];
}

-(BOOL)gameView:(FBPuzzleGameView *)gameView 
canMoveTileAtIndexPath:(NSIndexPath *)indexPath 
    inDirection:(EFBPuzzleGameMoveDirection)direction
{
    FBPuzzleGame* game = [(GAAppDelegate*)[UIApplication sharedApplication].delegate puzzleGame];
    return [game canMoveTileAtIndexPath:indexPath inDirection:direction];
}

-(void)gameView:(FBPuzzleGameView *)gameView 
didMoveTileAtIndexPath:(NSIndexPath *)indexPath
    inDirection:(EFBPuzzleGameMoveDirection)direction
{
    FBPuzzleGame* game = [(GAAppDelegate*)[UIApplication sharedApplication].delegate puzzleGame];
    [game moveTileAtIndexPath:indexPath inDirection:direction];
}


@end
