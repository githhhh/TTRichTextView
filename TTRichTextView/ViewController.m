//
//  ViewController.m
//  TTRichTextView
//
//  Created by bin on 2019/7/30.
//  Copyright © 2019 xp.bin.pro. All rights reserved.
//

#import "ViewController.h"
#import "RichTextViewController.h"
#import "DraftListViewController.h"
#import "PostRichEditViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"demoCell"];
    [self.view  addSubview:self.tableView];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"demoCell"];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"编辑器-html";
        
    }else if(indexPath.row == 1){
        
        cell.textLabel.text = @"编辑器-empty";
        
    }else{
        cell.textLabel.text = @"草稿";
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.row == 0) {
        PostRichEditViewController *vc = [PostRichEditViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.row == 1){
        
        PostRichEditViewController *vc = [PostRichEditViewController new];
        vc.isEmptyContent = YES;
        [self.navigationController pushViewController:vc animated:YES];

    }else{
        DraftListViewController *vc = [DraftListViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
