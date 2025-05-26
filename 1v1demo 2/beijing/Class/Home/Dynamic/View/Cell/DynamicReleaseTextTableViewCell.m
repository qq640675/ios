//
//  DynamicReleaseTextTableViewCell.m
//  beijing
//
//  Created by yiliaogao on 2018/12/26.
//  Copyright © 2018 zhou last. All rights reserved.
//

#import "DynamicReleaseTextTableViewCell.h"

@implementation DynamicReleaseTextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self.contentView addSubview:self.contentTextView];
}

- (void)initWithData:(SLBaseListModel *)listModel {
    self.textModel = (DynamicReleaseTextModel *)listModel;
}

+ (CGFloat)cellHeight:(SLBaseListModel *)listModel {
    return 120;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    _textModel.content = textView.text;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //第三方换行
    if ([@"\r\r" isEqualToString:text]) {
        return NO;
    }
    //系统换行
    if ([@"\n" isEqualToString:text]) {
        [self endEditing:YES];
        return NO;
    }
    return YES;
}

- (SLPlaceHolderTextView *)contentTextView {
    if (!_contentTextView) {
        _contentTextView = [[SLPlaceHolderTextView alloc] initWithFrame:CGRectMake(10, 10, App_Frame_Width-20, 100)];
        _contentTextView.placeholder = @"此时此刻，想和大家分享什么呢～";
        _contentTextView.placeholderColor = XZRGB(0x868686);
        _contentTextView.font = PingFangSCFont(15.0f);
        _contentTextView.textColor = XZRGB(0x868686);
        _contentTextView.returnKeyType = UIReturnKeyDone;
        _contentTextView.delegate = self;
    }
    return _contentTextView;
}

@end
