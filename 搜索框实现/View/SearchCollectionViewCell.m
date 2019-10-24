//
//  SearchCollectionViewCell.m
//  搜索框实现
//
//  Created by 许明洋 on 2019/9/10.
//  Copyright © 2019 许明洋. All rights reserved.
//

#import "SearchCollectionViewCell.h"
#import "Masonry.h"
#import "SearchViewController.h"

@interface SearchCollectionViewCell()

@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UILabel *nameLabel;

@end


@implementation SearchCollectionViewCell

#pragma mark - 懒加载
- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] initWithFrame:CGRectZero];
        _backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom .equalTo(self.contentView);
        }];
    }
    return _backView;
}

-(UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.backgroundColor = [UIColor whiteColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.backView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.backView).offset(7);
            make.right.bottom.equalTo(self.backView).offset(-7);
        }];
    }
    return _nameLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.backView.layer setCornerRadius:12.0];
        [self.backView setBackgroundColor:[UIColor colorWithWhite:0.957 alpha:1.000]];
    }
    return self;
}

- (void)setText:(NSString *)text {
    _text = text;
    self.nameLabel.text = text;
}

/**
 根据文本长度计算文本的大小
 */
+ (CGSize)getSizeWithText:(NSString *)text {
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    
    //以字符为单位换行，以字符为单位截断
    style.lineBreakMode = NSLineBreakByCharWrapping;
    CGSize size = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 24) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f],NSParagraphStyleAttributeName:style} context:nil].size;
    if (size.width + 2 * 8 >= [UIScreen mainScreen].bounds.size.width - 2 * 20 ) {
        
        size.width = [UIScreen mainScreen].bounds.size.width - 2 * 20 - 2 * 8.f;
    }
    return CGSizeMake(ceilf(size.width + 2*8), 24);
}


@end
