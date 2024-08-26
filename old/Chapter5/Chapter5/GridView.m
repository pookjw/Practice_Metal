//
//  GridView.m
//  Chapter5
//
//  Created by Jinwoo Kim on 4/8/23.
//

#import "GridView.h"

#define GRIDVIEW_BLOCK_COUNT 20

@interface GridView ()
@property (strong) UIStackView *columnStackView;
@property (strong) UIStackView *rowStackView;
@end

@implementation GridView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0.9f green:0.9f blue:0.85f alpha:1.f];
        
        [self setupColumnStackView];
        [self setupRowStackView];
    }
    
    return self;
}

- (void)setupColumnStackView {
    UIStackView *columnStackView = [[UIStackView alloc] initWithFrame:self.bounds];
    columnStackView.backgroundColor = UIColor.clearColor;
    columnStackView.distribution = UIStackViewDistributionFillEqually;
    columnStackView.axis = UILayoutConstraintAxisVertical;
    columnStackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    for (NSUInteger i = 0; i < GRIDVIEW_BLOCK_COUNT; i++) {
        @autoreleasepool {
            UIView *containerView = [UIView new];
            containerView.backgroundColor = UIColor.clearColor;
            
            UIView *separatorView = [UIView new];
            separatorView.backgroundColor = UIColor.grayColor;
            separatorView.translatesAutoresizingMaskIntoConstraints = NO;
            [containerView addSubview:separatorView];
            
            BOOL isCenter = (((GRIDVIEW_BLOCK_COUNT - 2) / 2) == i) && ((GRIDVIEW_BLOCK_COUNT % 2) == 0);
            CGFloat length = isCenter ? 2.f : 1.f;
            
            [NSLayoutConstraint activateConstraints:@[
                [separatorView.leftAnchor constraintEqualToAnchor:containerView.leftAnchor],
                [separatorView.rightAnchor constraintEqualToAnchor:containerView.rightAnchor],
                [separatorView.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor constant:length / 2.f],
                [separatorView.heightAnchor constraintEqualToConstant:length]
            ]];
            
            [columnStackView addArrangedSubview:containerView];
        }
    }
    
    [self addSubview:columnStackView];
    
    [NSLayoutConstraint activateConstraints:@[
        [columnStackView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [columnStackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [columnStackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [columnStackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
    
    self.columnStackView = columnStackView;
}

- (void)setupRowStackView {
    UIStackView *rowStackView = [[UIStackView alloc] initWithFrame:self.bounds];
    rowStackView.backgroundColor = UIColor.clearColor;
    rowStackView.distribution = UIStackViewDistributionFillEqually;
    rowStackView.axis = UILayoutConstraintAxisHorizontal;
    rowStackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    for (NSUInteger i = 0; i < GRIDVIEW_BLOCK_COUNT; i++) {
        @autoreleasepool {
            UIView *containerView = [UIView new];
            containerView.backgroundColor = UIColor.clearColor;
            
            UIView *separatorView = [UIView new];
            separatorView.backgroundColor = UIColor.grayColor;
            separatorView.translatesAutoresizingMaskIntoConstraints = NO;
            [containerView addSubview:separatorView];
            
            BOOL isCenter = (((GRIDVIEW_BLOCK_COUNT - 2) / 2) == i) && ((GRIDVIEW_BLOCK_COUNT % 2) == 0);
            CGFloat length = isCenter ? 2.f : 1.f;
            
            [NSLayoutConstraint activateConstraints:@[
                [separatorView.topAnchor constraintEqualToAnchor:containerView.topAnchor],
                [separatorView.rightAnchor constraintEqualToAnchor:containerView.rightAnchor constant:length / 2.f],
                [separatorView.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor],
                [separatorView.widthAnchor constraintEqualToConstant:length]
            ]];
            
            [rowStackView addArrangedSubview:containerView];
        }
    }
    
    [self addSubview:rowStackView];
    
    [NSLayoutConstraint activateConstraints:@[
        [rowStackView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [rowStackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [rowStackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [rowStackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
    
    self.rowStackView = rowStackView;
}

@end
