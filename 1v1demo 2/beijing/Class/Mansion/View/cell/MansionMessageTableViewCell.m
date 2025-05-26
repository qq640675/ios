//
//  MansionMessageTableViewCell.m
//  beijing
//
//  Created by 黎 涛 on 2020/6/11.
//  Copyright © 2020 zhou last. All rights reserved.
//

#import "MansionMessageTableViewCell.h"
#import "ToolManager.h"
#import "TUIKit.h"
#import "TUIFaceCell.h"
#import "TUIImageCache.h"

#define contentColor UIColor.whiteColor
#define nameColor XZRGB(0x31df9b)
#define giftColor XZRGB(0xfe70b6)
#define kickColor XZRGB(0xeaff00)

@implementation MansionMessageTableViewCell
{
    UIView *messageBGView;
//    UIImageView *headImageView;
    UILabel *contentLabel;
    UIImageView *giftImageView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.contentView.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setSubViews];
    }
    return self;
}

#pragma mark - subViews
- (void)setSubViews {
    messageBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 220, 26)];
    messageBGView.layer.masksToBounds = YES;
    messageBGView.layer.cornerRadius = 13;
    messageBGView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.4];
    [self.contentView addSubview:messageBGView];
    [messageBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-5);
        make.width.mas_equalTo(220);
        make.height.mas_equalTo(26);
    }];
    
    contentLabel = [UIManager initWithLabel:CGRectMake(10, 3, 200, 20) text:@"" font:12 textColor:UIColor.whiteColor];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.numberOfLines = 0;
    [messageBGView addSubview:contentLabel];
    
    giftImageView = [[UIImageView alloc] init];
    giftImageView.hidden = YES;
    giftImageView.contentMode = UIViewContentModeScaleAspectFit;
    giftImageView.clipsToBounds = YES;
    [messageBGView addSubview:giftImageView];
    [giftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-8);
        make.width.height.mas_equalTo(26);
    }];
}

#pragma mark - data
- (void)setMessageModel:(MansionMessageModel *)messageModel {
    if (messageModel.t_id == [YLUserDefault userDefault].t_id) {
        messageModel.nickName = @"我";
    }
    if (messageModel.otherId == [YLUserDefault userDefault].t_id) {
        messageModel.otherName = @"我";
    }
    switch (messageModel.messageType) {
        case MansionMessageTypeUserJoined:
            [self JoindMessage:messageModel];
            break;
        case MansionMessageTypeUserLeaved:
            [self leavedMessage:messageModel];
            break;
        case MansionMessageTypeKickUser:
            [self kickUserMessage:messageModel];
            break;
        case MansionMessageTypeText:
            [self textMessage:messageModel];
            break;
        case MansionMessageTypeGift:
            [self giftMessage:messageModel];
            break;
        default:
            break;
    }
}

- (void)JoindMessage:(MansionMessageModel *)messageModel {
    NSString *content = [NSString stringWithFormat:@"%@进入房间", messageModel.nickName];
    contentLabel.textColor = contentColor;
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:content];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:nameColor range:NSMakeRange(0, messageModel.nickName.length)];
    contentLabel.attributedText = attributedStr;

    giftImageView.hidden = YES;
    CGSize contentSize = [self getSize:content maxWidth:200];
    [self updateBGViewFrameWithWidth:contentSize.width+20 height:contentSize.height+6];
}

- (void)leavedMessage:(MansionMessageModel *)messageModel {
    NSString *content = [NSString stringWithFormat:@"%@离开房间", messageModel.nickName];
    contentLabel.textColor = contentColor;
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:content];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:nameColor range:NSMakeRange(0, messageModel.nickName.length)];
    contentLabel.attributedText = attributedStr;

    giftImageView.hidden = YES;
    CGSize contentSize = [self getSize:content maxWidth:200];
    [self updateBGViewFrameWithWidth:contentSize.width+20 height:contentSize.height+6];
}

- (void)kickUserMessage:(MansionMessageModel *)messageModel {
    NSString *content = [NSString stringWithFormat:@"%@已将%@移除房间", messageModel.nickName, messageModel.otherName];
    contentLabel.textColor = kickColor;
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:content];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:nameColor range:NSMakeRange(messageModel.nickName.length+2, messageModel.otherName.length)];
    contentLabel.attributedText = attributedStr;
    
    giftImageView.hidden = YES;
    CGSize contentSize = [self getSize:content maxWidth:200];
    
    [self updateBGViewFrameWithWidth:contentSize.width+20 height:contentSize.height+6];
}

- (void)textMessage:(MansionMessageModel *)messageModel {
    NSString *content = [NSString stringWithFormat:@"%@:%@", messageModel.nickName, messageModel.contentText];
    contentLabel.textColor = contentColor;
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithAttributedString:[self formatMessageString:content]];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:nameColor range:NSMakeRange(0, messageModel.nickName.length+1)];
    contentLabel.attributedText = attributedStr;
    
    giftImageView.hidden = YES;
    CGSize contentSize = [self getAttributedStringSize:attributedStr maxWidth:200];
    [self updateBGViewFrameWithWidth:contentSize.width+20 height:contentSize.height+6];
}

- (void)giftMessage:(MansionMessageModel *)messageModel {
    NSString *content = [NSString stringWithFormat:@"%@送给%@一个%@", messageModel.nickName, messageModel.otherName, messageModel.gift_name];
    contentLabel.textColor = contentColor;
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:content];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:giftColor range:NSMakeRange(0, messageModel.nickName.length)];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:giftColor range:NSMakeRange(messageModel.nickName.length+2, messageModel.otherName.length)];
    contentLabel.attributedText = attributedStr;
    
    giftImageView.hidden = NO;
    [giftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", messageModel.gift_still_url]]];
    CGSize contentSize = [self getSize:content maxWidth:200];
    [self updateBGViewFrameWithWidth:contentSize.width+50 height:contentSize.height+6];
}

- (CGSize)getSize:(NSString *)text maxWidth:(CGFloat)maxWidth {
    CGFloat width = [ToolManager getWidthWithText:text font:[UIFont systemFontOfSize:12]];
    CGFloat height = 20;
    if (width > maxWidth) {
        width = maxWidth;
        height = [ToolManager getHeightWithText:text font:[UIFont systemFontOfSize:12] maxWidth:maxWidth];
        if (height < 20) {
            height = 20;
        }
    }
    contentLabel.frame = CGRectMake(10, 3, width, height);
    return CGSizeMake(width, height);
}

- (CGSize)getAttributedStringSize:(NSAttributedString *)text maxWidth:(CGFloat)maxWidth {
    CGRect rect = [text boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    if (height < 20) {
        height = 20;
    }
    contentLabel.frame = CGRectMake(10, 2, width, height);
    CGSize size = CGSizeMake(width, height);
    return size;
}

- (void)updateBGViewFrameWithWidth:(CGFloat)width height:(CGFloat)height {
    [messageBGView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
}

- (NSAttributedString *)formatMessageString:(NSString *)text {
    //先判断text是否存在
    if (text == nil || text.length == 0) {
        NSLog(@"TTextMessageCell formatMessageString failed , current text is nil");
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
    //1、创建一个可变的属性字符串
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    
    [attributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(0, attributeString.length)];
    
    if([TUIKit sharedInstance].config.faceGroups.count == 0){
        return attributeString;
    }
    
    //2、通过正则表达式来匹配字符串
    NSString *regex_emoji = @"\\[[a-zA-Z0-9\\/\\u4e00-\\u9fa5]+\\]"; //匹配表情
    
    NSError *error = nil;
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:regex_emoji options:NSRegularExpressionCaseInsensitive error:&error];
    if (!re) {
        NSLog(@"%@", [error localizedDescription]);
        return attributeString;
    }
    
    NSArray *resultArray = [re matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    
    TFaceGroup *group = [TUIKit sharedInstance].config.faceGroups[0];
    
    //3、获取所有的表情以及位置
    //用来存放字典，字典中存储的是图片和图片对应的位置
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
    //根据匹配范围来用图片进行相应的替换
    for(NSTextCheckingResult *match in resultArray) {
        //获取数组元素中得到range
        NSRange range = [match range];
        //获取原字符串中对应的值
        NSString *subStr = [text substringWithRange:range];
        
        for (TFaceCellData *face in group.faces) {
            if ([face.name isEqualToString:subStr]) {
                //face[i][@"png"]就是我们要加载的图片
                //新建文字附件来存放我们的图片,iOS7才新加的对象
                NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                //给附件添加图片
                textAttachment.image = [[TUIImageCache sharedInstance] getFaceFromCache:face.path];
                //调整一下图片的位置,如果你的图片偏上或者偏下，调整一下bounds的y值即可
                textAttachment.bounds = CGRectMake(0, -4, 20, 20);
                //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
                NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
                //把图片和图片对应的位置存入字典中
                NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
                [imageDic setObject:imageStr forKey:@"image"];
                [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
                //把字典存入数组中
                [imageArray addObject:imageDic];
                break;
            }
        }
    }
    
    //4、从后往前替换，否则会引起位置问题
    for (int i = (int)imageArray.count -1; i >= 0; i--) {
        NSRange range;
        [imageArray[i][@"range"] getValue:&range];
        //进行替换
        [attributeString replaceCharactersInRange:range withAttributedString:imageArray[i][@"image"]];
    }
    return attributeString;
}



@end
