//
//  DynamicReleasePicTableViewCell.m
//  beijing
//
//  Created by yiliaogao on 2018/12/26.
//  Copyright © 2018 zhou last. All rights reserved.
//

#import "DynamicReleasePicTableViewCell.h"
#import "DynamicReleasePicModel.h"
#import "DynamicVideoView.h"
#import "DynamicPicModel.h"
#import "DynamicVideoModel.h"

@implementation DynamicReleasePicTableViewCell

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
    CGFloat gap = (App_Frame_Width-75*4)/5;
    for (int i = 0; i < 9; i ++) {
        DynamicPicView *picView = [[DynamicPicView alloc] initWithFrame:CGRectMake(gap+(gap+75)*(i%4), gap+(gap+75)*(i/4), 75, 75)];
        picView.backgroundColor = [UIColor blueColor];
        picView.tag = 1000+i;
        [self.contentView addSubview:picView];
        picView.hidden = YES;
    }
    
    //视频
    DynamicVideoView *videoView = [[DynamicVideoView alloc] initWithFrame:CGRectMake(20, 15, 120, 180)];
    videoView.tag = 10086;
    [self.contentView addSubview:videoView];
    videoView.hidden = YES;
    
    //添加按钮
    [self.contentView addSubview:self.addPicBtn];
    DynamicPicView *curPicView = [self.contentView viewWithTag:1000];
    _addPicBtn.frame = curPicView.frame;
}

- (void)initWithData:(SLBaseListModel *)listModel {
    _addPicBtn.hidden = NO;
    DynamicReleasePicModel *model = (DynamicReleasePicModel *)listModel;
    if (model.fileDataType == FileDataType_Video) {
        //视频
        for (int i = 0; i < [model.picModelArray count]; i++) {
            DynamicVideoModel *videoModel = [model.picModelArray firstObject];
            DynamicVideoView *curVedioView = [self.contentView viewWithTag:10086];
            curVedioView.delegate = self;
            curVedioView.hidden = NO;
//            curVedioView.freeBtn.tag = 1000;
            NSString *title = @"收费";
            if ([videoModel.money isEqualToString:@"0"]) {
                title = @"免费";
            } else {
                if (videoModel.money.length > 0) {
                    title = videoModel.money;
                }
            }
            [curVedioView setupWithImage:videoModel.image title:title secTime:videoModel.videoSec];
            _addPicBtn.hidden = YES;
        }
    } else {
        //图片
        for (UIView *view in self.contentView.subviews) {
            if ([view isKindOfClass:[DynamicPicView class]]) {
                view.hidden = YES;
            }
        }
        for (int i = 0; i < [model.picModelArray count]; i++) {
            DynamicPicModel *picModel  = model.picModelArray[i];
            DynamicPicView *curPicView = [self.contentView viewWithTag:1000+i];
            curPicView.deleteBtn.tag = 100+i;
//            curPicView.freeBtn.tag = 1000+i;
            curPicView.delegate = self;
            curPicView.hidden = NO;
            NSString *title = @"收费";
            if ([picModel.money isEqualToString:@"0"]) {
                title = @"免费";
            } else {
                if (picModel.money.length > 0) {
                    title = picModel.money;
                }
            }
            [curPicView setupWithImage:picModel.image title:title];
        }
        
        if ([model.picModelArray count] < 9) {
            DynamicPicView *curPicView = [self.contentView viewWithTag:1000+model.picModelArray.count];
            _addPicBtn.frame = curPicView.frame;
        } else {
            _addPicBtn.hidden = YES;
        }
    }
    
    
}

+ (CGFloat)cellHeight:(SLBaseListModel *)listModel {
    DynamicReleasePicModel *model = (DynamicReleasePicModel *)listModel;
    if (model.fileDataType == FileDataType_Video) {
        return 210;
    }
    CGFloat gap = (App_Frame_Width-75*4)/5;
    int num = (int)model.picModelArray.count + 1;
    if (num > 9) {
        num = 9;
    }
    CGFloat height = ((num+3)/4)*(gap+75)+gap;
    return height;
}

- (void)clickedAddBtn:(UIButton *)btn {
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectDynamicReleasePicTableViewCellBtn:)]) {
        [_delegate didSelectDynamicReleasePicTableViewCellBtn:btn.tag];
    }
}

- (void)didSelectDynamicPicViewBtn:(NSUInteger)btnTag {
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectDynamicReleasePicTableViewCellBtn:)]) {
        [_delegate didSelectDynamicReleasePicTableViewCellBtn:btnTag];
    }
}

- (void)didSelectDynamicVideoViewBtn:(NSUInteger)btnTag {
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectDynamicReleasePicTableViewCellBtn:)]) {
        [_delegate didSelectDynamicReleasePicTableViewCellBtn:btnTag];
    }
}

- (UIButton *)addPicBtn {
    if (!_addPicBtn) {
        _addPicBtn = [UIManager initWithButton:CGRectZero text:nil font:0.0f textColor:[UIColor whiteColor] normalImg:@"Dynamic_release_add" highImg:nil selectedImg:nil];
        [_addPicBtn addTarget:self action:@selector(clickedAddBtn:) forControlEvents:UIControlEventTouchUpInside];
        _addPicBtn.tag = 10;
    }
    return _addPicBtn;
}

@end
