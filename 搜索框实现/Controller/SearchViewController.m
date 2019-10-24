//
//  SearchViewController.m
//  搜索框实现
//
//  Created by 许明洋 on 2019/9/10.
//  Copyright © 2019 许明洋. All rights reserved.
//

#import "SearchViewController.h"
#import "Masonry.h"
#import "ViewController.h"
#import "SearchLayout.h"
#import "SearchCollectionViewCell.h"
#import "SearchCollectionReusableView.h"
#import "SearchModel.h"
#import "DBTool.h"

@interface SearchViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>

//取消按钮
@property (nonatomic,strong) UIButton *btnCancel;
@property (nonatomic,strong) UICollectionView *searchCollectionView;
@property (nonatomic,strong) UITextField *searchTextField;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *searchDataSource;

//自定义的UICollectionViewFlowLayout
@property (nonatomic,strong) SearchLayout *searchLayout;


@end

NSString *const kHistoryKey = @"kHistoryKey";
const CGFloat kMinimumInteritemSpacing = 10;
const CGFloat kFirstitemleftSpace = 20;

@implementation SearchViewController

#pragma mark - 懒加载各个控件

- (UITextField *)searchTextField {
    
    if (_searchTextField == nil) {
        _searchTextField = [[UITextField alloc] init];
        _searchTextField.placeholder = @"宝贝";
        [_searchTextField setTextColor:[UIColor blackColor]];
        [_searchTextField setFont:[UIFont systemFontOfSize:13]];
        _searchTextField.backgroundColor = [UIColor whiteColor];
        
        //设置光标到左边内容的距离
        _searchTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 14, 0)];
        _searchTextField.leftViewMode = UITextFieldViewModeAlways;
        
        [self.view addSubview:_searchTextField];
        
    }
    return _searchTextField;
}

- (UIButton *)btnCancel {
    if (_btnCancel == nil) {
        _btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        _btnCancel.titleLabel.font = [UIFont systemFontOfSize:14];
        [_btnCancel addTarget:self action:@selector(btnCancelClick) forControlEvents:UIControlEventTouchUpInside];
        _btnCancel.frame = CGRectZero;
        [self.view addSubview:_btnCancel];
    }
    return _btnCancel;
}

- (UICollectionView *)searchCollectionView {
    
    if (_searchCollectionView == nil) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        //设置滚动方向为垂直滚动，说明方块是从坐上到右下的布局方式
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _searchCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        
        _searchCollectionView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:_searchCollectionView];
    }
    return _searchCollectionView;
}

//懒加载自定义的UICollectionViewFlowLayout
- (SearchLayout *)searchLayout {
    if (_searchLayout == nil) {
        _searchLayout = [[SearchLayout alloc] init];
        _searchLayout.headerReferenceSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 30);
        _searchLayout.minimumLineSpacing = kMinimumInteritemSpacing;
        _searchLayout.minimumInteritemSpacing = kMinimumInteritemSpacing;
        _searchLayout.listItemSpace = kMinimumInteritemSpacing;
        _searchLayout.sectionInset = UIEdgeInsetsMake(20, kFirstitemleftSpace, 0, kFirstitemleftSpace);
    }
    return _searchLayout;
}

- (NSMutableArray *)dataSource {
    
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)searchDataSource {
    
    if (_searchDataSource == nil) {
        _searchDataSource = [NSMutableArray array];
    }
    return _searchDataSource;
}


#pragma mark - 初始化界面
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self setUpdata];
}

- (void)initView {
    
    //将导航栏隐藏
    self.navigationController.navigationBar.hidden = YES;
    //设置UITextField的位置
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view).offset(44);
        make.left.equalTo(self.view).offset(14);
        make.height.equalTo(@30);
        make.width.equalTo(@299);
    }];
    
    //设置btnCancel的位置
    [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view).offset(44);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.equalTo(@30);
        make.width.equalTo(@65);
    }];
    
    //设置searchCollectionView的位置
    [self.searchCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.searchTextField.mas_bottom).offset(5);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    self.searchCollectionView.alwaysBounceVertical = YES;
    self.searchCollectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    self.searchCollectionView.delegate = self;
    self.searchCollectionView.dataSource = self;
    self.searchTextField.delegate = self;
    
    [self.searchCollectionView setCollectionViewLayout:self.searchLayout animated:YES];
    //注册UICollectionViewCell
    [self.searchCollectionView registerClass:[SearchCollectionViewCell class] forCellWithReuseIdentifier:@"SearchCollectionViewCell"];
    [self.searchCollectionView registerClass:[SearchCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SearchCollectionHeaderView"];
}

- (void)setUpdata {
    
    NSArray *datas = @[@"化妆棉",@"面膜",@"口红",@"眼霜",@"洗面奶",@"防盗霜",@"补水",@"香水",@"眉笔",@"旅游"];
    [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SearchModel *searchModel = [[SearchModel alloc] initWithName:obj searchId:[NSString stringWithFormat:@"%lu",idx + 1]];
        [self.dataSource addObject:searchModel];
    }];
    //去数据库取数据
    NSArray *dbDatas = [DBTool statusesWithKey:kHistoryKey];
    if (dbDatas.count > 0) {
        [self.searchDataSource setArray:dbDatas];
    }
}

//"取消按钮的点击事件"
- (void)btnCancelClick {
    
    //点击取消返回之前的页面
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.dataSource.count;
    } else if (section == 1) {
        return self.searchDataSource.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"SearchCollectionViewCell" forIndexPath:indexPath];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.searchDataSource.count > 0) {
        return 2;
    }
    return 1;
}



//在将cell添加之前调用该方法
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    SearchCollectionViewCell *searchCollectionViewCell = (SearchCollectionViewCell *)cell;
    SearchModel *searchModel;
    if (section == 0) {
        searchModel = self.dataSource[item];
    } else if (section == 1) {
        searchModel = self.searchDataSource[item];
    }
    searchCollectionViewCell.text = searchModel.content;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *resuableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        SearchCollectionReusableView *searchCollectionReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"SearchCollectionHeaderView" forIndexPath:indexPath];
        //searchCollectionReusableView.delegate = self;
        
        //在这里实现清除数据的block
        searchCollectionReusableView.deleteDatas = ^(UICollectionReusableView * _Nonnull view) {
            [self.searchDataSource removeAllObjects];
            [self.searchCollectionView reloadData];
            [DBTool saveStatuses:@[] key:kHistoryKey];
        };
        
        if (indexPath.section == 0) {
            searchCollectionReusableView.text = @"热搜";
            searchCollectionReusableView.imageName = @"cool_icon";
            searchCollectionReusableView.hidenDeleteBtn = YES;
        } else if (indexPath.section == 1) {
            searchCollectionReusableView.text = @"历史记录";
            searchCollectionReusableView.imageName = @"search_icon";
            searchCollectionReusableView.hidenDeleteBtn = NO;
        }
        resuableView = searchCollectionReusableView;
    }
    return resuableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    if (section == 0) {
        SearchModel *searchModel = self.dataSource[item];
        return [SearchCollectionViewCell getSizeWithText:searchModel.content];
    } else if (section == 1) {
        SearchModel *searchModel = self.searchDataSource[item];
        return [SearchCollectionViewCell getSizeWithText:searchModel.content];
    }
    
    return CGSizeMake(80, 24);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    SearchModel *searchModel;
    if (section == 0) {
        searchModel = self.dataSource[item];
    } else if (section == 1) {
        searchModel = self.searchDataSource[item];
    }
    [self showAlertWithTitle:[NSString stringWithFormat:@"您该去搜索 %@的内容",searchModel.content]];
}

//这里为什么要设置返回值
- (UIAlertController *)showAlertWithTitle:(NSString *)title {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil]];
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
    return alertController;
}

#pragma mark - textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        return NO;
    }
    
    /*每搜索一次，就会存放一次到历史记录，但是不存重复的*/
    __block BOOL isExist = NO;
    [self.searchDataSource enumerateObjectsUsingBlock:^(SearchModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([textField.text isEqualToString:obj.content]) {
            
            isExist = YES;
            *stop = YES;
        }
    }];
    [self.dataSource enumerateObjectsUsingBlock:^(SearchModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([textField.text isEqualToString:obj.content]) {
            
            isExist = YES;
            *stop = YES;
        }
    }];
    
    if (!isExist) {
        [self reloadData:textField.text];
    }
    return isExist;
}

- (void)reloadData:(NSString *)textString {
    
    SearchModel *searchModel = [[SearchModel alloc] initWithName:textString searchId:@""];
    [self.searchDataSource addObject:searchModel];
    
    //存数据,先将数据库中存有的这个删除，再将这个最新的存放进去
    [DBTool saveStatuses:[self.searchDataSource copy] key:kHistoryKey];
    [self.searchCollectionView reloadData];
    //搜索之后将文本框置为空
    self.searchTextField.text = @"";
}

//#pragma mark - UICollectionReusableViewButtonDelegate
//- (void)deleteDatas:(UICollectionReusableView *)view {
//    
//    [self.searchDataSource removeAllObjects];
//    [self.searchCollectionView reloadData];
//    [DBTool saveStatuses:@[] key:kHistoryKey];
//}

@end
