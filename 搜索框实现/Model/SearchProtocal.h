//
//  SearchProtocal.h
//  搜索框实现
//
//  Created by 许明洋 on 2019/9/10.
//  Copyright © 2019 许明洋. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SearchProtocal <NSObject>

/**
 内容
 */
@property (nonatomic,copy) NSString *content;

/**
 搜索内容id
 */
@property (nonatomic,copy) NSString *searchId;
@end

NS_ASSUME_NONNULL_END
