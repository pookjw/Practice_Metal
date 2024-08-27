//
//  ViewController.m
//  Chapter5
//
//  Created by Jinwoo Kim on 8/27/24.
//

#import "ViewController.h"
#import <MetalKit/MetalKit.h>
#import "Renderer.h"

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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    self.renderer.showGrid = !self.renderer.showGrid;
}

@end
