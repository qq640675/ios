//
//  YLEPPickerController.m
//  pickerViewDemo
//
//  Created by zhou last on 2018/7/4.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLEPPickerController.h"
#import "YLBasicView.h"
#import "YLNetworkInterface.h"
#import "YLUserDefault.h"
#import "anchorChargeSetupHandle.h"
#import "DefineConstants.h"

#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define IColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define EPHeight 40
@interface YLEPPickerController ()<UIPickerViewDataSource,UIPickerViewDelegate>{
    
    NSMutableArray *weightArray; //体重
    NSMutableArray *ageArray; //年龄
    NSMutableArray *heightArray; //身高
//    NSArray *xingzuoArray; //星座
    NSArray *hunYinArray;
    NSMutableArray *cityArray;   //所在城市
    NSArray *firstimageLabelArray; //形象标签
    NSArray *secondimageLabelArray; //形象标签
    NSMutableArray *videoChatArray;//视频聊天
    NSMutableArray *textChatArray;//文字聊天
    NSMutableArray *seePhoneArray;//查看手机号
    NSMutableArray *seeWeiXinArray;//查看微信号
    NSMutableArray *cpsListArray;//cps提成方式
    
    NSArray *professionArray; //职业
    
    int defaultRow;
    
    UIView *keyWindowView;
    UIView *whiteView;
    
    NSString *chooseFinishStr;
    NSDictionary *allCityInfo;
    
    NSString *firstImageStr;
    NSString *secondImageStr;
    
    NSString *province;
    NSString *area;
    NSInteger selectRow;
    
    YLEditPersonalType type;
    YLPickerFinish pickerBlock;
}



@property (strong, nonatomic) UIPickerView *pickerView;

@end

@implementation YLEPPickerController

- (void)viewDidLoad {
    [super viewDidLoad];



}


+ (id)shareInstance
{
    static YLEPPickerController *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [YLEPPickerController new];
        
    });
    return instance;
}


#pragma mark ---- customUI
- (void)customUI
{
    [self pickerSet];
    
    firstimageLabelArray = @[@"情感专家",@"清纯淑女",@"宅男女神",@"邻家小妹",@"长发飘逸",@"完美身材",@"气质美女",@"声音迷人",@"丝袜美腿",@"温柔可爱"];
    secondimageLabelArray = @[@"妩媚性感",@"清纯萝莉",@"时尚御姐",@"制服诱惑",@"学生妹",@"二次元",@"萌妹子",@"女汉子",@"小蛮腰",@"大长腿"];
//    xingzuoArray = @[@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"新游山",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"魔蝎座",@"水瓶座",@"双鱼座"];
    hunYinArray = @[@"保密", @"未婚", @"已婚"];
    professionArray = @[@"网红",@"模特",@"白领",@"护士",@"空姐",@"学生",@"健身教练",@"医生",@"客服",@"其他"];
 
    heightArray = [NSMutableArray array];
    for (int heigtIndex = 100; heigtIndex <= 199; heigtIndex ++) {
        [heightArray addObject:[NSString stringWithFormat:@"%d",heigtIndex]];
    }
    
    weightArray = [NSMutableArray array];
    for (int weightIndex = 30; weightIndex <= 80; weightIndex ++) {
        [weightArray addObject:[NSString stringWithFormat:@"%d",weightIndex]];
    }
    ageArray = [NSMutableArray array];
    for (int i = 20; i <=50; i ++) {
        [ageArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
//    self->videoChatArray = [NSMutableArray array];
//    self->textChatArray = [NSMutableArray array];
//    self->seePhoneArray = [NSMutableArray array];
//    [self->seePhoneArray addObject:@"私密(不公开)"];
//    self->seeWeiXinArray = [NSMutableArray array];
//    dispatch_queue_t queue = dispatch_queue_create("获取后台设置数据", DISPATCH_QUEUE_CONCURRENT);
//    //使用异步函数封装三个任务
//    dispatch_async(queue, ^{
//        [YLNetworkInterface getAnthorChargeList:[YLUserDefault userDefault].t_id block:^(NSMutableArray *listArray) {
//            for (anchorChargeSetupHandle *handle in listArray) {
//                if (handle.t_project_type == 5) {
//                    self->videoChatArray = [NSMutableArray array];
//                    [self->videoChatArray addObjectsFromArray:[handle.t_extract_ratio componentsSeparatedByString:@","]];
//                }else if (handle.t_project_type == 6){
//                    self->textChatArray = [NSMutableArray array];
//                    [self->textChatArray addObjectsFromArray:[handle.t_extract_ratio componentsSeparatedByString:@","]];
//                }else if (handle.t_project_type == 7){
//                    self->seePhoneArray = [NSMutableArray array];
//                    [self->seePhoneArray addObject:@"私密(不公开)"];
//                    [self->seePhoneArray addObjectsFromArray:[handle.t_extract_ratio componentsSeparatedByString:@","]];
//                }else if (handle.t_project_type == 8){
//                    self->seeWeiXinArray = [NSMutableArray array];
//                    [self->seeWeiXinArray addObjectsFromArray:[handle.t_extract_ratio componentsSeparatedByString:@","]];
//                }
//            }
//        }];
//    });
    
    cityArray = [NSMutableArray array];
    allCityInfo = [self readLocalFileWithName:@"city"];
    
    cityArray = allCityInfo[@"provinces"];
    province = @"北京市";
    area = @"北京市";
}

- (void)cpsMethodList:(NSMutableArray *)listArray
{
    [self pickerSet];
    
    cpsListArray = [NSMutableArray array];
    cpsListArray = listArray;
}

#pragma mark ---
- (void)pickerSet
{
    [self.pickerView removeFromSuperview];
    [whiteView removeFromSuperview];
    [keyWindowView removeFromSuperview];
    
    keyWindowView = [UIView new];
    keyWindowView.backgroundColor = KBLACKCOLOR;
    keyWindowView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    keyWindowView.alpha = .3;
    [[UIApplication sharedApplication].keyWindow addSubview:keyWindowView];
    
    whiteView = [UIView new];
    whiteView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 260);
    whiteView.backgroundColor = KWHITECOLOR;
    whiteView.userInteractionEnabled = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:whiteView];
    
    UIView *lineView = [YLBasicView createView:IColor(235, 235, 235) alpha:1.];
    lineView.frame = CGRectMake(0, 39, SCREEN_WIDTH, 1);
    [whiteView addSubview:lineView];
    
    UIButton *cancelButton = [YLBasicView createButton:KBLACKCOLOR text:@"取消" backColor:nil cordius:0 font:[UIFont fontWithName:@"Arial" size:15]];
    cancelButton.frame = CGRectMake(0, 0, 60, 40);
    [cancelButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [cancelButton addTarget:self action:@selector(cancelButtonBeClicked:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:cancelButton];
    
    UIButton *okButton = [YLBasicView createButton:IColor(223, 80, 169) text:@"确定" backColor:nil cordius:0 font:[UIFont fontWithName:@"Arial" size:15]];
    okButton.frame = CGRectMake(SCREEN_WIDTH - 60, 0, 60, 40);
    [okButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [okButton addTarget:self action:@selector(okButtonBeClicked:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:okButton];
    
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 220)];
    self.pickerView.backgroundColor = KWHITECOLOR;
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [whiteView addSubview:self.pickerView];
}


- (NSDictionary *)readLocalFileWithName:(NSString *)name {
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}


- (void)cancelButtonBeClicked:(UIButton *)sender
{
    [UIView animateWithDuration:.5 animations:^{
        self->whiteView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 260);
    } completion:^(BOOL finished) {
        [self.pickerView removeFromSuperview];
        [self->whiteView removeFromSuperview];
        [self->keyWindowView removeFromSuperview];
    }];
}

- (void)okButtonBeClicked:(UIButton *)sender
{
    if (type == YLEditPersonalTypeImageLabel) {
        chooseFinishStr = [NSString stringWithFormat:@"%@%@",firstImageStr,secondImageStr];
    }else if (type == YLEditPersonalTypeCity){
        chooseFinishStr = area;
//        if ([province isEqualToString:area]) {
//            chooseFinishStr = province;
//        }else{
//            chooseFinishStr = [NSString stringWithFormat:@"%@ %@",province,area];
//        }
    }
    
    pickerBlock(chooseFinishStr);
    
    [self cancelButtonBeClicked:nil];

    
//    NSMutableArray *tempArr = [NSMutableArray array];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
//    NSDictionary *allCityInfo = [NSDictionary dictionaryWithContentsOfFile:path];
//    for (int i=0; i< allCityInfo.count; i++) {
//        NSDictionary *dic = [allCityInfo valueForKey:[@(i) stringValue]];
//        [tempArr addObject:dic.allKeys[0]];
//    }
}


- (void)reloadPickerViewData:(YLEditPersonalType)Etype block:(YLPickerFinish)block
{
    pickerBlock = block;
    type = Etype;
    selectRow = 0;
    
    NSLog(@"______reloadPickerViewData:%@ %@ %@",videoChatArray,seeWeiXinArray,seePhoneArray);

    [self.pickerView reloadAllComponents];//刷新UIPickerView
    //
    if (type == YLEditPersonalTypeHeight) {
        [_pickerView selectRow:60 inComponent:0 animated:NO];
        chooseFinishStr = @"160 cm";
    }else if (Etype == YLEditPersonalTypeWeight){
        [_pickerView selectRow:10  inComponent:0 animated:NO];
        chooseFinishStr = @"40 kg";
    }else if (Etype == YLEditPersonalTypeAge){
        [_pickerView selectRow:5  inComponent:0 animated:NO];
        chooseFinishStr = @"25 岁";
    }
//    else if (Etype == YLEditPersonalTypeXingZuo){
//        [_pickerView selectRow:0 inComponent:0 animated:NO];
//        chooseFinishStr = @"白羊座";
//    }
    else if (Etype == YLEditPersonalTypeHunyin){
        [_pickerView selectRow:0 inComponent:0 animated:NO];
        chooseFinishStr = @"保密";
    }
    else if (Etype == YLEditPersonalTypeImageLabel){
        [_pickerView selectRow:0 inComponent:0 animated:NO];
        firstImageStr = @"情感专家";
        secondImageStr = @"妩媚性感";
    }else if (Etype == YLEditPersonalTypeProfession){
        [_pickerView selectRow:0 inComponent:0 animated:NO];
        chooseFinishStr = @"网红";
    }else if (Etype == YLEditPersonalTypeCity){
        [_pickerView selectRow:0 inComponent:0 animated:NO];
        [_pickerView selectRow:0 inComponent:1 animated:NO];
    }else if (Etype == YLEditPersonalTypeVideo){
        [_pickerView selectRow:0 inComponent:0 animated:NO];

        if (videoChatArray.count != 0) {
            chooseFinishStr = videoChatArray[0];
        }
    }else if (Etype == YLEditPersonalTypeText){
        [_pickerView selectRow:0 inComponent:0 animated:NO];
        
        if (textChatArray.count != 0) {
            chooseFinishStr = textChatArray[0];
        }
    }else if (Etype == YLEditPersonalTypePhone){
        [_pickerView selectRow:0 inComponent:0 animated:NO];
        
        chooseFinishStr = @"私密(不公开)";
    }else if (Etype == YLEditPersonalTypeWeiXin){
        [_pickerView selectRow:0 inComponent:0 animated:NO];
        
        if (seeWeiXinArray.count != 0) {
            chooseFinishStr = seeWeiXinArray[0];
        }
    }else if (Etype == YLEditPersonalTypeCPS){
        [_pickerView selectRow:0 inComponent:0 animated:NO];

        chooseFinishStr = cpsListArray[0];
    }
    
    [UIView animateWithDuration:.5 animations:^{
        self->whiteView.frame = CGRectMake(0, SCREEN_HEIGHT - 260, SCREEN_WIDTH, 260);
    }];
    
}

//返回有几列

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (type == YLEditPersonalTypeHeight) {
        return 2;
    }else if (type == YLEditPersonalTypeWeight){
        return 2;
    }
    else if (type == YLEditPersonalTypeAge){
        return 2;
    }
//    else if (type == YLEditPersonalTypeXingZuo){
//        return 1;
//    }
    else if (type == YLEditPersonalTypeHunyin){
        return 1;
    }
    else if (type == YLEditPersonalTypeImageLabel){
        return 2;
    }else if (type == YLEditPersonalTypeProfession){
        return 1;
    }else if (type == YLEditPersonalTypeCity){
        return 2;
    }else if (type == YLEditPersonalTypeVideo){
        return 1;
    }else if (type == YLEditPersonalTypeWeiXin){
        return 1;
    }else if (type == YLEditPersonalTypePhone){
        return 1;
    }else if (type == YLEditPersonalTypeText){
        return 1;
    }else if (type == YLEditPersonalTypeCPS){
        return 1;
    }
    
    return 2;
}

//返回指定列的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (type == YLEditPersonalTypeHeight) {
        //身高
        if (component == 0) {
            return heightArray.count;
        }else{
            return 1;
        }
    }else if (type == YLEditPersonalTypeWeight){
        //体重
        if (component == 0) {
            return weightArray.count;
        }else{
            return 1;
        }
    }
    else if (type == YLEditPersonalTypeAge){
        //年龄
        if (component == 0) {
            return ageArray.count;
        }else{
            return 1;
        }
    }
//    else if (type == YLEditPersonalTypeXingZuo){
//        //星座
//        return xingzuoArray.count;
//    }
    else if (type == YLEditPersonalTypeHunyin){
        //星座
        return hunYinArray.count;
    }
    else if(type == YLEditPersonalTypeImageLabel){
        //形象标签
        if (component == 0) {
            return firstimageLabelArray.count;
        }else{
            return secondimageLabelArray.count;
        }
    }else if (type == YLEditPersonalTypeProfession)
    {
        //职业
        return professionArray.count;
    }else if (type == YLEditPersonalTypeCity){
        //城市
        if (component == 0) {
            return cityArray.count;
        }else{
            NSDictionary *dic = cityArray[selectRow];
            
            NSArray *citysArray = dic[@"citys"];

            return citysArray.count;
        }
    }else if (type == YLEditPersonalTypeVideo){
        return videoChatArray.count;
    }else if (type == YLEditPersonalTypeText){
        return textChatArray.count;
    }else if (type == YLEditPersonalTypePhone){
        return seePhoneArray.count;
    }else if (type == YLEditPersonalTypeWeiXin){
        return seeWeiXinArray.count;
    }else if (type == YLEditPersonalTypeCPS){
        return cpsListArray.count;
    }
    
    
    return 0;
}

//返回指定列，行的高度，就是自定义行的高度

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return EPHeight;
}

//返回指定列的宽度

- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    if (type == YLEditPersonalTypeHeight) {
        //身高
        if (component == 0) {
            return 80;
        }else{
            return 60;
        }
    }else if (type == YLEditPersonalTypeWeight || type == YLEditPersonalTypeAge){
        //体重
        if (component == 0) {
            return 80;
        }else{
            return 60;
        }
    }
//    else if (type == YLEditPersonalTypeXingZuo){
//        //星座
//        return SCREEN_WIDTH;
//    }
    else if (type == YLEditPersonalTypeHunyin){
        //星座
        return SCREEN_WIDTH;
    }
    else if(type == YLEditPersonalTypeImageLabel){
        //形象标签
        if (component == 0) {
            return 80;
        }else{
            return 80;
        }
    }else if (type == YLEditPersonalTypeProfession)
    {
        return SCREEN_WIDTH;
    }else if (type == YLEditPersonalTypeCity){
        if (component == 0) {
            return 80;
        }else{
            return 80;
        }
    }else if (type == YLEditPersonalTypeVideo){
        return SCREEN_WIDTH;
    }else if (type == YLEditPersonalTypeWeiXin){
        return SCREEN_WIDTH;
    }else if (type == YLEditPersonalTypePhone){
        return SCREEN_WIDTH;
    }else if (type == YLEditPersonalTypeText){
        return SCREEN_WIDTH;
    }else if (type == YLEditPersonalTypeCPS){
        return SCREEN_WIDTH;
    }
    
    
    return  SCREEN_WIDTH/2.;
}



// 自定义指定列的每行的视图，即指定列的每行的视图行为一致

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    if (!view){
        
        view = [[UIView alloc]init];
        
    }
    
    UILabel *text = [UILabel new];
    text.textAlignment = NSTextAlignmentCenter;
    text.font = [UIFont systemFontOfSize:18];
    
    
    if (type == YLEditPersonalTypeHeight) {
        //身高
        if (component == 0) {
            text.frame = CGRectMake(20, 0, 80, EPHeight);
            
            text.text = heightArray[row];
        }else{
            text.frame = CGRectMake(0, 0, 40, EPHeight);
            
            text.text = @"cm";
        }
    }else if (type == YLEditPersonalTypeWeight){
        //体重
        if (component == 0) {
            text.text = weightArray[row];
            text.frame = CGRectMake(20, 0, 80, EPHeight);
        }else{
            text.frame = CGRectMake(0, 0, 40, EPHeight);
            
            text.text = @"kg";
        }
    }else if (type == YLEditPersonalTypeAge){
        //年龄
        if (component == 0) {
            text.text = ageArray[row];
            text.frame = CGRectMake(20, 0, 80, EPHeight);
        }else{
            text.frame = CGRectMake(0, 0, 40, EPHeight);
            
            text.text = @"岁";
        }
    }
//    else if (type == YLEditPersonalTypeXingZuo){
//        //星座
//        text.frame = CGRectMake(0, 0, SCREEN_WIDTH, EPHeight);
//
//        text.text = xingzuoArray[row];
//    }
    else if (type == YLEditPersonalTypeHunyin){
        //星座
        text.frame = CGRectMake(0, 0, SCREEN_WIDTH, EPHeight);
        
        text.text = hunYinArray[row];
    }
    else if(type == YLEditPersonalTypeImageLabel){
        //形象标签
        
        if (component == 0) {
            text.text = firstimageLabelArray[row];
            text.frame = CGRectMake(0, 0, 80, EPHeight);
        }else{
            text.frame = CGRectMake(0, 0, 80, EPHeight);
            text.text = secondimageLabelArray[row];
        }
    }else if (type == YLEditPersonalTypeProfession)
    {
        //职业
        text.frame = CGRectMake(0, 0, SCREEN_WIDTH, EPHeight);
        
        text.text = professionArray[row];
    }else if (type == YLEditPersonalTypeCity){
        //城市
        if (component == 0) {
            NSDictionary *dic = cityArray[row];
            text.text = dic[@"name"];
            text.frame = CGRectMake(0, 0, 80, EPHeight);
        }else{
            text.frame = CGRectMake(0, 0, 80, EPHeight);
            
            NSDictionary *dic = cityArray[selectRow];
            
            NSArray *citysArray = dic[@"citys"];
            text.text = citysArray[row];
        }
    }else if (type == YLEditPersonalTypeVideo){
        //视频聊天
        text.frame = CGRectMake(0, 0, SCREEN_WIDTH, EPHeight);
        
        text.text = videoChatArray[row];
    }else if (type == YLEditPersonalTypeText){
        //文字聊天
        text.frame = CGRectMake(0, 0, SCREEN_WIDTH, EPHeight);
        
        text.text = textChatArray[row];
    }else if (type == YLEditPersonalTypePhone){
        //查看手机号
        text.frame = CGRectMake(0, 0, SCREEN_WIDTH, EPHeight);
        
        text.text = seePhoneArray[row];
    }else if (type == YLEditPersonalTypeWeiXin){
        //查看微信号
        text.frame = CGRectMake(0, 0, SCREEN_WIDTH, EPHeight);
        
        text.text = seeWeiXinArray[row];
    }else if (type == YLEditPersonalTypeCPS){
        text.frame = CGRectMake(0, 0, SCREEN_WIDTH, EPHeight);
        
        text.text = [cpsListArray[row] componentsSeparatedByString:@","][1];
    }
    
    [view addSubview:text];
    
    //隐藏上下直线
    
    //    　　[self.pickerView.subviews objectAtIndex:1].backgroundColor = KCLEARCOLOR;
    //
    //    [self.pickerView.subviews objectAtIndex:2].backgroundColor = KCLEARCOLOR;
    
    return view;
    
}

//显示的标题

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
//
//    NSString *str = [_nameArray objectAtIndex:row];
//    NSLog(@"_______22:%@",str);
//
//    return str;
//
//}

//显示的标题字体、颜色等属性

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString *str = @"";
    if (type == YLEditPersonalTypeHeight) {
        //身高
        if (component == 0) {
            str = [heightArray objectAtIndex:row];
        }else{
            str = @"cm";
        }
    }else if (type == YLEditPersonalTypeWeight){
        //体重
        if (component == 0) {
            str = [weightArray objectAtIndex:row];
        }else{
            str = @"kg";
        }
    }else if (type == YLEditPersonalTypeAge){
        //年龄
        if (component == 0) {
            str = [ageArray objectAtIndex:row];
        }else{
            str = @"岁";
        }
    }
//    else if (type == YLEditPersonalTypeXingZuo){
//        //星座
//        str = xingzuoArray[row];
//    }
    else if (type == YLEditPersonalTypeHunyin){
        //星座
        str = hunYinArray[row];
    }
    else if(type == YLEditPersonalTypeImageLabel){
        //形象标签
        if (component == 0) {
            str = firstimageLabelArray[row];

        }else{
            str = secondimageLabelArray[row];

        }
    }else if (type == YLEditPersonalTypeProfession)
    {
        str = professionArray[row];
    }else if (type == YLEditPersonalTypeCity){
        //城市
        if (component == 0) {
            str = cityArray[row];
        }else{
            NSDictionary *dic = cityArray[selectRow];
            NSArray *citysArray = dic[@"citys"];
            
            str = citysArray[0];
        }
    }else if (type == YLEditPersonalTypeVideo){
        //视频聊天
        str = videoChatArray[row];
    }else if (type == YLEditPersonalTypeText){
        //文字聊天
        str = textChatArray[row];
    }else if (type == YLEditPersonalTypePhone){
        //查看手机号
        str = seePhoneArray[row];
    }else if (type == YLEditPersonalTypeWeiXin){
        //查看微信号
        str = seeWeiXinArray[row];
    }else if(type == YLEditPersonalTypeCPS){
        str = [cpsListArray[row]componentsSeparatedByString:@","][1];
    }
    
    NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc]initWithString:str];
    [AttributedString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName:KWHITECOLOR} range:NSMakeRange(0, [AttributedString  length])];
    
    return AttributedString;
    
}//NS_AVAILABLE_IOS(6_0);

//被选择的行
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0) {
        selectRow = row;
    }
    
    if (type == YLEditPersonalTypeHeight) {
        if (component == 0) {
            chooseFinishStr = [NSString stringWithFormat:@"%@ cm",heightArray[row]];
        }
    }else if (type == YLEditPersonalTypeWeight){
        if (component == 0) {
            chooseFinishStr = [NSString stringWithFormat:@"%@ kg",weightArray[row]];
        }
    }else if (type == YLEditPersonalTypeAge){
        if (component == 0) {
            chooseFinishStr = [NSString stringWithFormat:@"%@ 岁",ageArray[row]];
        }
    }
//    else if (type == YLEditPersonalTypeXingZuo){
//            chooseFinishStr = xingzuoArray[row];
//    }
    else if (type == YLEditPersonalTypeHunyin){
            chooseFinishStr = hunYinArray[row];
    }
    else if (type == YLEditPersonalTypeImageLabel){
        if (component == 0) {
            firstImageStr = firstimageLabelArray[row];
        }   else{
            secondImageStr = secondimageLabelArray[row];
        }
    }else if (type == YLEditPersonalTypeProfession){
        chooseFinishStr = professionArray[row];
    }else if (type == YLEditPersonalTypeCity){
        if (component == 0) {
            province = [cityArray[row] objectForKey:@"name"];
            
            NSDictionary *dic = cityArray[row];

            NSArray *citysArray = dic[@"citys"];
            area = citysArray[0];
           [_pickerView selectRow:0 inComponent:1 animated:NO];
            
        }   else{
            NSDictionary *dic = cityArray[selectRow];
            
            NSArray *citysArray = dic[@"citys"];
            
            
            area = citysArray[row];

        }
        
        [_pickerView reloadAllComponents];
    }else if (type == YLEditPersonalTypeVideo){
        chooseFinishStr = videoChatArray[row];
    }else if (type == YLEditPersonalTypeText){
        chooseFinishStr = textChatArray[row];
    }else if (type == YLEditPersonalTypePhone){
        chooseFinishStr = seePhoneArray[row];
    }else if (type == YLEditPersonalTypeWeiXin){
        chooseFinishStr = seeWeiXinArray[row];
    }else if (type == YLEditPersonalTypeCPS){
        chooseFinishStr = cpsListArray[row];
    }
}

@end
