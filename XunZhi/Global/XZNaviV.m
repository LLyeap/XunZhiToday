//
//  XZNaviV.m
//  XunZhi
//
//  Created by 李雷 on 16/5/15.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import "XZNaviV.h"


#define naviHeight self.frame.size.height
#define nightBgColor [UIColor colorWithRed:185.0f/255.0f green:42.0f/255.0f blue:42.0f/255.0f alpha:1.0f]
#define commonItemFontSize [UIFont systemFontOfSize:20.0f]
#define selectedItemFontSize [UIFont systemFontOfSize:25.0f]

@interface XZNaviV ()

/** 通过初始化方法传过来的用来显示在导航条上的文字内容数组 */
@property (nonatomic, retain) NSArray *itemArray;
/** 导航条做成一个scrollView, 放回给调用者, 放在naviBar的titleView位置上 */
@property (nonatomic, retain) UIScrollView *scrollView;
/** 记录当前的item的tag值 */
@property (nonatomic, assign) NSInteger presentBtnItemTag;
/** block快, 在初始化语句中, 用来执行调用者点击item的事件 */
@property (nonatomic, copy) void (^itemBlock)(NSInteger tag);
/** block块, 在初始化语句中, 用来执行调用者点击右侧跟多按钮的事件 */
@property (nonatomic, copy) void (^btnRightBlock)(UIButton *btnRight);

@end

@implementation XZNaviV

/**
 *  初始化方法
 *
 *  @param frame        设置页面布局
 *  @param itemArray    显示item内容数组
 *  @param itemBlock    导航条中item点击结果回调block
 *  @param btnRightBlock 右侧更多按钮点击事件的回调block
 *
 *  @return 带有scrollView和分割线和加好按钮的View
 */
- (instancetype)initWithFrame:(CGRect)frame ItemArray:(NSArray *)itemArray itemClickBlock:(void (^)(NSInteger))itemBlock btnRightBlock:(void (^)(UIButton *))btnRightBlock {
    self = [super initWithFrame:frame];
    if (self) {
        self.itemArray = itemArray;
        [self createView];
        self.itemBlock = itemBlock;
        self.btnRightBlock = btnRightBlock;
    }
    return self;
}

#pragma mark - 自定义函数
/**
 *  创建页面view
 */
- (void)createView {
    /** 创建scrollView */
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(-10, 0, SCREENWIDTH - naviHeight - 5, naviHeight)];
    _scrollView.backgroundColor = [UIColor redColor];
    _scrollView.nightBackgroundColor = nightBgColor;
    CGFloat itemWidthX = 0;
    CGFloat itemWidth = 0;
    for (int i=0; i<_itemArray.count; i++) {
        itemWidth = [[self class] widthForText:[_itemArray objectAtIndex:i]] + 20;
        UIButton *btn_item = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_item.frame = CGRectMake(itemWidthX, 0, itemWidth, naviHeight);
        itemWidthX += itemWidth;
        [btn_item setTitle:_itemArray[i] forState:UIControlStateNormal];
        btn_item.titleLabel.font = commonItemFontSize;
        // >设置夜间模式
        btn_item.tintColor = UIColorFromRGB(0xffffff);
        btn_item.nightTitleColor = UIColorFromRGB(0xffffff);
        btn_item.backgroundColor = [UIColor redColor];
        btn_item.nightBackgroundColor = nightBgColor;
        [_scrollView addSubview:btn_item];
        [btn_item addTarget:self action:@selector(btn_itemAction:) forControlEvents:UIControlEventTouchUpInside];
        btn_item.tag = i+1;
    }
    // >如果itme太少, 则添加一个没有点击事件的btn来填充空余部分
    if (itemWidthX < _scrollView.frame.size.width) {
        UIButton *btn_item = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_item.frame = CGRectMake(itemWidthX, 0, _scrollView.frame.size.width-itemWidthX, naviHeight);
        itemWidthX += _scrollView.frame.size.width-itemWidthX;
        btn_item.tintColor = UIColorFromRGB(0xffffff);
        btn_item.nightTitleColor = UIColorFromRGB(0xffffff);
        btn_item.backgroundColor = [UIColor redColor];
        btn_item.nightBackgroundColor = nightBgColor;
        [_scrollView addSubview:btn_item];
    }
    // >设置_scrollView的滚动范围
    _scrollView.contentSize = CGSizeMake(itemWidthX, 0);
    _scrollView.bounces = NO;
    [self addSubview:_scrollView];
    // >默认选中第一个
    self.presentBtnItemTag = 1;
    // >修改默认选中的item的字体大小
    UIButton *btnPresentItem = (UIButton *)[self viewWithTag:_presentBtnItemTag];
    btnPresentItem.titleLabel.font = selectedItemFontSize;
    /** 创建分割线 */
    UIButton *btnSplit = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSplit.frame = CGRectMake(_scrollView.frame.origin.x + _scrollView.frame.size.width, 0, 8, naviHeight);
    [self addSubview:btnSplit];
    [btnSplit setImage:[UIImage imageNamed:@"splitLine_nor"] forState:UIControlStateNormal];
    btnSplit.backgroundColor = [UIColor redColor];
    btnSplit.nightBackgroundColor = nightBgColor;
    btnSplit.enabled = false;
    /** 创建更多按钮 */
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame = CGRectMake(btnSplit.frame.origin.x + btnSplit.frame.size.width, 0, naviHeight, naviHeight);
    [self addSubview:btnRight];
    [btnRight setImage:[UIImage imageNamed:@"btnSearch_nor"] forState:UIControlStateNormal];
    btnRight.backgroundColor = [UIColor redColor];
    btnRight.nightBackgroundColor = nightBgColor;
    [btnRight addTarget:self action:@selector(btnRightAction:) forControlEvents:UIControlEventTouchUpInside];
}
/**
 *  文字宽度适配
 *
 *  @param text 文字内容
 *
 *  @return 文字所占宽度
 */
+ (CGFloat)widthForText:(NSString *)text {
    CGRect rect = [text boundingRectWithSize:CGSizeMake(0, 300)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0f]}
                                     context:nil];
    CGFloat textW = rect.size.width;
    return textW;
}
/**
 *  导航条右侧按钮点击事件
 *
 *  @param btnRight 右侧的按钮
 */
- (void)btnRightAction:(UIButton *)btnRight {
    // >更多按钮的点击事件通过btnRightBlock进行回调, 在调用的页面里做处理
    self.btnRightBlock(btnRight);
}
/**
 *  导航条上每一个item的点击事件
 *
 *  @param btn_item 被点击的item
 */
- (void)btn_itemAction:(UIButton *)btn_item {
    [self changeStatus:btn_item];
    // >回传被点击的item的tag内容, 在调用它的控制器中进一步处理
    self.itemBlock(btn_item.tag);
}
/**
 *  调用的页面中内容部分滑动到相应item, 通过此方法改变naviB的状态
 *
 *  @param tag 传过来应该被选中的item的tag值
 */
- (void)scrollWithTag:(NSInteger)tag {
    UIButton *btn_scroll = (UIButton *)[self viewWithTag:tag];
    [self changeStatus:btn_scroll];
}
/**
 *  修改naviB上的item的状态
 *
 *  @param currentBtn 应该被修改的item按钮
 */
- (void)changeStatus:(UIButton *)currentBtn {
    // >恢复上一个被选中的字体大小
    UIButton *btnPresentItem = (UIButton *)[self viewWithTag:_presentBtnItemTag];
    btnPresentItem.titleLabel.font = commonItemFontSize;
    // >修改当前被选中的字体大小
    currentBtn.titleLabel.font = selectedItemFontSize;
    // >修改_presentBtnItemTag值为当前被选中的item的tag
    _presentBtnItemTag = currentBtn.tag;
    // >修改_scrollView当前偏移量, 将当前item移到屏幕中间
    if ((currentBtn.frame.origin.x + currentBtn.frame.size.width/2) - _scrollView.contentOffset.x != SCREENWIDTH/2) {
//        带动画出Bug
//        [_scrollView setContentOffset:CGPointMake(btn_item.frame.origin.x + btn_item.frame.size.width/2 - SCREENWIDTH/2, 0) animated:YES];
        _scrollView.contentOffset = CGPointMake(currentBtn.frame.origin.x + currentBtn.frame.size.width/2 - SCREENWIDTH/2, 0);
        if (_scrollView.contentSize.width - _scrollView.contentOffset.x < _scrollView.frame.size.width) {
            _scrollView.contentOffset = CGPointMake(_scrollView.contentSize.width - _scrollView.frame.size.width, 0);
        }if (currentBtn.frame.origin.x + currentBtn.frame.size.width/2 < SCREENWIDTH/2) {
            _scrollView.contentOffset = CGPointMake(0, 0);
        }
    }
}


@end












