//
//  ViewController.m
//  Chapter8
//
//  Created by Jinwoo Kim on 4/29/23.
//

#import "ViewController.h"
#import "Renderer.h"

@interface ViewController ()
@property (strong) Renderer *renderer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MTKView *mtkView = [MTKView new];
    mtkView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:mtkView];
    [NSLayoutConstraint activateConstraints:@[
        [mtkView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [mtkView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [mtkView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [mtkView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    self.renderer = [[Renderer alloc] initWithMTKView:mtkView choice:RendererChoiceQuad];
}


@end
