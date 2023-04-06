//
//  ViewController.m
//  Chapter3
//
//  Created by Jinwoo Kim on 4/6/23.
//

#import "ViewController.h"
#import "Renderer.h"

@interface ViewController ()
@property (strong) Renderer *renderer;
@end

@implementation ViewController

- (void)loadView {
    self.view = [MTKView new];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.renderer = [[Renderer alloc] initWithMetalView:(MTKView *)self.view];
}

@end
