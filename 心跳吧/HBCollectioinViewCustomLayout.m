//
//  HBCollectioinViewCustomLayout.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/3/30.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBCollectioinViewCustomLayout.h"

@implementation HBCollectioinViewCustomLayout

//collectioinView的宽高
#define WIDTH_CELL ((self.view.frame.size.width - 10*4)/2)
#define HEIGHT_CELL 200

-(instancetype)init {
    self = [super init];
    if (self) {
        
        [self initData];
        
    }
    return self;
}

-(void)initData {
//    self.itemSize = CGSizeMake(130, HEIGHT_CELL);
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.minimumInteritemSpacing = 10;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
/*
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
 
    //获取每一个Cell的布局属性
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    for (UICollectionViewLayoutAttributes *attributes in array) {
        CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
        CGFloat distance2 = distance / ITEM_SIZE;
        if(ABS(distance) < ITEM_SIZE){
            CGFloat zoom = 1 + ZOOM_FACTOR * (1 - ABS(distance2));
            attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1);
        }
    }
    return array;
    
    
    
    NSMutableArray* attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    for (UICollectionViewLayoutAttributes *attr in attributes) {
        NSLog(@"%@", NSStringFromCGRect([attr frame]));
        
        for(int i = 1; i < [attributes count]; ++i) {
            //当前attributes
            UICollectionViewLayoutAttributes *currentLayoutAttributes = attributes[i];
            //上一个attributes
            UICollectionViewLayoutAttributes *prevLayoutAttributes = attributes[i - 1];
            //我们想设置的最大间距，可根据需要改
            NSInteger maximumSpacing = 0;
            //前一个cell的最右边
            NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
            //如果当前一个cell的最右边加上我们想要的间距加上当前cell的宽度依然在contentSize中，我们改变当前cell的原点位置
            //不加这个判断的后果是，UICollectionView只显示一行，原因是下面所有cell的x值都被加到第一行最后一个元素的后面了
            if(origin + maximumSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width) {
                CGRect frame = currentLayoutAttributes.frame;
                frame.origin.x = origin + maximumSpacing;
                currentLayoutAttributes.frame = frame;
            }
        }
    }
}
*/

@end
