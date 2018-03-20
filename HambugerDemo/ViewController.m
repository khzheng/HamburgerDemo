//
//  ViewController.m
//  HambugerDemo
//
//  Created by Ken Zheng on 3/19/18.
//  Copyright © 2018 Ken Zheng. All rights reserved.
//

#import "ViewController.h"

#define X_THRESHOLD_MENU    0.75

@interface ViewController ()

@property (nonatomic, weak) UIView *menuView;
@property (nonatomic, weak) UIView *yellowView;
@property (nonatomic, assign) BOOL showingMenu;

@end

@implementation ViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _showingMenu = NO;
    }
    
    return self;
}

- (void)loadView {
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectZero];
    menuView.autoresizesSubviews = YES;
    menuView.backgroundColor = [UIColor blackColor];
    
    UIView *yellowView = [[UIView alloc] initWithFrame:CGRectZero];
    yellowView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    yellowView.backgroundColor = [UIColor yellowColor];
    yellowView.userInteractionEnabled = YES;
    
    [menuView addSubview:yellowView];
    
    self.view = menuView;
    
    self.menuView = menuView;
    self.yellowView = yellowView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    pan.minimumNumberOfTouches = 1;
    pan.maximumNumberOfTouches = 1;
    pan.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:pan];
}

- (void)showMenu:(BOOL)shouldShow {
    CGRect yellowFrame = self.yellowView.frame;
    CGRect targetFrame = CGRectZero;
    if (shouldShow) {
        targetFrame = CGRectMake(self.view.bounds.size.width * 0.75, yellowFrame.origin.y, yellowFrame.size.width, yellowFrame.size.height);
    } else {
        targetFrame = CGRectMake(0, yellowFrame.origin.y, yellowFrame.size.width, yellowFrame.size.height);
    }
    
    [UIView animateWithDuration:0.35 animations:^{
        self.yellowView.frame = targetFrame;
    }];
    
    self.showingMenu = shouldShow;
}

- (void)panAction:(UIPanGestureRecognizer *)sender {
    CGPoint point = [sender translationInView:sender.view];
//    NSLog(@"point: %@", NSStringFromCGPoint(point));
    
    CGRect yellowRect = self.yellowView.frame;
    
    if (self.showingMenu) {
        if (point.x < 0) {
            CGRect yellowFrame = self.yellowView.frame;
            self.yellowView.frame = CGRectMake(self.view.bounds.size.width*X_THRESHOLD_MENU +point.x, yellowFrame.origin.y, yellowFrame.size.width, yellowFrame.size.height);
        }
    } else {
        if (point.x > 0) {
            self.yellowView.frame = CGRectMake(point.x, yellowRect.origin.y, yellowRect.size.width, yellowRect.size.height);
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    NSLog(@"touchesEnded: %@", NSStringFromCGPoint(point));
    
    if (self.showingMenu) {
        if (self.yellowView.frame.origin.x < self.view.bounds.size.width*X_THRESHOLD_MENU - 40) {
            [self showMenu:NO];
        } else {
            [self showMenu:YES];
        }
    } else {
        if (self.yellowView.frame.origin.x > 120.0) {   // show menu
            [self showMenu:YES];
        } else {                                        // hide menu
            [self showMenu:NO];
        }
    }
}

@end
