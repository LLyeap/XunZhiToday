//
//  XZSearchVC.m
//  XunZhi
//
//  Created by 李雷 on 16/6/1.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import "XZSearchVC.h"

#import "XZSearchAnswerVC.h"

@interface XZSearchVC () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UISearchController *searchController;
@property (nonatomic, retain) NSMutableArray  *searchList;

@end

@implementation XZSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"搜索";
    self.searchList = [NSMutableArray array];
    [self createView];
}

#pragma mark - 自定义函数
- (void)createView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIBARHEIGHT, SCREENWIDTH, SCREENHEIGHT- NAVIBARHEIGHT-TABBARHEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    self.navigationItem.titleView = self.searchController.searchBar;
//    self.navigationItem.hidesBackButton = YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.searchList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *searchVCTableViewCellID = @"searchVCTableViewCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchVCTableViewCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchVCTableViewCellID];
    }
    cell.textLabel.text = _searchList[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *strText = cell.textLabel.text;
    
    XZSearchAnswerVC *serchAnswerVC = [[XZSearchAnswerVC alloc] init];
    serchAnswerVC.webViewStrUrl = [NSString stringWithFormat:@"http://ic.snssdk.com/2/wap/search/?iid=4315625960&search_sug=1&keyword=%@", strText];
    [self.navigationController pushViewController:serchAnswerVC animated:YES];
}
#pragma mark - UISearchBarDelegate
#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = [self.searchController.searchBar text];
    [self downloadSearchListWithKeyword:searchString];
}
#pragma mark - 网络数据
// >http://ic.snssdk.com/2/article/search_sug/?iid=4315625960&keyword=我
- (void)downloadSearchListWithKeyword:(NSString *)keyword {
    // >去掉不合法的请求空格
    keyword = [keyword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    // >对汉字编码, 果然汉字会出错
    NSString *encodedKeyword = [keyword stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    NSString *strUrl = [NSString stringWithFormat:@"http://ic.snssdk.com/2/article/search_sug/?iid=4315625960&keyword=%@", encodedKeyword];
    NSDictionary *dic = @{};
    __weak typeof(self) weakSelf = self;
    [NetRequest postDataWithURL:strUrl dic:dic success:^(id responseObject) {
        NSDictionary *dictDown = (NSDictionary *)responseObject;
        NSArray *mainDataArr = [dictDown objectForKey:@"data"];
        for (int i=0; i<mainDataArr.count; i++) {
            NSDictionary *mainDict = mainDataArr[i];
            [_searchList addObject:[mainDict objectForKey:@"keyword"]];
        }
        // >重新加载tableView
        [weakSelf.tableView reloadData];
    } filed:^(NSError *error) {
        
    }];
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}







@end







