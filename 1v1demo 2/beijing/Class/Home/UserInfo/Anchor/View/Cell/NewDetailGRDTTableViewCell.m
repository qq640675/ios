//
//  NewDetailGRDTTableViewCell.m
//  beijing
//
//  Created by 黎 涛 on 2021/3/12.
//  Copyright © 2021 zhou last. All rights reserved.
//

#import "NewDetailGRDTTableViewCell.h"

@implementation NewDetailGRDTTableViewCell
{
    UILabel *nodataL;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma makr - init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = UIColor.whiteColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES;
        [self setSubViews];
    }
    return self;
}

#pragma mark - subViews
- (void)setSubViews {
    UIView *point = [[UIView alloc] initWithFrame:CGRectMake(15, 17, 6, 6)];
    point.backgroundColor = UIColor.blackColor;
    point.layer.masksToBounds = YES;
    point.layer.cornerRadius = 3;
    [self.contentView addSubview:point];
    
    UILabel *titleL = [UIManager initWithLabel:CGRectMake(32, 10, 150, 20) text:@"个人动态" font:16 textColor:XZRGB(0x333333)];
    titleL.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:titleL];
    
    for (int i = 0; i < 3; i ++) {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(15+85*i, 50, 80, 80)];
        imageV.image = [UIImage imageNamed:@"loading"];
        imageV.layer.masksToBounds = YES;
        imageV.layer.cornerRadius = 8;
        imageV.tag = 300+i;
        imageV.hidden = YES;
        imageV.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:imageV];
        
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        effectView.frame = CGRectMake(0, 0, imageV.width, imageV.height);
        effectView.hidden = YES;
        effectView.alpha = 0.9;
        effectView.tag = 400+i;
        [imageV addSubview:effectView];
        
        UIImageView *playLogo = [[UIImageView alloc] initWithFrame:CGRectMake(28, 28, 24, 24)];
        playLogo.image = [UIImage imageNamed:@"AnthorDetail_dynamic_video"];
        playLogo.tag = 350+i;
        playLogo.hidden = YES;
        [imageV addSubview:playLogo];
    }
    
    UIImageView *rightV = [[UIImageView alloc] initWithFrame:CGRectMake(App_Frame_Width-25, 50+(80-14)/2, 8, 14)];
    rightV.image = [UIImage imageNamed:@"accessory"];
    [self.contentView addSubview:rightV];
    
    nodataL = [UIManager initWithLabel:CGRectMake(32, 50, 150, 80) text:@"暂无动态" font:14 textColor:XZRGB(0x999999)];
    nodataL.textAlignment = NSTextAlignmentLeft;
    nodataL.hidden = NO;
    [self.contentView addSubview:nodataL];
}

- (void)setDefault {
    nodataL.hidden = NO;
    for (int i = 0; i < 3; i ++) {
        UIImageView *imageV = [self.contentView viewWithTag:300+i];
        imageV.hidden = YES;
        
        UIVisualEffectView *effectView = [imageV viewWithTag:400+i];
        effectView.hidden = YES;
        
        UIImageView *playLogo = [imageV viewWithTag:350+i];
        playLogo.hidden = YES;
    }
}

- (void)setDynamicData:(NSArray *)list {
    [self setDefault];
    if (list.count == 0) return;
    nodataL.hidden = YES;
    
    int num = 0;
    for (int i = 0; i < list.count; i ++) {
        DynamicListModel *model = list[i];
        if (model.fileArrays.count > 0) {
            DynamicFileModel *fileModel = model.fileArrays.firstObject;
            UIImageView *imageV = [self.contentView viewWithTag:300+num];
            imageV.hidden = NO;
            if (fileModel.t_file_type == 0) {
                [imageV sd_setImageWithURL:[NSURL URLWithString:fileModel.t_file_url] placeholderImage:[UIImage imageNamed:@"loading"]];
            } else {
                [imageV sd_setImageWithURL:[NSURL URLWithString:fileModel.t_cover_img_url] placeholderImage:[UIImage imageNamed:@"loading"]];
                UIImageView *playLogo = [imageV viewWithTag:350+num];
                playLogo.hidden = NO;
            }
            UIVisualEffectView *effectView = [imageV viewWithTag:400+num];
            if (fileModel.isPrivate) {
                effectView.hidden = NO;
            } else {
                effectView.hidden = YES;
            }
            num ++;
            if (num == 3) break;
        }
    }
}

@end
