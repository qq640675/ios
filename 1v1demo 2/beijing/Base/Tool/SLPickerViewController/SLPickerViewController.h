//
//  SLPickerViewController.h
//  beijing
//
//  Created by yiliaogao on 2019/1/2.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger,SLPickerViewBtnType) {
    SLPickerViewBtnType_Cancel = 0,
    SLPickerViewBtnType_Sure = 1
};

@protocol SLPickerViewControllerDelegate <NSObject>

- (void)didSLPickerViewControllerSureBtn:(NSInteger)row;

- (void)didSLPickerViewControllerCancelBtn;

@end




@interface SLPickerViewController : UIViewController

@property (nonatomic, copy) NSArray     *pickerDataArray;
@property (nonatomic, copy) NSString    *pickerDataUnit;

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, assign) NSInteger    selectedRow;

@property (nonatomic, assign) id<SLPickerViewControllerDelegate>    delegate;

- (void)setupUI;

@end

