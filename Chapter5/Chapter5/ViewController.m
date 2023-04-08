//
//  ViewController.m
//  Chapter5
//
//  Created by Jinwoo Kim on 4/8/23.
//

#import "ViewController.h"
#import "GridView.h"
#import "Renderer.h"

@interface ViewController ()
//@property (strong) GridView *gridView;
@property (strong) MTKView *gridView;
@property (strong) Renderer *renderer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGridView];
}

- (void)setupGridView {
//    GridView *gridView = [GridView new];
    MTKView *gridView = [MTKView new];
    Renderer *renderer = [[Renderer alloc] initWithMetalView:gridView];
    
    gridView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:gridView];
    
    NSLayoutConstraint *topConstraint = [gridView.topAnchor constraintLessThanOrEqualToAnchor:self.view.topAnchor];
    NSLayoutConstraint *leadingConstraint = [gridView.leadingAnchor constraintLessThanOrEqualToAnchor:self.view.leadingAnchor];
    NSLayoutConstraint *trailingConstraint = [gridView.trailingAnchor constraintGreaterThanOrEqualToAnchor:self.view.trailingAnchor];
    NSLayoutConstraint *bottomConstraint = [gridView.bottomAnchor constraintGreaterThanOrEqualToAnchor:self.view.bottomAnchor];
    
    topConstraint.priority = UILayoutPriorityDefaultHigh;
    leadingConstraint.priority = UILayoutPriorityDefaultHigh;
    trailingConstraint.priority = UILayoutPriorityDefaultHigh;
    bottomConstraint.priority = UILayoutPriorityDefaultHigh;
    
    [NSLayoutConstraint activateConstraints:@[
        topConstraint,
        leadingConstraint,
        trailingConstraint,
        bottomConstraint,
        [gridView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [gridView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [gridView.widthAnchor constraintLessThanOrEqualToAnchor:self.view.widthAnchor],
        [gridView.heightAnchor constraintLessThanOrEqualToAnchor:self.view.heightAnchor],
        [gridView.widthAnchor constraintEqualToAnchor:gridView.heightAnchor]
    ]];
    
    self.gridView = gridView;
    self.renderer = renderer;
}

@end
