//
//  YLBasicController.m
//  beijing
//
//  Created by zhou last on 2018/7/26.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLBasicController.h"
#import "YLJsonExtension.h"
#import "YLUserDefault.h"
#import "UIAlertCon+Extension.h"

@interface YLBasicController ()

@end

@implementation YLBasicController

- (void)viewWillAppear:(BOOL)animated
{
    if ([YLUserDefault userDefault].t_id == 0) {
        return;
    }
    
}



- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
