//
//  ViewController.m
//  Chapter9
//
//  Created by Jinwoo Kim on 9/21/24.
//

#import "ViewController.h"
#import "Renderer.h"

@interface ViewController ()
@property (retain, nonatomic, nullable) Renderer *renderer;
@end

@implementation ViewController

- (void)dealloc {
    [_renderer release];
    [super dealloc];
}

- (void)loadView {
    MTKView *mtkView = [MTKView new];
    self.view = mtkView;
    [mtkView release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Renderer *renderer = [[Renderer alloc] initWithMetalView:(MTKView *)self.view];
    self.renderer = renderer;
    [renderer release];
}


@end
