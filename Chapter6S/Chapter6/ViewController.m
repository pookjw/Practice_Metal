//
//  ViewController.m
//  Chapter6
//
//  Created by Jinwoo Kim on 8/27/24.
//

#import "ViewController.h"
#import <MetalKit/MetalKit.h>
#import "Renderer.h"

@interface ViewController ()
@property (retain, nonatomic) IBOutlet MTKView *metalView;
@property (retain, nonatomic) Renderer *renderer;
@end

@implementation ViewController

- (void)dealloc {
    [_metalView release];
    [_renderer release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Renderer *renderer = [[Renderer alloc] initWithMetalView:self.metalView];
    self.renderer = renderer;
    [renderer release];
}

@end
