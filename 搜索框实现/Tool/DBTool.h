//
//  DBTool.h
//  搜索框实现
//
//  Created by 许明洋 on 2019/9/11.
//  Copyright © 2019 许明洋. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBTool : NSObject

/**
 * 根据参数去取数据
 */
+ (id)statusesWithKey:(NSString *)key;

/**
 *存储服务器数据到沙盒中
 *status 表示需要存储的数据
 */
+ (void)saveStatuses:(id)statuses key:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
