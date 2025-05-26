//
//  BigLivingMsgListTableViewCell.m
//  beijing
//
//  Created by yiliaogao on 2019/4/24.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "BigLivingMsgListTableViewCell.h"
#import "BigLivingMsgListModel.h"

@implementation BigLivingMsgListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.bgView = [[UIView alloc] initWithFrame:CGRectZero];
    _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3];
    _bgView.clipsToBounds = YES;
    _bgView.layer.cornerRadius = 5;
    
    [self.contentView addSubview:_bgView];
    
    
    [_bgView addSubview:self.contentLb];
    [_contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(self.bgView).offset(5);
        make.right.and.bottom.equalTo(self.bgView).offset(-5);
    }];
}

- (void)initWithData:(SLBaseListModel *)listModel {
    NSString *content = nil;
    BigLivingMsgListModel *model = (BigLivingMsgListModel *)listModel;
    if (model.isSystemMsg) {
        if (model.isUserJoinRoomMsg) {
            _contentLb.textColor = XZRGB(0xfafb44);
            content = [NSString stringWithFormat:@"%@ 来了，欢迎！",model.content];
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:content];
            [str addAttribute:NSForegroundColorAttributeName value:XZRGB(0x00ffd8) range:NSMakeRange(0,model.content.length)];
            [str addAttribute:NSForegroundColorAttributeName value:XZRGB(0xfafb44) range:NSMakeRange(model.content.length,content.length-model.content.length)];
            _contentLb.attributedText = str;
            
        } else {
            _contentLb.textColor = XZRGB(0xaaffc4);
            content = model.content;
            _contentLb.text = content;
            
            
        }
        
    } else {
        content = [NSString stringWithFormat:@"%@：%@",model.nickName,model.content];
        _contentLb.textColor = [UIColor whiteColor];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:content];
        [str addAttribute:NSForegroundColorAttributeName value:XZRGB(0x00ffd8) range:NSMakeRange(0,model.nickName.length+1)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(model.nickName.length+1,content.length-model.nickName.length-1)];
        _contentLb.attributedText = str;
    }
    
    CGFloat cellHeight = [BigLivingMsgListTableViewCell cellHeight:listModel];
    if (cellHeight < 37.0) {
        //计算宽度
        CGFloat width = [SLHelper labelWidth:content font:PingFangSCFont(15.0f) labelHeight:21]+5;
        _bgView.frame = CGRectMake(0, 2, width+10, cellHeight-4);
    } else {
        _bgView.frame = CGRectMake(0, 2, 310, cellHeight-4);
    }
}

+ (CGFloat)cellHeight:(SLBaseListModel *)listModel {
    BigLivingMsgListModel *model = (BigLivingMsgListModel *)listModel;
    NSString *content = nil;
    if (model.isSystemMsg) {
        content = model.content;
    } else {
        content = [NSString stringWithFormat:@"%@：%@",model.nickName,model.content];
    }
    
    CGFloat height = [SLHelper labelHeight:content font:PingFangSCFont(15.0f) labelWidth:300];
    return height+14;
}

- (UILabel *)contentLb {
    if (!_contentLb) {
        _contentLb = [UIManager initWithLabel:CGRectZero text:nil font:15.0f textColor:[UIColor whiteColor]];
        _contentLb.textAlignment = NSTextAlignmentLeft;
        _contentLb.numberOfLines = 0;
        
    }
    return _contentLb;
}

@end
