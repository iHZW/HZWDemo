//
//  PASConfigDefine.h
//  PASecuritiesApp
//
//  Created by vince on 16/4/27.
//  Copyright © 2016年 PAS. All rights reserved.
//

#ifndef PASConfigDefine_h
#define PASConfigDefine_h

//value
#define kTradeEntrustWaySecuKey @"7"                  //委托交易方式
#define kTradeStockAccountTypeKey @"资金账号:1:0,身份证:6:0"
#define kTradeMarginAccountTypeKey @"资金账号:1:0"

//key账户类型
#define kMarginTradeAccount @"融资融券"
#define kNormalTradeAccount @"普通交易"
#define kIDCardTradeAccount @"身份证"

#define	TRADE_TOKEN_KEY			    @"Trade_Token_Key"
#define LOGIN_USERCODE              @"Login_UserCode_Key"
#define KLastAccount                @"lastAccount" //上一次登录账户
#define kTradeAccountTypeKey          @"account_type"                //保存当前登录成功的交易账号类型
#define kTradeWeakAccountKey          @"trade_account_weak"
#define kTradeSecuAccountKey          @"trade_account_secu"          //股票用户交易账号
#define kTradeMarginAccountKey        @"trade_account_margin"

#define kMark_id                    @"mark_id"

//换肤
#define KFaceStyle                  @"faceStyle6.2.0.1"


#define kPAAccountType                  @"loginAccount_type"                //账户登录类型
#define FUND_ACCOUNT    @"1"        //资金帐号
#define STOCK_ACCOUNT   @"5"        //证券帐号
#define CUSTOM_ACCOUNT  @"6"        //客户编号
#define FUTURE_ACCOUNT  @"A"        //期货账号
#define EXCHANGE_TYPE_SH    @"1"    //上海
#define EXCHANGE_TYPE_SZ    @"2"    //深圳
#define EXCHANGE_TYPE_GEM   @"8"    //创业板
#define EXCHANGE_TYPE_SHB   @"D"    //上海Ｂ
#define EXCHANGE_TYPE_SZB   @"H"    //深圳Ｂ

//首页存储信息

#define kEY_SAVE_MyAssetADIsShow          @"myAssetADIsShow"                  //我的资产 小黄条
#define KEY_AD_JSON                       @"saveADDataKey"
#define kHomeIconVersonOfNative           @"HomeIconVersonOfNative"           //首页配置版本号
#define KCmsPushNewsId  @"homeCmsPushMsgNewId" //6.2首页弹框推送优化
#define KEY_SAVE_ISFIRSTTRADE             @"keySaveIsFirstTrade"              //第一次交易送积分

#define KEY_SAVE_MAINICON_TOTALDataSource @"keySaveHomeIconCMSTotalDataSource"//第一次运行加载本地数据，同时发请求，保存请求的数据
#define kStartAdConfVersion  @"startAdConfVersion66"              //6.2.1ver 首页3s广告cms的post请求confver
#define KSuspensionAdCmsConfVersion   @"suspensionAdCmsConfVer" //6.2ver 悬浮框
#define kUserBusinessHandleConfVersion @"userBusinessHandlingConfVersion"//6.2个人中心业务办理保存的version
#define kUserProfitsServiceConfVersion @"userIncrementServiceConfVersion"//6.2个人中心增值服务保存的version
#define kMarketEntryConfVersion         @"marketEntry66ConfVersion"       //6.2行情新增入口配置保存的version
#define kHomeSearchHotStockVersion   @"homeSearchHotStockVerison" //6.2首页搜索热门股票配置保存的version
#define kHomeSearchHotFundVerison  @"homeSearchHotFundVerison"   //6.2首页搜索热门基金配置保存的version
#define kHomeSearchHotAnchorVersion    @"homeSearchHotAnchorVersion"  //6.2首页搜索热门主播配置保存的version
#define kIMAddContactFriendsVersion @"addContactFriendsVersion"   //IM 请求通讯录好友的配置文件版本号
#define kappIPConfigVersion @"appIPConfigVersion"       //6.5IP可配置
#define kHomeConfVersion     @"homeconfversion" //app 配置
#define kHomeAdpromotion  @"ksimulatehomeadpromotion"   // 6.60vers 模拟交易广告推广
#define kHomeAlertAd      @"ksimulatehomealertad"       // 6.60vers 模拟交易弹框广告
#define kHomeDiscussConf  @"ksimulatehomediscussion"    // 6.60vers 模拟交易大赛讨论

#define kHomeInfoNewsHeadConfigVersion  @"homeInfoNewsHeadConfigVersion"    //6.6 资讯-要闻-头部轮播配置版本号

#define kHeadImageUpdateTime              @"headImageUpdateTime"              //头像上传时间key
#define kHeadImageName                    @"headPhotoImage.png"               //头像名字

//设置
#define kTradeLogoutIntervelKey           @"tradelogoutIntervel"              //交易时间锁定
#define KStatisticFlowKey                 @"statisticflow"                    //流量统计
#define KResetFlowDateKey                 @"resetFlow"                        //重置流量时间
#define KAboutContentKey                  @"about"                            //关于
//存储登陆时长key
#define KEY_LOGINLONG                     @"loginLong"

#define KTerminalWayKey                   @"terminal_way"                     //终端方式

#define kPASHomeGuideShow                 @"home_guide_show"                  // 是否显示新手引导
#define kPASStartGuideShow                @"start_guide_show_6600"              // 开机引导图
#define kPASStockDetailGuideShow          @"stockdetail_guide_show_511"       //个股详情新手引导页
#define kPASSelfStockGuideShow            @"selfstock_guide_show_511"         //自选股界面新手引导页
#define kPASMyInfoCenterGuideShow         @"myInfoCenter_guide_show_511"      //个人中心界面新手引导页

#define kPASClientVersion                 @"client_version"                   // 客户端版本号

#define kCustomKeyBoard                   @"customKeyboard"                   // 自定义键盘

//存储聊天相关key
#define KEY_SAVE_CHAT_USERINFO            @"kUserLoginInfo"


#define kTradeHomeYellowTipVersion    @"tradeHomeYellowTipVersion"  //交易首页小黄条的配置版本

//登录态
//macs
#define KResponseMacsErrorNo2012 -20121012
#define KResponseMacsErrorCode13 13             //查不到登录态
#define KResponseMacsErrorCode22 22             //登录态过期
#define KResponseMacsSubSystemNo104     104 //检测macs登录态接口
#define KResponseMacsSubSystemNo233     233 //检测macs登录态接口
#define KResponseMacsTag888   @"888" //auth
#define KResponseMacsTag99998   @"99998" //errorcode
//stock
#define KResponseRestStatus998  998     //998status，登录态异常 token失效
#define KResponseRestStatus997  997     //997status，登录态异常 未检测到token
#define KResponseActionAuthZ @"Z"        //资金账号
#define KResponseActionAuthR @"R"       //两融


#define KTokenInvalidDoLoginSuccess -19999 //登录态失效但二次登录成功
#define KTokenInvalidErrorNo  -5000  //登录态失效
#define KTokenInvalidCancelNo  -5001  //登录态失效且弹出后二次登录框后权限不对
#define KJsonModelFailedErrorNo  -6000 //jsonmodel化失败，返回原数据
#define KNetWorkFailedErroNo -6001 //登录态失效但二次登录成功

#define KWxNoBindState          5005 //微信登录未绑定
#define KLoginPasswordWrong     -50003 //登录密码错误
#define KLoginAccountLockedState     -102068 //账户锁定状态码

#define KLoginTypeUserName1     @"1" //用户名登录
#define KLoginTypeUserName2     @"2" //用户名登录
#define KLoginTypePhone1        @"3" //手机号登录
#define KLoginTypePhone2        @"4" //手机号登录
#define KLoginTypeSecurityAccount         @"5"  //资金号登录
#define KLoginTypeThird         @"6"  //第三方
#define KLoginTypeIDCard         @"7"  //身份证号

#define kSwitchL2TipInfo        @"正在为您切换VIP服务器"


#define kGatewayPriorityAddress                 @"gatewaypriorityaddress2"

#define KGateWayTradePriorityAddressServerName      @"tradeGateWaypriorityaddressServerName" //首选站点名字
#define kGatewayTradePriorityAddress                @"gatewayTradepriorityaddress"

#define KMACSPriorityAddress                    @"macspriorityaddress2" //首选地址
#define KMACSPriorityAddressServerName          @"macspriorityaddressServerName2" //首选站点名字


#define KDZHMarketL1Address                     @"KDZHMarketL1Address"      //l1行情缓存字段
#define KDZHMarketL2Address                     @"KDZHMarketL2Address"      //l2行情缓存字段

//**********任意门开关，开启任意门需要在相应target的other linker 上加上 -licucore 编译参数。
#ifndef DEV_ONLY
#define ANYDOOR_ENABLED
#endif

#define APP_aid            @"0"
#define APP_sid            @"0"
#define APP_ouid           @"ios_jy"
#define APP_recommendno    @""

#define KUniversalLinkDomainPro       @"stock.pingan.com"


#define KNotifycationForReloadFinacingWebView   @"notifycationforrelaodFinacingwebv"



//确保程序生命周期只走一次灰度的
#define KTradeSSLGateWayABCacheKey               @"KTradeSSLGateWayABCacheKey"

#endif /* PASConfigDefine_h */
