//
//  ASHBandModel.h
//  AsHackerCPS
//
//  Created by 陈涛 on 2018/7/5.
//  Copyright © 2018年 Sinanbell. All rights reserved.
//

#import "CommonRuntime_Model.h"
/*
 id    主键
 car_name    车辆名称
 show_pic    展示图片
 listBrand    车辆品牌列表
 Brand
 id    主键
 brand_cnName    品牌中文名称
 brand_enName    品牌英文名
 brand_logo    品牌商标
 
 
 */
@interface ASHBandModel : CommonRuntime_Model
@property (nonatomic , assign) long id;
@property (nonatomic , strong) NSString *brand_cnName;

@property (nonatomic , strong) NSString *brand_enName;
@property (nonatomic , strong) NSString *brand_logo;
@end
