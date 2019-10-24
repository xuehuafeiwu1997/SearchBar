//
//  SearchModel.h
//  搜索框实现
//
//  Created by 许明洋 on 2019/9/10.
//  Copyright © 2019 许明洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchProtocal.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchModel : NSObject<SearchProtocal>

- (instancetype)initWithName:(NSString *)name searchId:(NSString *)searchId;

@end

NS_ASSUME_NONNULL_END
