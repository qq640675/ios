//
//  ChatLivingMsgListTableViewCell.m
//  beijing
//
//  Created by yiliaogao on 2019/2/28.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "ChatLivingMsgListTableViewCell.h"
#import "ChatLivingMsgListModel.h"

@implementation ChatLivingMsgListTableViewCell

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
    ChatLivingMsgListModel *model = (ChatLivingMsgListModel *)listModel;
    if (model.isSystemMsg) {
        _contentLb.textColor = XZRGB(0xf9fb44);
        _contentLb.text = model.content;
    } else {
        if (model.isSelf) {
            _contentLb.textColor = [UIColor whiteColor];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:model.content];
            [str addAttribute:NSForegroundColorAttributeName value:XZRGB(0xf9fb44) range:NSMakeRange(0,2)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(2,model.content.length-2)];
            _contentLb.attributedText = str;
        } else {
            _contentLb.textColor = XZRGB(0x00ffd8);
            _contentLb.text = model.content;
        }
    }
    
    
    
    CGFloat cellHeight = [ChatLivingMsgListTableViewCell cellHeight:listModel];
    if (cellHeight < 37.0) {
        //计算宽度
        CGFloat width = [SLHelper labelWidth:model.content font:PingFangSCFont(15.0f) labelHeight:21];
        _bgView.frame = CGRectMake(0, 2, width+20, cellHeight-4);
    } else {
        _bgView.frame = CGRectMake(0, 2, 310, cellHeight-4);
    }
}

+ (CGFloat)cellHeight:(SLBaseListModel *)listModel {
    ChatLivingMsgListModel *model = (ChatLivingMsgListModel *)listModel;
    CGFloat height = [SLHelper labelHeight:model.content font:PingFangSCFont(15.0f) labelWidth:300];
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
