//
//  SLPickerViewController.m
//  beijing
//
//  Created by yiliaogao on 2019/1/2.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "SLPickerViewController.h"
#import "UIManager.h"

@interface SLPickerViewController ()

<
UIPickerViewDelegate,
UIPickerViewDataSource
>



@end

@implementation SLPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)setupUI {
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4];
    
    [self.view addSubview:self.pickerView];
    
    UIView *actionView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-212, self.view.frame.size.width, 50)];
    actionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:actionView];
    
    UIButton *cancelBtn = [UIManager initWithButton:CGRectMake(0, 0, 60, 50) text:@"取消" font:14.0f textColor:XZRGB(0x868686) normalImg:nil highImg:nil selectedImg:nil];
    [cancelBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.tag = SLPickerViewBtnType_Cancel;
    [actionView addSubview:cancelBtn];
    
    UIButton *sureBtn = [UIManager initWithButton:CGRectMake(self.view.frame.size.width-60, 0, 60, 50) text:@"确定" font:14.0f textColor:XZRGB(0xAE4FFD) normalImg:nil highImg:nil selectedImg:nil];
    [sureBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.tag = SLPickerViewBtnType_Sure;
    [actionView addSubview:sureBtn];
 
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, self.view.frame.size.width, .5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [actionView addSubview:lineView];
}

- (void)clickedBtn:(UIButton *)btn {
    if (btn.tag == SLPickerViewBtnType_Cancel) {
        //取消
        if (_delegate && [_delegate respondsToSelector:@selector(didSLPickerViewControllerCancelBtn)]) {
            [_delegate didSLPickerViewControllerCancelBtn];
        }
    } else {
        //确定
        if (_delegate && [_delegate respondsToSelector:@selector(didSLPickerViewControllerSureBtn:)]) {
            [_delegate didSLPickerViewControllerSureBtn:_selectedRow];
        }
    }
}

- (void)setPickerDataArray:(NSArray *)pickerDataArray {
    _pickerDataArray = pickerDataArray;
    
    [_pickerView reloadAllComponents];
}

#pragma mark pickerview function

//返回有几列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

//返回指定列的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_pickerDataArray count];
}

//返回指定列，行的高度，就是自定义行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40.0f;
}

//返回指定列的宽度
- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return self.view.frame.size.width;
}

// 自定义指定列的每行的视图，即指定列的每行的视图行为一致
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    if (!view) {
        view = [[UIView alloc]init];
    }
    
    UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    text.textAlignment = NSTextAlignmentCenter;
    text.textColor = XZRGB(0x333333);
    NSString *title= _pickerDataArray[row];
    if (_pickerDataUnit.length == 0 || [title isEqualToString:@"私密(不公开)"]) {
        
        text.text = [NSString stringWithFormat:@"%@",_pickerDataArray[row]];
    } else {
        text.text = [NSString stringWithFormat:@"%@%@",title,_pickerDataUnit];
    }
    
    text.font = PingFangSCFont(17.0f);
    [view addSubview:text];
    
    //隐藏上下直线
//    [self.pickerView.subviews objectAtIndex:1].backgroundColor = [UIColor clearColor];
//    [self.pickerView.subviews objectAtIndex:2].backgroundColor = [UIColor clearColor];
    return view;
    
}

//显示的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *str = [_pickerDataArray objectAtIndex:row];
    
    return str;
    
}

//显示的标题字体、颜色等属性

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString *str = [_pickerDataArray objectAtIndex:row];
    NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc]initWithString:str];
    [AttributedString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(0, [AttributedString  length])];
    
    return AttributedString;
    
}

//被选择的行
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _selectedRow = row;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-162, [UIScreen mainScreen].bounds.size.width, 162)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
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
