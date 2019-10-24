//
//  SearchCollectionReusableView.h
//  搜索框实现
//
//  Created by 许明洋 on 2019/9/11.
//  Copyright © 2019 许明洋. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SearchCollectionReusableView;

@protocol UICollectionReusableViewButtonDelegate <NSObject>

- (void)deleteDatas:(UICollectionReusableView *)view;

@end

typedef void(^deleteButtonBlock)(UICollectionReusableView *view);

@interface SearchCollectionReusableView : UICollectionReusableView

@property (nonatomic,weak) id<UICollectionReusableViewButtonDelegate> delegate;
@property (nonatomic,copy) NSString *imageName;
@property (nonatomic,copy) NSString *text;
@property (nonatomic,assign) BOOL hidenDeleteBtn;
//申明block
@property (nonatomic,copy) deleteButtonBlock deleteDatas;


@end

NS_ASSUME_NONNULL_END
