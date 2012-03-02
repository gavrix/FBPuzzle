//
//  GAViewController.h
//  FBPuzzle
//
//  Created by Sergey Gavrilyuk on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBPuzzleGameView.h"

@interface GAViewController : UIViewController<FBPuzzleGameViewDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) IBOutlet FBPuzzleGameView* puzzleGameView;

@end
