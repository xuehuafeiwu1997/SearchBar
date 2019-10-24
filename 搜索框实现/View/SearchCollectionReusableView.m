//
//  SearchCollectionReusableView.m
//  搜索框实现
//
//  Created by 许明洋 on 2019/9/11.
//  Copyright © 2019 许明洋. All rights reserved.
//

#import "SearchCollectionReusableView.h"

@interface SearchCollectionReusableView()


@property (nonatomic,weak) UILabel *textLabel;
@property (nonatomic,weak) UIImageView *imageView;
@property (nonatomic,weak) UIButton *deleteButton;

@end

@implementation SearchCollectionReusableView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(18.0f, (self.frame.size.height - 18.0f / 2), 18, 18)];
    [self addSubview:imageView];
    self.imageView = imageView;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(18 + 5.0f + 18, (self.frame.size.height - 18.0f / 2), 100.f, 18)];
    label.textColor = [UIColor colorWithWhite:0.294 alpha:1.000];
    label.font = [UIFont systemFontOfSize:15.0f];
    [self addSubview:label];
    self.textLabel = label;
    
    UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 65 - 18, self.frame.size.height - 30.0f / 2, 65, 30)];
    [deleteButton setTitleColor:[UIColor colorWithWhite:0.498 alpha:1.000] forState:UIControlStateNormal];
    [deleteButton setContentEdgeInsets:UIEdgeInsetsMake(0, 35, 0, 0)];
    [deleteButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [deleteButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [deleteButton setTitle:@"清空" forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteButton];
    self.deleteButton = deleteButton;
}

- (void)deleteClick {

    //调用deleteDatas这个block。
    self.deleteDatas(self);
//    //点击清除按钮，代理回调
//    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteDatas:)]) {
//        [self.delegate deleteDatas:self];
//    }
    
}

#pragma mark - 重写get方法
- (void)setText:(NSString *)text {
    _text = [text copy];
    
    //这里有问题，因为定义的textLabel属性为weak属性
    self.textLabel.text = text;
}

- (void)setHidenDeleteBtn:(BOOL)hidenDeleteBtn {
    _hidenDeleteBtn = hidenDeleteBtn;
    self.deleteButton.hidden = hidenDeleteBtn;
}

- (void)setImageName:(NSString *)imageName {
    _imageName = [imageName copy];
    [self.imageView setImage:[UIImage imageNamed:imageName]];
}
@end
