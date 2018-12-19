//
//  ViewController.m
//  AlertView
//
//  Created by goviewtech on 2018/12/19.
//  Copyright © 2018 goviewtech. All rights reserved.
//

#import "ViewController.h"

#import "BDNomalAlertView.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak)UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect frame = self.view.bounds;
    frame.size.height -= [UIApplication sharedApplication].statusBarFrame.size.height+44;
    UITableView *tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
}


#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"CELL_ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    NSString *text = [NSString stringWithFormat:@"第%ld中演示",indexPath.row+1];
    cell.textLabel.text = text;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self showAlertWithTag:indexPath.row];
}

- (void)showAlertWithTag:(NSInteger)tag
{
    BDNomalAlertView *alertView = nil;
    NSString *showMsg = @"每天进步一点点，年年就是进步一大步，请多多关注";
    BDNomalAlertAction *cancelAction = nil;
    BDNomalAlertAction *sureAction = nil;
    if(tag == 2){
        showMsg = @"但是，这些人真的是缺少这199元押金吗？还是缺少这么一个可以欺凌的对象，来展示他们的威严？中国有句话叫得理不饶人，用来形容他们最不为过。199元而已，退押金固然重要，但这真的至于上门要债吗？不知道这些人还记不记得，曾经靠芝麻信用分免费骑行的日子？曾经把小黄车扔进河里的快感？把小黄车私自上锁据为己有时的暗爽？原本以为科技的进步，共享经济的诞生会让人们更加理性，更加自觉和文明。但实际上是，有些人被免费使用惯坏了，惯成了故步自封，惯成了胆小，惯成了傲慢与偏见,跑过千军万马，走过独木桥，最后只剩一把辛酸泪。戴维还在坚持着，他坚信ofo会挺过去，这或许是一个创业者的无奈，也或者是一个创业者最后的尊严。啦啦啦纯粹凑数字的m，看看效果";
    }
        
    alertView = [BDNomalAlertView alertControllerWithTitle:@"友情提示" message:showMsg];
    
    if(tag % 2 == 0){
        cancelAction = [BDNomalAlertAction actionWithTitle:@"取消" style:[BDNomalAlertActionStyle cancelNomalStyle] handler:nil];
        sureAction = [BDNomalAlertAction actionWithTitle:@"确定" style:[BDNomalAlertActionStyle sureNomalStyle] handler:^(BDNomalAlertAction *action) {
            NSLog(@"你好...");
        }];
    }else{
        sureAction = [BDNomalAlertAction actionWithTitle:@"确定" style:[BDNomalAlertActionStyle sureNomalStyle] handler:nil];
    }
    if(sureAction){
        [alertView addAction:sureAction];
    }
    if(cancelAction){
        [alertView addAction:cancelAction];
    }
    [alertView showAlertView];
}



@end
