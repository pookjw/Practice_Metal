//
//  ViewController.m
//  Chapter8
//
//  Created by Jinwoo Kim on 9/1/24.
//

#import "ViewController.h"
#import "Renderer.h"

@interface ViewController ()
@property (readonly, nonatomic) MTKView *metalView;
@property (retain, nonatomic) Renderer *renderer;
@end

@implementation ViewController

- (void)dealloc {
    [_renderer release];
    [super dealloc];
}

- (void)loadView {
    MTKView *metalView = [MTKView new];
    self.view = metalView;
    [metalView release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Renderer *renderer = [[Renderer alloc] initWithMetalView:(MTKView *)self.view];
    self.renderer = renderer;
    [renderer release];
}

@end
