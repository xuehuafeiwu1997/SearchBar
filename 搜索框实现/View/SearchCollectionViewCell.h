//
//  SearchCollectionViewCell.h
//  搜索框实现
//
//  Created by 许明洋 on 2019/9/10.
//  Copyright © 2019 许明洋. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchCollectionViewCell : UICollectionViewCell

@property (nonatomic,copy) NSString *text;

+ (CGSize)getSizeWithText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
