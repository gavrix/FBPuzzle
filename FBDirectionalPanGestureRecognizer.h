//
//  FBDirectionalPanGestureRecognizer.h
//  FBPuzzle
//
//  Created by Sergey Gavrilyuk on 3/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIGestureRecognizerSubclass.h>


typedef enum 
{
    EFBPanGestureDirectionVertical,
    EFBPanGestureDirectionHorizontal
} EFBPanGestureDirection;

@interface FBDirectionalPanGestureRecognizer : UIPanGestureRecognizer {
    BOOL _drag;
    int _moveX;
    int _moveY;
    EFBPanGestureDirection _direction;
}

@property (nonatomic, assign) EFBPanGestureDirection direction;

@end

