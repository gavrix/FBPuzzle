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
#import <QuartzCore/QuartzCore.h>

@interface GAViewController()
-(UIImage*) imageForTileAtIndexPath:(NSIndexPath*) indexPath
                      withDimension:(NSUInteger) dimension;
@end

@implementation GAViewController
@synthesize puzzleGameView, infoButton, settingsView, flipContainerView;
@synthesize typeSlider, typeCell, levelSlider, levelCell;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - View lifecycle
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.puzzleGameView.delegate = self;
    
    [self.puzzleGameView loadGameView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gameFinished)
                                                 name:kGameFinishedNotification
                                               object:nil];
    self.settingsView.layer.cornerRadius = 10.0f;
    self.settingsView.layer.shadowOffset = CGSizeZero;
    self.settingsView.layer.shadowRadius = 20;
    self.settingsView.layer.shadowOpacity = 1;
    self.settingsView.layer.shadowPath = 
        [UIBezierPath bezierPathWithRoundedRect:self.settingsView.bounds 
                               cornerRadius:10].CGPath;

    self.typeSlider.selectedSegmentIndex = [[[NSUserDefaults standardUserDefaults] valueForKey:@"type"] intValue];


}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.puzzleGameView = nil;
    self.infoButton = nil;
    self.settingsView = nil;
    self.flipContainerView = nil;
    
    self.typeSlider = nil;
    self.typeCell = nil;
    self.levelSlider = nil;
    self.levelCell = nil;;

}

////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.puzzleGameView = nil;
    self.infoButton = nil;
    self.settingsView = nil;
    self.flipContainerView = nil;
    
    self.typeSlider = nil;
    self.typeCell = nil;
    self.levelSlider = nil;
    self.levelCell = nil;;

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


-(void) gameFinished
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Congrats!"
                                                    message:@"You've finished this puzzle! Start again?"
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    [alert show];
    [alert release];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == [alertView firstOtherButtonIndex])
    {
        FBPuzzleGame* game = [(GAAppDelegate*)[UIApplication sharedApplication].delegate puzzleGame];
        [game initializeGameWithDimension: game.dimension
               withSkippedTileAtIndexPath:[NSIndexPath indexPathForColumn:0 forRow:0]];
        [self.puzzleGameView loadGameView];
    }
}
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
    FBPuzzleGame* game = [(GAAppDelegate*)[UIApplication sharedApplication].delegate puzzleGame];
    if([indexPath isEqual: game.skippedTileIndexPath])
        return nil;
    
    FBPuzzleGameViewTile* tile = [[FBPuzzleGameViewTile alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    
    NSInteger type = [[[NSUserDefaults standardUserDefaults] objectForKey:@"type"] intValue];
    if(type == 0)
    {
        UIImageView* imageView = [[UIImageView alloc] initWithImage:[self imageForTileAtIndexPath:[game realIndexOfTileAtIndexPath:indexPath ] 
                                                                                    withDimension:game.dimension]];
        imageView.frame = tile.bounds;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [tile addSubview:imageView];
        [imageView release];
    }
    else if(type == 1)
    {
        UILabel* label = [[UILabel alloc] initWithFrame:tile.bounds];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        label.font = [UIFont boldSystemFontOfSize:52];
        label.textAlignment = UITextAlignmentCenter;
        NSIndexPath* realdIndexPath = [game realIndexOfTileAtIndexPath:indexPath ];
        label.text = [NSString stringWithFormat:@"%d", realdIndexPath.row * game.dimension + realdIndexPath.column ];
        [tile addSubview:label];
        [label release];
    }
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

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Utilities
////////////////////////////////////////////////////////////////////////////////////////////////////

-(UIImage*) imageForTileAtIndexPath:(NSIndexPath*) indexPath
                      withDimension:(NSUInteger) dimension
{
    UIImage* globe = [UIImage imageNamed:@"globe.jpg"];
    
    UIGraphicsBeginImageContext(self.puzzleGameView.frame.size);
    [globe drawInRect:CGRectMake(0, 0, puzzleGameView.frame.size.width, puzzleGameView.frame.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();

    CGImageRef crop = CGImageCreateWithImageInRect(newImage.CGImage, [self.puzzleGameView frameForTileAtIndexPath:indexPath]);
    UIImage* retVal = [UIImage imageWithCGImage:crop];
    CGImageRelease(crop);
    return retVal;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - button action handlers
////////////////////////////////////////////////////////////////////////////////////////////////////

-(IBAction)infoButtonPressed
{
    [UIView beginAnimations:nil context:nil];
    if(self.settingsView.hidden)
    {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
                               forView:self.flipContainerView cache:YES];
        [UIView setAnimationDuration:1];

        [self.puzzleGameView setHidden:YES];
        [self.settingsView setHidden:NO];
        
        [UIView commitAnimations];
    }
    else
    {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
                               forView:self.flipContainerView cache:YES];
        [UIView setAnimationDuration:1];

        [self.settingsView setHidden:YES];
        [self.puzzleGameView setHidden:NO];

        [UIView commitAnimations];
    }
    

}

-(IBAction)levelChanged:(id)sender
{
    
}

-(IBAction)typeChanged:(id)sender
{
    NSInteger value = [(UISegmentedControl*)sender selectedSegmentIndex];
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:value] 
                                             forKey:@"type"];
    [self.puzzleGameView loadGameView];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - button action handlers
////////////////////////////////////////////////////////////////////////////////////////////////////

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* headerTitle = nil;
    switch (section)
    {
        case 0:
            headerTitle = @"Type";
            break;
        case 1:
            headerTitle = @"Level";
            break;
        default:
            break;
    }
    return headerTitle;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = 0;
    switch (section)
    {
        case 0:
            num = 1;
            break;
        case 1:
            num = 1;
            break;
        default:
            break;
    }
    return num;
}

-(UITableViewCell *)tableView:(UITableView *)tableView 
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    switch (indexPath.section)
    {
        case 0:
            cell = self.typeCell;
            break;
        case 1:
            cell = self.levelCell;
            break;
        default:
            break;
    }
    return cell;
}

@end
