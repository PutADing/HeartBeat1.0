//
//  HBCheckDetailImageViewController.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/4/7.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBCheckDetailImageViewController.h"
#import "HBTool.h"

@interface HBCheckDetailImageViewController () <UIAlertViewDelegate, UIScrollViewDelegate>
@property (nonatomic, strong)UIScrollView* scrollView;
@property (nonatomic, strong)UIPageControl* pageControl;

@end

@implementation HBCheckDetailImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[HBTool shareTool]isIOS7_Later]) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    self.view.backgroundColor = COLOR_WHITE1;
    [self createDeleteButton];
    
    self.scrollView = [self createScrollViewWithY:NAVIGATIOINBARHEIGHT];
    [self.view addSubview:self.scrollView];
    
    [self scrollViewAddImageViews];
    
}

//添加右上角的 删除 按钮
-(void)createDeleteButton {
    UIButton* deleteBtn = [[UIButton alloc]init];
    [deleteBtn setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
    deleteBtn.frame=CGRectMake(0, 0, 25, 25);
    deleteBtn.layer.masksToBounds = YES;
    [deleteBtn.layer setCornerRadius:4];
    [deleteBtn addTarget:self action:@selector(showAlertView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* deleteItem = [[UIBarButtonItem alloc] initWithCustomView:deleteBtn];
    self.navigationItem.rightBarButtonItem = deleteItem;
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

//alertView提示是否删除照片
-(void)showAlertView {
    UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"此操作不可恢复，确定删除?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    [av show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        UIImageView* iv = (UIImageView*)[self.scrollView viewWithTag:self.currentIndex+1];
        [iv removeFromSuperview];
        
        [self.imageArray removeObjectAtIndex:self.currentIndex];
//        [self.HBPZGXVC.imageArr removeObjectAtIndex:self.currentIndex];

//        NSLog(@"currentIndex=%ld,currentPage=%ld", self.currentIndex, self.pageControl.currentPage);
//        NSLog(@"count=%ld,imageArray=%@,count=%ld,imageArr=%@", self.imageArray.count, self.imageArray, self.HBPZGXVC.imageArr.count, self.HBPZGXVC.imageArr);
        
        if (self.currentIndex > 0) {
            self.pageControl.currentPage--;
            self.currentIndex--;
        }else if (self.currentIndex <= 0) {
            if (self.imageArray.count == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                self.currentIndex = 0;
                self.pageControl.currentPage = 0;
            }
            
        }
        [self scrollViewAddImageViews];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
