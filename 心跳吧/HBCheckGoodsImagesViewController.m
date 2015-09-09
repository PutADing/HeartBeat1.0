//
//  HBCheckGoodsImagesViewController.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/4/23.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBCheckGoodsImagesViewController.h"
#import "HBTool.h"

@interface HBCheckGoodsImagesViewController () <UIScrollViewDelegate>
@property (nonatomic, strong)UIScrollView* scrollView;
@property (nonatomic, strong)UIPageControl* pageControl;

@end

@implementation HBCheckGoodsImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[HBTool shareTool]isIOS7_Later]) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    self.view.backgroundColor = COLOR_WHITE1;
    
    self.scrollView = [self createScrollViewWithY:NAVIGATIOINBARHEIGHT];
    [self.view addSubview:self.scrollView];
    
    [self scrollViewAddImageViews];
    
}

//创建scrollView
-(UIScrollView* )createScrollViewWithY:(CGFloat )origin_y {
    UIScrollView* sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, origin_y, self.view.frame.size.width, self.view.frame.size.height - NAVIGATIOINBARHEIGHT)];
    sv.backgroundColor = COLOR_BLACK1;
    sv.showsHorizontalScrollIndicator = NO;
    sv.showsVerticalScrollIndicator = NO;
    sv.delegate = self;
    sv.pagingEnabled = YES;
    return sv;
}

//scrollView添加imageView
-(void)scrollViewAddImageViews {
    self.title = [NSString stringWithFormat:@"%ld/%ld",self.pageControl.currentPage+1,self.imageArray.count];
    self.pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y + self.scrollView.frame.size.height - 20, self.scrollView.frame.size.width, 20)];
    self.pageControl.numberOfPages = self.imageArray.count;
    self.pageControl.pageIndicatorTintColor = COLOR_GRAY1;
    self.pageControl.currentPageIndicatorTintColor = COLOR_WHITE1;
    self.pageControl.currentPage = self.currentIndex;
    [self.scrollView addSubview:self.pageControl];
    
    for (int i = 0; i < self.imageArray.count; i++) {
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*i, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        imageView.image = self.imageArray[i];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.tag = i+1;
        [self.scrollView addSubview:imageView];
    }
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width*self.currentIndex, 0);
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*self.imageArray.count, 0);
}

//scrollView滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.pageControl.currentPage = (scrollView.contentOffset.x/scrollView.frame.size.width);
    int page = floor((scrollView.contentOffset.x - self.scrollView.frame.size.width / 2) / self.scrollView.frame.size.width) + 1;
    self.pageControl.currentPage = page;
    self.currentIndex = self.pageControl.currentPage;
    self.title = [NSString stringWithFormat:@"%ld/%ld",self.pageControl.currentPage+1,self.imageArray.count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
