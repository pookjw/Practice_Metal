//
//  ViewController.m
//  Chapter3
//
//  Created by Jinwoo Kim on 8/26/24.
//

#import "ViewController.h"
#import <MetalKit/MetalKit.h>
#import "Renderer.h"

@interface ViewController ()
@property (retain, nonatomic) IBOutlet MTKView *mtkView;
@property (retain, nonatomic, nullable) Renderer *renderer;
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
