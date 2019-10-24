//
//  SearchLayout.h
//  搜索框实现
//
//  Created by 许明洋 on 2019/9/10.
//  Copyright © 2019 许明洋. All rights reserved.
//重写UICollectionViewFlowLayout的布局方式

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchLayout : UICollectionViewFlowLayout

/**
 列间距
 */
@property (nonatomic,assign) CGFloat listItemSpace;
@end

NS_ASSUME_NONNULL_END
