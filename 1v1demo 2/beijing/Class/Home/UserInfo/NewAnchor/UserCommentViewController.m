//
//  UserCommentViewController.m
//  beijing
//
//  Created by 黎 涛 on 2021/4/13.
//  Copyright © 2021 zhou last. All rights reserved.
//

#import "UserCommentViewController.h"

@interface UserCommentViewController ()
{
    NSArray *commentList;
}

@end

@implementation UserCommentViewController

#pragma mark - vc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"用户印象";
    [self requestComment];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - net
- (void)requestComment {
    [SVProgressHUD show];
    [YLNetworkInterface getNewEvaluationListWithId:self.anthorId Success:^(NSArray *dataArr) {
        self->commentList = dataArr;
        [self setSubViews];
    }];
}

#pragma mark - subViews
- (void)setSubViews {
    
    CGRect lastFrame = CGRectMake(5, 15+SafeAreaTopHeight, 0, 0);
    for (int i = 0; i < commentList.count; i ++) {
        NSDictionary *dic = commentList[i];
        NSString *text = [NSString stringWithFormat:@"%@(%@)", dic[@"t_label_name"], dic[@"evaluationCount"]];
        CGFloat width = [ToolManager getWidthWithText:text font:[UIFont systemFontOfSize:15]]+15;
        CGFloat x = lastFrame.origin.x + lastFrame.size.width + 10;
        CGFloat y = lastFrame.origin.y;
        if (x+width+15 > App_Frame_Width) {
            x = 15;
            y = lastFrame.origin.y + 40;
        }
        UILabel *label = [UIManager initWithLabel:CGRectMake(x, y, width, 30) text:text font:15 textColor:XZRGB(0x868686)];
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 4;
        label.layer.borderWidth = 1;
        label.layer.borderColor = XZRGB(0xf1f1f1).CGColor;
        [self.view addSubview:label];
        lastFrame = label.frame;
    }
}



@end
