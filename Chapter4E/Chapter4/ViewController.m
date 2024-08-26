//
//  ViewController.m
//  Chapter4
//
//  Created by Jinwoo Kim on 8/26/24.
//

#import "ViewController.h"
#import "Renderer.h"
#import <MetalKit/MetalKit.h>

@interface ViewController ()
@property (retain, nonatomic) IBOutlet MTKView *mtkView;
@property (retain, nonatomic) Renderer *renderer;
@end

@implementation ViewController

- (void)dealloc {
    [_mtkView release];
    [_renderer release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Renderer *renderer = [[Renderer alloc] initWithMetalView:self.mtkView];
    self.renderer = renderer;
    [renderer release];
}

@end
