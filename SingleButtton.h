//
//  SingleButtton.h
//  WavesAnimationDemo
//
//  Created by apple on 2017/3/29.
//  Copyright © 2017年 YangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SingleButttonDelegate;

@interface SingleButtton : UIButton

@property(nonatomic, assign)id<SingleButttonDelegate>   delegate;
@property(nonatomic, copy, readonly)NSString            *groupId;
@property(nonatomic, assign)BOOL checked;

- (id)initWithDelegate:(id)delegate groupId:(NSString*)groupId;

@end

@protocol SingleButttonDelegate <NSObject>

@optional

- (void)didSelectedRadioButton:(SingleButtton *)radio groupId:(NSString *)groupId;

@end
