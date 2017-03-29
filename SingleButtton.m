//
//  SingleButtton.m
//  WavesAnimationDemo
//
//  Created by apple on 2017/3/29.
//  Copyright © 2017年 YangQiang. All rights reserved.
//

#import "SingleButtton.h"

static NSMutableDictionary *groupRadioDic = nil;

@implementation SingleButtton

- (id)initWithDelegate:(id)delegate groupId:(NSString*)groupId {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        
        _groupId = [groupId copy];
        
        [self addToGroup];
        
        self.exclusiveTouch = YES; //可以达到同一界面上多个控件接受事件时的排他性
        
        [self setBackgroundImage:[UIImage imageNamed:@"disselected.png"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateSelected];
        [self addTarget:self action:@selector(singleBtnChecked) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
#pragma mark --- Private Methods ----
//将创建的按钮添加到数组中
- (void)addToGroup {
    if(!groupRadioDic){
        groupRadioDic = [NSMutableDictionary dictionary];
    }
    
    NSMutableArray *singles = [groupRadioDic objectForKey:self.groupId];
    if (!singles) {
        singles = [NSMutableArray array];
    }
    [singles addObject:self];
    [groupRadioDic setObject:singles forKey:self.groupId];
}
//移除字典数组
- (void)removeFromGroup {
    if (groupRadioDic) {
        NSMutableArray *singles = [groupRadioDic objectForKey:self.groupId];
        if (singles) {
            [singles removeObject:self];
            if (singles.count == 0) {
                [groupRadioDic removeObjectForKey:self.groupId];
            }
        }
    }
}
//移除除了本身之外的字典和数组
- (void)removeExceptSelf{
    if (groupRadioDic) {
        NSMutableArray *singles = [groupRadioDic objectForKey:self.groupId];
        if (singles) {
            if (singles.count > 0) {
                for (SingleButtton *single in singles) {
                    if (![single isEqual:self]) {
                        [singles removeObject:self];
                    }
                }
            }
            if (singles.count == 0) {
                [groupRadioDic removeObjectForKey:self.groupId];
            }
        }
    }
}

//将数组中其他没有选中的按钮设置为未选中状态
- (void)uncheckOtherRadios {
    NSMutableArray *singles = [groupRadioDic objectForKey:self.groupId];
    if (singles.count > 0) {
        for (SingleButtton *single in singles) {
            if (single.selected && ![single isEqual:self]) {
                single.selected = NO;
            }
        }
    }
}
#pragma mark --- Events ----
- (void)singleBtnChecked {
    
//    if (self.selected) {
//        return;
//    }
    
    self.selected = !self.selected;
    
    if (!self.selected) {
        return;
    }
    
    if (self.selected) {
        [self uncheckOtherRadios];
    }
    
    if (self.selected && self.delegate && [self.delegate respondsToSelector:@selector(didSelectedRadioButton:groupId:)]) {
        [self.delegate didSelectedRadioButton:self groupId:self.groupId];
    }
}
#pragma mark --- setter && getter ----
- (void)setChecked:(BOOL)checked {
   
    self.selected = checked;

    if (self.selected) {
        [self uncheckOtherRadios];
    }

    if (self.selected && self.delegate && [self.delegate respondsToSelector:@selector(didSelectedRadioButton:groupId:)]) {
        [self.delegate didSelectedRadioButton:self groupId:_groupId];
    }
}
- (void)dealloc{
    [self removeExceptSelf];
    self.delegate = nil;
}

#pragma mark --- 调整按钮的图片和文字的位置和大小 ----
//- (CGRect)imageRectForContentRect:(CGRect)contentRect {
//    return CGRectMake(0, (CGRectGetHeight(contentRect) - Q_RADIO_ICON_WH)/2.0, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
//}

//- (CGRect)titleRectForContentRect:(CGRect)contentRect {
//    return CGRectMake(Q_RADIO_ICON_WH + Q_ICON_TITLE_MARGIN, 0,
//                      CGRectGetWidth(contentRect) - Q_RADIO_ICON_WH - Q_ICON_TITLE_MARGIN,
//                      CGRectGetHeight(contentRect));
//}

@end
