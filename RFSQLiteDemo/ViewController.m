//
//  ViewController.m
//  RFSQLiteDemo
//
//  Created by rocky on 2017/2/22.
//  Copyright © 2017年 RockyFung. All rights reserved.
//

#import "ViewController.h"
#import "RFSQLiteManager.h"
#import "StudentModel.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

 // 新建表格
- (IBAction)creatTab:(UIButton *)sender {
   
    [RFSQLiteManager creatTableWithTabName:@"student"];
}


// 添加数据
- (IBAction)insertData:(id)sender {
    
    NSArray *names = @[@"路飞",@"娜美",@"左罗"];
    NSArray *emails = @[@"lufei@126.com",@"namei@126.com",@"zuoluo@126.com"];
    NSArray *ages = @[@22,@18,@25];
    for (int i = 0; i < 3; i++) {
        StudentModel *model = [[StudentModel alloc]init];
        model.number = arc4random()%1000 + 100;
        model.name = names[i];
        model.age = [ages[i]integerValue];
        model.sex = i == 1 ? @"male" : @"female";
        model.email = emails[i];
        [RFSQLiteManager addStudentModel:model];
    }
}

// 根据名字删除数据
- (IBAction)deleteData:(id)sender {
    [RFSQLiteManager deleteDataWithName:@"路飞"];
}

// 根据表名查询所有数据
- (IBAction)findAllData:(id)sender {
    [RFSQLiteManager findAllDataWithTabName:@"student"];
}

// 根据ID找数据
- (IBAction)findOneData:(id)sender {
    [RFSQLiteManager findStudentByID:3];
}

// 更新，修改数据
- (IBAction)upateData:(id)sender {
    StudentModel *model = [[StudentModel alloc]init];
    model.number = 1;
    model.name = @"娜美2";
    model.age = 16;
    model.sex = @"female2";
    model.email = @"namei22@163.com";
    [RFSQLiteManager updataWithStu:model];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
