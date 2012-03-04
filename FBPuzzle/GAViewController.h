//
//  GAViewController.h
//  FBPuzzle
//
//  Created by Sergey Gavrilyuk on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBPuzzleGameView.h"

@interface GAViewController : UIViewController<FBPuzzleGameViewDelegate, UIAlertViewDelegate,
UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet FBPuzzleGameView* puzzleGameView;
@property (nonatomic, retain) IBOutlet UIView* flipContainerView;
@property (nonatomic, retain) IBOutlet UIButton* infoButton;


//settings related
@property (nonatomic, retain) IBOutlet UIView* settingsView;

@property (nonatomic, retain) IBOutlet UISegmentedControl* typeSlider;
@property (nonatomic, retain) IBOutlet UITableViewCell* typeCell;

@property (nonatomic, retain) IBOutlet UISegmentedControl* levelSlider;
@property (nonatomic, retain) IBOutlet UITableViewCell* levelCell;

@end
