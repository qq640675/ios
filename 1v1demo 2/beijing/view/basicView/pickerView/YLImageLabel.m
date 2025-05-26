//
//  YLImageLabel.m
//  pickerViewDemo
//
//  Created by zhou last on 2018/7/5.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLImageLabel.h"
#import "YLBasicView.h"
#import "imageLabelHandle.h"
#import "DefineConstants.h"

#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define IColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
@interface YLImageLabel ()
{
    UIView *keyWindowView;
    UIView *whiteView;
    
    NSArray *imageLabelArray;
    NSMutableArray *buttonArray;
    NSMutableArray *idArray;
    YLImageLabelFinish imgLabelBlock;
}



@end

@implementation YLImageLabel

- (void)viewDidLoad {
    [super viewDidLoad];

}

+ (id)shareInstance
{
    static YLImageLabel *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [YLImageLabel new];
        
    });
    return instance;
}


- (void)imageLabelCustomUI:(NSMutableArray *)listArray
{
    [whiteView removeFromSuperview];
    [keyWindowView removeFromSuperview];
    
    keyWindowView = [UIView new];
    keyWindowView.backgroundColor = KBLACKCOLOR;
    keyWindowView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    keyWindowView.alpha =.3;
    keyWindowView.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:keyWindowView];
    
    int count = 0;
    if (listArray.count % 4 == 0) {
        count = (int)listArray.count / 4;
    }else{
        count = (int)listArray.count / 4 +1;
    }
    
    whiteView = [UIView new];
    whiteView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 40 * (count +1) + 20);
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.userInteractionEnabled = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:whiteView];
    
    
    UIView *lineView = [YLBasicView createView:IColor(235, 235, 235) alpha:1.];
    lineView.frame = CGRectMake(0, 39, SCREEN_WIDTH, 1);
    [whiteView addSubview:lineView];
    
    UIButton *cancelButton = [YLBasicView createButton:KBLACKCOLOR text:@"取消" backColor:nil cordius:0 font:[UIFont fontWithName:@"Arial" size:15]];
    cancelButton.frame = CGRectMake(0, 0, 60, 40);
    [cancelButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [cancelButton addTarget:self action:@selector(imageLabelCancelClicked:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:cancelButton];
    
    UIButton *okButton = [YLBasicView createButton:IColor(223, 80, 169) text:@"确定" backColor:nil cordius:0 font:[UIFont fontWithName:@"Arial" size:15]];
    okButton.frame = CGRectMake(SCREEN_WIDTH - 60, 0, 60, 40);
    [okButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [okButton addTarget:self action:@selector(imageLabelOkClicked:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:okButton];
    
    buttonArray = [NSMutableArray array];
    idArray = [NSMutableArray array];
    imageLabelArray = listArray;
//    imageLabelArray = @[@"情感专家",@"清纯淑女",@"宅男女神",@"邻家小妹",@"长发飘逸",@"完美身材",@"气质美女",@"声音迷人",@"丝袜美腿",@"温柔可爱",@"妩媚性感",@"清纯萝莉",@"时尚御姐",@"制服诱惑",@"学生妹",@"二次元",@"萌妹子",@"女汉子",@"小蛮腰",@"大长腿"];
    
    [self createImageLabel];
}


- (void)createImageLabel
{
    float width = 70;
    float height = 30;
    float x = (SCREEN_WIDTH - 280)/5.;
    float y = 50;
    float blank = (SCREEN_WIDTH -280)/5.;
    for (int j= 0; j< imageLabelArray.count; j++) {
        int page = j / 20;
        
        imageLabelHandle *handle = imageLabelArray[j];
        
        UIButton *imageLButton = [YLBasicView createButton:IColor(38, 38, 38) text:handle.t_label_name backColor:IColor(220, 220, 220) cordius:3. font:[UIFont systemFontOfSize:13]];
        imageLButton.frame = CGRectMake(x, y, width, height);
        imageLButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        imageLButton.tag = j;
        [imageLButton addTarget:self action:@selector(imageButtonBeClicked:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:imageLButton];

     
        if ((j+1) % 4 == 0){
            y += height + 10;
            x = blank +page * SCREEN_WIDTH;
        }else{
            x += width + blank;
        }
    }

}


- (void)imageButtonBeClicked:(UIButton *)sender
{
    if ([sender.backgroundColor isEqual:IColor(220, 80, 169)]) {
        [sender setTitleColor:IColor(38, 38, 38) forState:UIControlStateNormal];
        [sender setBackgroundColor:IColor(220, 220, 220)];
        //取消选中
      
        for (int j= 0; j< buttonArray.count; j++) {
            UIButton *button = buttonArray[j];
            
            if ([button.currentTitle isEqualToString:sender.currentTitle]) {
                [buttonArray removeObjectAtIndex:j];
                [idArray removeObjectAtIndex:j];
            }
        }
    }else{
        imageLabelHandle *handle = imageLabelArray[sender.tag];

        
        [sender setBackgroundColor:IColor(220, 80, 169)];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //选中
        
        if (buttonArray.count < 2) {
            [buttonArray addObject:sender];

            [idArray addObject:[NSString stringWithFormat:@"%@",handle.t_id]];
        }else{
            UIButton *button = buttonArray[0];
            [button setTitleColor:IColor(38, 38, 38) forState:UIControlStateNormal];
            [button setBackgroundColor:IColor(220, 220, 220)];
            
            [buttonArray removeObjectAtIndex:0];
            [idArray removeObjectAtIndex:0];

            [buttonArray addObject:sender];
            [idArray addObject:[NSString stringWithFormat:@"%@",handle.t_id]];
        }
    }
}

- (void)imageLabelCancelClicked:(UIButton *)sender
{
    int count = 0;
    if (imageLabelArray.count % 4 == 0) {
        count = (int)imageLabelArray.count / 4;
    }else{
        count = (int)imageLabelArray.count / 4 +1;
    }
    
    [UIView animateWithDuration:.5 animations:^{
        self->whiteView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 40 * (count +1) + 20);
    } completion:^(BOOL finished) {
        [self->whiteView removeFromSuperview];
        [self->keyWindowView removeFromSuperview];
    }];
}

- (void)imageLabelOkClicked:(UIButton *)sender
{
    
    NSString *tittle = @"";
    NSString *idStr = @"";
    
    for (int index = 0; index < buttonArray.count; index ++) {
        UIButton *button = buttonArray[index];
        imageLabelHandle *handle = imageLabelArray[button.tag];

        if (index == 1) {
            tittle = [tittle stringByAppendingString:[NSString stringWithFormat:@",%@",button.currentTitle]];
            idStr = [idStr stringByAppendingString:[NSString stringWithFormat:@",%@",handle.t_id]];
        }else{
            tittle = [tittle stringByAppendingString:button.currentTitle];
            idStr = [idStr stringByAppendingString:[NSString stringWithFormat:@"%@",handle.t_id]];
        }
    }
    
    if (tittle.length == 0) {
    }else{
        [self imageLabelCancelClicked:nil];

        imgLabelBlock(tittle,idStr);
    }
}


- (void)reloadImageLabel:(YLImageLabelFinish)block
{
    imgLabelBlock = block;
    keyWindowView.hidden = NO;
    
    int count = 0;
    if (imageLabelArray.count % 4 == 0) {
        count = (int)imageLabelArray.count / 4;
    }else{
        count = (int)imageLabelArray.count / 4 +1;
    }
    
    [UIView animateWithDuration:.5 animations:^{
        self->whiteView.frame = CGRectMake(0, SCREEN_HEIGHT - 40 * (count + 1) - 20, SCREEN_WIDTH, 40 * (count +1) + 20);
    }];
}


@end
