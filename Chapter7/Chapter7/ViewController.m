//
//  ViewController.m
//  Chapter7
//
//  Created by Jinwoo Kim on 4/14/23.
//

#import "ViewController.h"
#import <MetalKit/MetalKit.h>
#import "Renderer.h"

@interface ViewController ()
@property (strong) MTKView *metalView;
@property (strong) UISegmentedControl *segmentedControl;

@property (strong) Renderer *renderer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MTKView *metalView = [MTKView new];
    
    Renderer *renderer = [[Renderer alloc] initWithMetalView:metalView options:OptionsTrain];
    
    UIAction *trainAction = [UIAction actionWithTitle:@"Train" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        renderer.options = OptionsTrain;
    }];
    
    UIAction *quadAction = [UIAction actionWithTitle:@"Quad" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        renderer.options = OptionsQuad;
    }];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectNull actions:@[trainAction, quadAction]];
    segmentedControl.selectedSegmentIndex = 0;
    
    metalView.translatesAutoresizingMaskIntoConstraints = NO;
    segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:metalView];
    [self.view addSubview:segmentedControl];
    
    [NSLayoutConstraint activateConstraints:@[
        [metalView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [metalView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [metalView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        [metalView.bottomAnchor constraintEqualToAnchor:segmentedControl.topAnchor],
        [segmentedControl.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [segmentedControl.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        [segmentedControl.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
    ]];
    
    self.metalView = metalView;
    self.segmentedControl = segmentedControl;
    self.renderer = renderer;
}

@end
