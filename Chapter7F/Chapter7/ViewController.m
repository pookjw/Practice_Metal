//
//  ViewController.m
//  Chapter7
//
//  Created by Jinwoo Kim on 8/28/24.
//

#import "ViewController.h"
#import <MetalKit/MetalKit.h>
#import "Options.h"
#import "Renderer.h"

@interface ViewController ()
@property (retain, nonatomic) IBOutlet MTKView *metalView;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (retain, nonatomic) Renderer *renderer;
@end

@implementation ViewController

- (void)dealloc {
    [_metalView release];
    [_segmentedControl release];
    [_renderer release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Renderer *renderer = [[Renderer alloc] initWithMetalView:self.metalView options:self.segmentedControl.selectedSegmentIndex];
    self.renderer = renderer;
    [renderer release];
}

- (IBAction)didChangeSegmentedControlValue:(UISegmentedControl *)sender {
    self.renderer.options = sender.selectedSegmentIndex;
}

@end
