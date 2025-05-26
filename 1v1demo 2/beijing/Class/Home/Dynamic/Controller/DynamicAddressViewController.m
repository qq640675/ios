//
//  DynamicAddressViewController.m
//  beijing
//
//  Created by yiliaogao on 2019/1/5.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "DynamicAddressViewController.h"

#import "DynamicAddressNavigationView.h"
#import "DynamicAddressSearchView.h"
#import "YLAMapLocationManager.h"


@interface DynamicAddressViewController ()
<
DynamicAddressNavigationViewDelegate,
DynamicAddressSearchViewDelegate
>

@property (nonatomic, strong) DynamicAddressSearchView  *searchView;

@property (nonatomic, strong) DynamicAddressListModel   *selectdModel;

@property (nonatomic, strong) UIView        *blackView;

@property (nonatomic, strong) CLLocation    *curLocation;

@property (nonatomic, copy) NSString    *curCity;

@property (nonatomic, strong) NSMutableArray    *aroundAddressArray;

@property (nonatomic, assign) BOOL      isSearch;

@property (nonatomic, assign) BOOL      isClickedSearchViewCancel;

@end

@implementation DynamicAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self setupUI];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupUI {
    
    self.view.backgroundColor = [UIColor redColor];
    
    [self createTableView];
    
    DynamicAddressNavigationView *navigationView = [[DynamicAddressNavigationView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, SafeAreaTopHeight)];
    navigationView.delegate = self;
    [self.view addSubview:navigationView];
    
    [self.view addSubview:self.blackView];
    _blackView.hidden = YES;
}

- (void)initTableDatasource {
    
    self.dataSource = [[DynamicAddressTableViewDataSource alloc] initWithCellBlock:nil];
    
    self.baseTableView.dataSource = self.dataSource;
    self.baseTableView.tableFooterView = [UIView new];
    
    [self setupTableFrame];
    
}

- (void)setupTableFrame {

    if (@available(iOS 11.0, *)) {
        self.baseTableView.y = 0;
        self.baseTableView.height = APP_Frame_Height;
    } else {
        self.baseTableView.y = SafeAreaTopHeight;
        self.baseTableView.height = APP_Frame_Height-SafeAreaTopHeight;
    }
    
    
    [self performSelector:@selector(initWithTableViewData) withObject:nil afterDelay:.4];
}

- (void)updateTableFrame {
    [UIView animateWithDuration:.3 animations:^{
        if (self.isClickedSearchViewCancel) {
            self.view.y = 0;
            self.view.height = APP_Frame_Height;
            self.searchView.searchTextField.width = App_Frame_Width-20;
            if (@available(iOS 11.0, *)) {
                self.baseTableView.height = APP_Frame_Height;
            } else {
                self.baseTableView.height = APP_Frame_Height-SafeAreaTopHeight;
            }
            

        }
    }];
    _blackView.hidden = YES;
}

- (void)initWithTableViewData {
    
    self.dataSource.sections = [NSMutableArray new];
    SLTableViewSectionModel *secModel = [SLTableViewSectionModel new];
    [self.dataSource.sections addObject:secModel];
    
    //默认第一行
    DynamicAddressListModel *noModel = [DynamicAddressListModel new];
    noModel.name = @"不显示位置";
    noModel.isNoLocation = YES;
    noModel.isSelected = YES;
    self.selectdModel  = noModel;
    [secModel.listModels addObject:noModel];
    
    [self.baseTableView reloadData];
    
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    [[YLAMapLocationManager shareInstance] startLocation:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        self.curLocation = location;
        self.curCity = regeocode.city;
        if (self.curCity.length == 0) {
            self.curCity = regeocode.province;
        }
        
        if (![self.selectedAddressListModel.name isEqualToString:self.curCity]) {
            //当前城市
            DynamicAddressListModel *cityModel = [DynamicAddressListModel new];
            cityModel.name = self.curCity;
            cityModel.isCity = YES;
            [secModel.listModels addObject:cityModel];
        }
        
        //之前选中的地址
        if (self.selectedAddressListModel) {
            noModel.isSelected = NO;
            self.selectdModel = self.selectedAddressListModel;
            [secModel.listModels addObject:self.selectedAddressListModel];
        } else {
            self.selectdModel = noModel;
        }
        [self.baseTableView reloadData];
        
        [[YLAMapPOIManager shareInstance] searchAroundPOI:self.curLocation searchBlock:^(NSArray<AMapPOI *> *pois) {
            [SVProgressHUD dismiss];
            for (int i = 0; i < [pois count]; i++) {
                AMapPOI *poi = pois[i];
                if (![poi.name isEqualToString:self.selectedAddressListModel.name]) {
                    DynamicAddressListModel *model = [DynamicAddressListModel new];
                    model.name = poi.name;
                    model.address = poi.address;
                    [secModel.listModels addObject:model];
                }
            }
            [self.baseTableView reloadData];
        }];
        
    }];
    
}

#pragma mark -- Delegate
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.searchView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return self.searchView.height;
}


- (void)clickedTableCell:(SLBaseListModel *)listModel {
    DynamicAddressListModel *model = (DynamicAddressListModel *)listModel;
    _selectdModel.isSelected = NO;
    model.isSelected = YES;
    _selectdModel = model;
    if (_isSearch) {
        [self finish];
    } else {
        [self.baseTableView reloadData];
    }
}

- (void)didSelectDynamicAddressNavigationViewWithBtn:(NSInteger)tag {
    if (tag == 1) {
        //取消
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        //完成
        [self finish];
    }
}

- (void)didSelectDynamicAddressSearchViewWithCancel {
    _isClickedSearchViewCancel = YES;
    [self.view endEditing:YES];
    
    [self updateTableFrame];
    
    if (_isSearch) {
        SLTableViewSectionModel *secModel = [self.dataSource.sections firstObject];
        [secModel.listModels removeAllObjects];
        [secModel.listModels addObjectsFromArray:_aroundAddressArray];
        [self.baseTableView reloadData];
    }
    _isSearch = NO;
}

- (void)didSelectDynamicAddressSearchViewWithSearch:(NSString *)key {
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    [[YLAMapPOIManager shareInstance] searchPOIWithKey:key city:_curCity location:_curLocation searchBlock:^(NSArray<AMapPOI *> *pois) {
        [SVProgressHUD dismiss];
        if ([pois count] > 0) {
            self.isSearch = YES;
            SLTableViewSectionModel *secModel = [self.dataSource.sections firstObject];
            if (!self.aroundAddressArray) {
                //把之前的地址保存起来
                self.aroundAddressArray = [NSMutableArray arrayWithArray:secModel.listModels];
            }
            
            [secModel.listModels removeAllObjects];
            
            for (int i = 0; i < [pois count]; i++) {
                AMapPOI *poi = pois[i];
                DynamicAddressListModel *model = [DynamicAddressListModel new];
                model.name = poi.name;
                model.address = poi.address;
                [secModel.listModels addObject:model];
            }
            self.blackView.hidden = YES;
            [self.baseTableView reloadData];
        } else {
            [SVProgressHUD showInfoWithStatus:@"暂无结果！"];
        }

    }];
}

- (void)finish {
    if (_DidSelectAddressBlock) {
        
        _DidSelectAddressBlock(_selectdModel,_curCity);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_isSearch) {
        [self.view endEditing:YES];
        
        [self updateTableFrame];
    }
}

#pragma mark - Keyboard notification
- (void)keyboardShow:(NSNotification *)note {
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        if (!self.isSearch) {
            self.view.y = -SafeAreaTopHeight;
            self.searchView.searchTextField.width = App_Frame_Width-80;
        }
    }];
    if (!_isSearch) {
        _blackView.hidden = NO;
    }
    _isClickedSearchViewCancel = NO;
}


- (void)keyboardHide:(NSNotification *)note {
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        if (self.isSearch) {
            self.view.height = APP_Frame_Height+SafeAreaTopHeight;
            self.baseTableView.height = APP_Frame_Height+SafeAreaTopHeight;
        }
    }];
}

- (DynamicAddressSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[DynamicAddressSearchView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 65)];
        _searchView.delegate = self;
    }
    return _searchView;
}

- (UIView *)blackView {
    if (!_blackView) {
        _blackView = [[UIView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight+65, App_Frame_Width, 500)];
        _blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectDynamicAddressSearchViewWithCancel)];
        [_blackView addGestureRecognizer:tap];
    }
    return _blackView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
