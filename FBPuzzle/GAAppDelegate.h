//
//  GAAppDelegate.h
//  FBPuzzle
//
//  Created by Sergey Gavrilyuk on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBPuzzleGame.h"

@class GAViewController;

@interface GAAppDelegate : UIResponder <UIApplicationDelegate>
{
    @private
    FBPuzzleGame* _game;
}
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) GAViewController *viewController;

-(FBPuzzleGame*) puzzleGame;

@end
