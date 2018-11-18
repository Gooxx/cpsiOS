//
//  ASHBIZActivityTableViewController.m
//  AsHackerCPS
//
//  Created by 陈涛 on 2018/6/1.
//  Copyright © 2018年 Sinanbell. All rights reserved.
//

#import "ASHBIZActivityTableViewController.h"

@interface ASHBIZActivityTableViewController ()

@end
static NSString *const kTABLE_CELL = @"cpsActivityCell";

static NSString *const k1P_CELL = @"cpsMainCell1P";
static NSString *const k3P_CELL = @"cpsMainCell3P";
static NSString *const k1V_CELL = @"cpsMainCell1V";
//NSArray *cellNames = @[@"cpsMainCellLB",@"cpsMainCell1P",@"cpsMainCell3P",@"cpsMainCell1V"];
@implementation ASHBIZActivityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationController.navigationBar.hidden = NO;

    [self.tableView registerNib:[UINib nibWithNibName:@"ASH1PTableViewCell" bundle:nil] forCellReuseIdentifier:@"ASH1PTableViewCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ASH3PCell" bundle:nil] forCellReuseIdentifier:@"cpsMainCell3P"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ASH1VCell" bundle:nil] forCellReuseIdentifier:@"cpsMainCell1V"];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDataUP)];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshDataDown)];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshDataUP];
}
//数据源
-(void)refreshDataUP{
    
    [self refreshDataWithIndex:1];
}

-(void)refreshDataDown{
    double count = self.dataArr.count;
    NSInteger num = ceil(count/PAGE_COUNT);
    [self refreshDataWithIndex:num+1];
}

-(void)refreshDataWithIndex:(NSInteger)index{
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    if (!self.dataArr) {
        self.dataArr =  [NSMutableArray array];
        
    }
    [self.tableView reloadData];
    
    //    NSString *rowCountStr = [NSString stringWithFormat:@"%ld",_dataArr.count>0?_dataArr.count:0];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSInteger count = self.dataArr.count;
    //    NSInteger num =  count/PAGE_COUNT;
    
    [params setObject:[NSString stringWithFormat:@"%ld",index] forKey:@"pageIndex"];
    //    [params setObject:[NSString stringWithFormat:@"%ld",num+1] forKey:@"pageIndex"];
    [params setObject:@"10" forKey:@"count"];
    [params setObject:@"1" forKey:@"flag"];
//    type    文章种类
//    1首页新闻
//    2整车信息
//    3车型品牌
    
//        [params setObject:@"3" forKey:@"type"];
    
    
    [MOMNetWorking asynRequestByMethod:@"mainBbsList.do" params:params publicParams:MOMNetPublicParamNone callback:^(id result, NSError *error) {
        NSInteger ret = [[result objectForKey:@"ret"] integerValue];
        NSDictionary *dic = result;
        if (MOMResultSuccess==ret) {
            //            _dataArr = [dic objectForKey:@"list"];
            //            _dataArr = [ASHBBSModel ModelsWithArray:[dic objectForKey:@"list"]];
            NSMutableArray *arrm = [NSMutableArray arrayWithArray:self.dataArr];
            NSArray *arr = [ASHBBSModel ModelsWithArray:[dic objectForKey:@"list"]];
            self.dataArr = [arrm arrayByAddingObjectsFromArray:arr];
            [self.tableView reloadData];
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *cellNames = @[@"cpsMainCellLB",@"ASH1PTableViewCell",@"cpsMainCell3P",@"cpsMainCell1V"];
    ASHBBSModel *model = self.dataArr[indexPath.row];
    
    UITableViewCell *tcell = [tableView dequeueReusableCellWithIdentifier:cellNames[model.bbs_type] forIndexPath:indexPath];
    if(!tcell){
        tcell = [[[NSBundle mainBundle]loadNibNamed:cellNames[model.bbs_type] owner:nil options:nil] firstObject];
    }
    
    if (ASHBBSType1P == model.bbs_type) {
        __weak ASHBBS1PCell *cell = (ASHBBS1PCell *)tcell;
        cell.title.text = model.bbs_title;
        cell.name.text = model.user_nick;
        cell.time.text = model.bbs_time;
        [cell.image1 ash_setImageWithURL:model.bbs_minPic ];
        tcell = cell;
    }else if (ASHBBSType3P == model.bbs_type) {
        __weak ASH3PCell *cell =  (ASH3PCell *)tcell;
        cell.title.text = model.bbs_description;
        cell.name.text = model.bbs_title;
        cell.time.text = model.bbs_time;
        [cell.image1 ash_setImageWithURL:model.bbs_minPic ];
        [cell.image2 ash_setImageWithURL:model.bbs_minPic];
        [cell.image3 ash_setImageWithURL:model.bbs_minPic];
        tcell = cell;
    }else if (ASHBBSType1V == model.bbs_type) {
        __weak ASH1VCell *cell =  (ASH1VCell *)tcell;
        cell.title.text = model.bbs_description;
        cell.name.text = model.bbs_title;
        cell.time.text = model.bbs_time;
        [cell.image1 ash_setImageWithURL:model.bbs_minPic ];
        
        tcell = cell;
    }
    return tcell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end