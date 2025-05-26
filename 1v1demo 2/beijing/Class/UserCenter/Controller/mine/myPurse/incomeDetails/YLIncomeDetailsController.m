//
//  YLIncomeDetailsController.m
//  beijing
//
//  Created by zhou last on 2018/6/21.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLIncomeDetailsController.h"
#import <Masonry.h>
#import "DefineConstants.h"
#import "PGDatePickManager.h"
#import "YLDetailHistoryController.h"
#import "withdrawalCell.h"
#import "YLNoWithDrawalCell.h"
#import "YLNetworkInterface.h"
#import "YLUserDefault.h"
#import "ZYTimeStamp.h"
#import <SVProgressHUD.h>

@interface YLIncomeDetailsController ()<UITableViewDelegate,UITableViewDataSource,PGDatePickerDelegate>
{
    NSMutableArray *detailListArray;
}


@property (weak, nonatomic) IBOutlet UITableView *detaisTableView;
//时间选择
@property (weak, nonatomic) IBOutlet UIView *datePickerView;
//年
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
//月
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;

//可提现金额
@property (weak, nonatomic) IBOutlet UILabel *putForwardLabel;

@property (weak, nonatomic) IBOutlet UILabel *putforwardDespLabel;

@end

@implementation YLIncomeDetailsController

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self incomeCustomUI];
    
}

#pragma mark ---- customUI
- (void)incomeCustomUI
{
    UITapGestureRecognizer *datePickerTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(datePickerViewTap:)];
    [_datePickerView addGestureRecognizer:datePickerTap];
    
    if (_detailType == YLDetailsTypeIncome) {
        self.putforwardDespLabel.text = @"总收入(金币)";
    }else if (_detailType == YLDetailsTypeRecharge){
        self.putforwardDespLabel.text = @"总充值(金币)";
    }else if (_detailType == YLDetailsTypeSpending){
        self.putforwardDespLabel.text = @"总支出(金币)";
    }else{
        self.putforwardDespLabel.text = @"总提现(元)";
    }
    
    //可提现金额
    self.putForwardLabel.text = [NSString stringWithFormat:@"%d",self.putforward];
    
    NSString *dateStr = [ZYTimeStamp getDateStrFromeTime];
    
    NSArray *dateArray = [dateStr componentsSeparatedByString:@"-"];
    if (dateArray.count >= 2) {
        _yearLabel.text = [NSString stringWithFormat:@"%@年",dateArray[0]];
        _monthLabel.text = dateArray[1];
    }
    
    [self detailRequestApi:[dateArray[0] intValue] month:[dateArray[1] intValue] state:-1 page:1];
}

#pragma mark ---- 请求数据
- (void)detailRequestApi:(int)year month:(int)month state:(int)state page:(int)page
{
    dispatch_queue_t queue = dispatch_queue_create("收入支出充值提现明细", DISPATCH_QUEUE_CONCURRENT);
    //使用异步函数封装三个任务
    dispatch_async(queue, ^{
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic = [NSMutableDictionary dictionaryWithDictionary:@{@"year":[NSNumber numberWithInt:year],@"month":[NSNumber numberWithInt:month],@"page":[NSNumber numberWithInt:page],@"userId":[NSNumber numberWithInt:[YLUserDefault userDefault].t_id],@"queyType":[NSNumber numberWithInt:self.detailType]}];
        
        if (self.detailType == YLDetailsTypeWithdrawal) {
            [dic setValue:[NSNumber numberWithInt:state] forKey:@"state"];
        }
        
        self->detailListArray = [NSMutableArray array];
        [YLNetworkInterface getWalletDetailType:dic block:^(NSMutableArray *listArray) {
            self->detailListArray = listArray;
            
            [self.detaisTableView reloadData];
            
            if (listArray.count == 0) {
                [SVProgressHUD showInfoWithStatus:@"暂无数据"];
            }
        }];
    });
}

#pragma mark ---- 时间选择
- (void)datePickerViewTap:(UITapGestureRecognizer *)tap
{
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.isShadeBackgroud = true;
    datePickManager.style = PGDatePickManagerStyle3;
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerType = PGDatePickerType1;
    datePicker.isHiddenMiddleText = false;
    datePicker.datePickerMode = PGDatePickerModeYearAndMonth;
    datePickManager.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:datePickManager animated:false completion:nil];
}

#pragma mark ---- tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return detailListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [UIView new];
    headView.backgroundColor = KWHITECOLOR;
    
    if (_detailType == YLDetailsTypeWithdrawal) {
        NSArray *array = [NSArray arrayWithObjects:@"全部",@"提现中",@"提现成功",@"提现失败", nil];
        //初始化UISegmentedControl
        UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:array];
        //设置frame
        segment.frame = CGRectMake(15, 0, App_Frame_Width - 30, 30);
        [segment addTarget:self action:@selector(withdrawalChange:) forControlEvents:UIControlEventValueChanged];
        //添加到视图
        [headView addSubview:segment];
    }else{
        //日期
        UILabel *dateLabel = [self createLabel:headView text:@"日期"];
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
        }];
        //收入金额
        NSString *textStr = @"收入";
        if (_detailType == YLDetailsTypeSpending) {
            textStr = @"支出";
        }else if (_detailType == YLDetailsTypeRecharge)
        {
            textStr = @"充值";
        }
        
        UILabel *incomeLabel = [self createLabel:headView text:[NSString stringWithFormat:@"%@金额",textStr]];
        [incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(headView.center);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(30);
        }];
        
        //收入项目
        UILabel *incomeProjectLabel = [self createLabel:headView text:[NSString stringWithFormat:@"%@项目",textStr]];
        [incomeProjectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(App_Frame_Width - 90);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(30);
        }];
    }
    
    return headView;
}

- (UILabel *)createLabel:(UIView *)headView text:(NSString *)text
{
    UILabel *createLabel = [UILabel new];
    createLabel.text = text;
    createLabel.textColor = XZRGB(0x131313);
    createLabel.textAlignment = NSTextAlignmentCenter;
    createLabel.font = PingFangSCFont(15);
    [headView addSubview:createLabel];
    
    return createLabel;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_detailType == YLDetailsTypeWithdrawal) {
        //提现
        withdrawalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"withdrawalCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"withdrawalCell" owner:nil options:nil] firstObject];
        }else{
            //删除cell的所有子视图
            while ([cell.contentView.subviews lastObject] != nil)
            {
                [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        
        incomeDetailHandle *handle = detailListArray[indexPath.row];
        cell.dateLabel.text = [NSString stringWithFormat:@"%d日",[handle.tTime intValue]];
        cell.moneyLabel.text = [NSString stringWithFormat:@"%.2f 元",handle.t_money];
        
        if (handle.t_state == 0) {
            cell.statusLabel.text = @"未审核";
        }else if (handle.t_state == 1){
            cell.statusLabel.text = @"提现成功";
        }else{
            cell.statusLabel.text = @"提现失败";
        }
        
        return cell;
    }else{
        YLNoWithDrawalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YLNoWithDrawalCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"YLNoWithDrawalCell" owner:nil options:nil] firstObject];
        }else{
            //删除cell的所有子视图
            while ([cell.contentView.subviews lastObject] != nil)
            {
                [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        
        incomeDetailHandle *handle = detailListArray[indexPath.row];
        cell.dateLabel.text = [NSString stringWithFormat:@"%d日",[handle.tTime intValue]];
        cell.moneyLabel.text = [NSString stringWithFormat:@"%@金币",handle.totalMoney];
        
        cell.seeDetailButton.tag = 100 + indexPath.row;
        [cell.seeDetailButton addTarget:self action:@selector(seeDetaisTap:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
}

- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents
{
    _yearLabel.text = [NSString stringWithFormat:@"%ld年",(long)dateComponents.year];
    if (dateComponents.month < 10) {
        _monthLabel.text = [NSString stringWithFormat:@"0%ld",(long)dateComponents.month];
    }else{
        _monthLabel.text = [NSString stringWithFormat:@"%ld",(long)dateComponents.month];
    }
    
    [self detailRequestApi:(int)dateComponents.year month:(int)dateComponents.month state:-1 page:1];
}

#pragma mark ---- 提现切换
- (void)withdrawalChange:(UISegmentedControl *)sender
{
    int state = (int)sender.selectedSegmentIndex -1;
    int year = [[_yearLabel.text substringToIndex:([_yearLabel.text length]-1)]intValue];
    int month = [_monthLabel.text intValue];
 
    [self detailRequestApi:year month:month state:state page:1];
}

#pragma mark ---- 查看详情
- (void)seeDetaisTap:(UIButton *)sender
{
    int tag = (int)sender.tag - 100;
    incomeDetailHandle *handle = detailListArray[tag];
    
    NSString *day = [NSString stringWithFormat:@"%02d",[handle.tTime intValue]];
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@",[_yearLabel.text stringByReplacingOccurrencesOfString:@"年"withString:@""],_monthLabel.text,day];
    
    YLDetailHistoryController *detailHistoryVC = [YLDetailHistoryController new];
    detailHistoryVC.title = @"收入明细";
    detailHistoryVC.searchType = _detailType;
    detailHistoryVC.time = dateStr;
    [self.navigationController pushViewController:detailHistoryVC animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
