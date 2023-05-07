//
//  ViewController.m
//  Project10
//
//  Created by Jinwoo Kim on 5/7/23.
//

#import "ViewController.h"
#import <MetalKit/MetalKit.h>
#import "Renderer.h"

@interface ViewController ()
@property (strong) Renderer *renderer;
@end

@implementation ViewController

- (void)loadView {
    MTKView *mtkView = [MTKView new];
    Renderer *renderer = [[Renderer alloc] initWithMTKView:mtkView];
    self.view = mtkView;
    self.renderer = renderer;
}

@end
