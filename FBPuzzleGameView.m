//
//  PuzzleGameView.m
//  FBPuzzle
//
//  Created by Sergey Gavrilyuk on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FBPuzzleGameView.h"
#import "FBPuzzleGameViewTile.h"
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
#import "FBPuzzleGame.h"
static char shadowKey;





@implementation FBPuzzleGameView
@synthesize delegate;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - construction & destruction
////////////////////////////////////////////////////////////////////////////////////////////////////
-(void) commonInit
{
    self.backgroundColor = [UIColor lightGrayColor];
    
    _shadowsView = [[UIView alloc] initWithFrame:self.bounds];
    _shadowsView.backgroundColor = [UIColor clearColor];
    _shadowsView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self addSubview:_shadowsView];
    
    UIPanGestureRecognizer* verticalGc = [[UIPanGestureRecognizer alloc] 
                                          initWithTarget:self
                                          action:@selector(handleVerticalGesture:)];
    [self addGestureRecognizer:verticalGc];
    [verticalGc release];verticalGc = nil;


}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        [self commonInit];
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self commonInit];
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)dealloc
{
    [_shadowsView release];
    [_tiles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) 
    {
        [obj removeObserver:self forKeyPath:@"frame"];
    }];
    
    [_tiles release];
    
    [super dealloc];
}
////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - loading the game
////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)loadGameView
{
    // clear current game state
    [_tiles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) 
    {
        [(UIView*)obj removeFromSuperview];
        [obj removeObserver:self forKeyPath:@"frame"];
    }];
    [_tiles removeAllObjects];
    
    
    //check if we have delegate installed and it has all required methods
    if(!([self.delegate respondsToSelector:@selector(gameDimensionForGameView:)] && 
       [self.delegate respondsToSelector:@selector(gameView:tileForIndexPath:)]))
        // we won't be able to initialize game without this information
        return;
    
    _dimension = [self.delegate gameDimensionForGameView:self];
    
    [_tiles release];
    _tiles = [[NSMutableArray alloc] initWithCapacity:_dimension*_dimension];
    
   
    
    for(NSUInteger row = 0; row < _dimension; ++row)
    {
        for(NSUInteger column = 0; column < _dimension; ++column)
            
        {
                
            FBPuzzleGameViewTile* tile = [self.delegate gameView:self tileForIndexPath:[NSIndexPath indexPathForColumn:column forRow:row]];
            if(!tile)
            {
                [_tiles addObject:[NSNull null]];
                continue;
            }

            tile.currentPosition = [NSIndexPath indexPathForColumn:column forRow:row];
            
            [tile addObserver:self forKeyPath:@"frame" options:0 context:nil];
            
            UIGestureRecognizer* horGc = [[UIPanGestureRecognizer alloc] 
                                        initWithTarget:self
                                        action:@selector(handleHorizontalGesture:)];


            
            [tile addGestureRecognizer:horGc];
            [horGc release];
            
            UIView* shadowView = [[UIView alloc] initWithFrame:tile.frame];
            

            shadowView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
            shadowView.layer.shadowOpacity = 1;
            shadowView.layer.shadowOffset = CGSizeZero;
            shadowView.layer.shadowRadius = 20;
            
            objc_setAssociatedObject(tile, &shadowKey, shadowView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [_shadowsView addSubview:shadowView];
            [shadowView release];
            
            [_tiles addObject:tile];
            [self addSubview:tile];
        }
    }
    [self setNeedsLayout];
}


-(void) layoutSubviews
{
    [super layoutSubviews];
    if([_tiles count])
    {
        [_tiles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) 
        {
            if(![obj isEqual:[NSNull null]])
            {
                FBPuzzleGameViewTile* tile = (FBPuzzleGameViewTile*)obj;
                CGSize tileSize = CGSizeMake(self.bounds.size.width/(CGFloat)_dimension, 
                                             self.bounds.size.height/(CGFloat)_dimension);
                CGRect frame = CGRectMake(ceil(tileSize.width*tile.currentPosition.column),
                                          ceil(tileSize.height*tile.currentPosition.row), 
                                          ceil(tileSize.width), ceil(tileSize.height) );
                tile.frame = frame;

            }
            
        }];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([_tiles containsObject:object] && [keyPath isEqualToString:@"frame"])
    {
        UIView* tile = (UIView*)object;
        UIView* shadowView = objc_getAssociatedObject(object, &shadowKey);
        if(shadowView)
        {
            shadowView.frame = tile.frame;
            shadowView.layer.shadowPath = [UIBezierPath bezierPathWithRect:shadowView.bounds].CGPath;
        }
        
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Gesture recognizer handlers
////////////////////////////////////////////////////////////////////////////////////////////////////

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([_tiles containsObject:touch.view] )
        return YES;
    return NO;
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if([_tiles containsObject:gestureRecognizer.view] )
        return YES;
    return NO;
}

-(void) handleVerticalGesture:(UIPanGestureRecognizer*) gc
{
    UIView* tile = gc.view;
    if([_tiles containsObject:tile])
    {
        tile.frame = CGRectMake(tile.frame.origin.x + [gc translationInView:self].x, 
                                tile.frame.origin.y, 
                                tile.frame.size.width, tile.frame.size.height);
    }

}

-(void) handleHorizontalGesture:(UIPanGestureRecognizer*) gc
{
    UIView* tile = gc.view;
    if([_tiles containsObject:tile])
    {
        tile.frame = CGRectMake(tile.frame.origin.x + [gc translationInView:tile].x, 
                                tile.frame.origin.y, 
                                tile.frame.size.width, tile.frame.size.height);
        [gc setTranslation:CGPointZero inView:tile];
    }

}


////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Uitilities
////////////////////////////////////////////////////////////////////////////////////////////////////



@end
