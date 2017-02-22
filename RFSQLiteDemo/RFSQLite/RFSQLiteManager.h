//
//  RFSQLiteManager.h
//  RFSQLiteDemo
//
//  Created by rocky on 2017/2/22.
//  Copyright © 2017年 RockyFung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "StudentModel.h"
@interface RFSQLiteManager : NSObject
// 创建表格
+ (void)creatTableWithTabName:(NSString *)tabName;

// 添加数据
+ (void)addStudentModel:(StudentModel *)stu;

//删除数据
+ (void)deleteDataWithName:(NSString *)name;

// 根据ID 更新、修改数据
+ (void)updataWithStu:(StudentModel *)stu;

// 查询所有数据
+ (NSMutableArray*)findAllDataWithTabName:(NSString *)tabName;

// 根据指定的ID，查找相对应的学生
+ (StudentModel *)findStudentByID:(int)ID;





@end
