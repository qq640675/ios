//
//  MessageSystemTableViewCell.h
//  beijing
//
//  Created by 黎 涛 on 2021/3/30.
//  Copyright © 2021 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageSystemTableViewCell : UITableViewCell

- (void)setLogo:(NSString *)logoName title:(NSString *)title;
- (void)setContent:(NSString *)content;
- (void)setCellNubmer:(int)num;


@end

NS_ASSUME_NONNULL_END
