//
//  Header.h
//  SMedical
//
//  Created by _SS on 14/11/20.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#ifndef SMedical_Header_h
#define SMedical_Header_h

#define DoucumentDir [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

//  测试用
#define  USERNAME_TEST      @"18513424723"
#define  USERPASSWORD_TEST  @"123"

//  控件tag值
#define  ALERT_TELPHONRTAG   100
#define  TABLEVIEW_MAIN      200
#define  ANIMATIONIMAGEVIEW_DETAILS  300
#define  PUSHVIEW_IMAGEVIEW  400
#define  MAIN_COVERIMAGEVIEW 500
#define  SHOWRECORDVIEW_NEWRECORDBTN  600
#define  SHOWRECORDVIEW_USEBTN        601
#define  SHOWRECORDVIEW_SHOWBUTTON    602
#define  SHOWRECORDVIEW_BEGINLABEL    603
#define  SHOWRECORDVIEW_ENDLABEL      604
#define  SHOWRECORDVIEW_SLIDER        605

//  屏幕的物理高度
#define  SCREENHEIGHT  [UIScreen mainScreen].bounds.size.height

//  屏幕的物理宽度
#define  SCREENWIDTH   [UIScreen mainScreen].bounds.size.width

#define  SCREENHEIGHT_INBAR  ([UIScreen mainScreen].bounds.size.height - 64)
/**
 *  颜色设置
 */
#define  RGBACOLOR(R,G,B,A)  [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)]

//默认最大录音时间
#define kDefaultMaxRecordTime               60

#endif
