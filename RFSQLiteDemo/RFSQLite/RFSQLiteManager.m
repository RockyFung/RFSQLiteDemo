//
//  RFSQLiteManager.m
//  RFSQLiteDemo
//
//  Created by rocky on 2017/2/22.
//  Copyright © 2017年 RockyFung. All rights reserved.
//

#import "RFSQLiteManager.h"

static sqlite3* db = nil;// 指向数据库的指针

@implementation RFSQLiteManager

// 打开数据库
+ (sqlite3 *)openDB{
    // 此方法的主要作用是打开数据库
    // 返回值是一个数据库指针
    // 因为这个数据库在很多的SQLite API（函数）中都会用到，我们声明一个类方法来获取，更加方便
    
    // 懒加载
    if (db != nil) {
        return db;
    }
    
    // 获取Documents路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    // 生成数据库文件在沙盒中的路径
    NSString *sqlPath = [docPath stringByAppendingPathComponent:@"sqliteDB.sqlite"];
    NSLog(@"生成路径：%@",sqlPath);
    
    // 创建文件管理对象
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 判断沙盒路径中是否存在数据库文件，如果不存在才执行拷贝操作，如果存在不在执行拷贝操作
    if ([fileManager fileExistsAtPath:sqlPath] == NO) {
        // 获取数据库文件在包中的路径
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sqliteDB" ofType:@"sqlite"];
        
        // 使用文件管理对象进行拷贝操作
        // 第一个参数是拷贝文件的路径
        // 第二个参数是将拷贝文件进行拷贝的目标路径
        [fileManager copyItemAtPath:filePath toPath:sqlPath error:nil];
        
    }
    
    // 打开数据库需要使用一下函数
    // 第一个参数是数据库的路径（因为需要的是C语言的字符串，而不是NSString所以必须进行转换）
    // 第二个参数是指向指针的指针
    int result = sqlite3_open([sqlPath UTF8String], &db);
    //判断
    if (result == SQLITE_OK) {
        NSLog(@"数据库打开成功");
    } else {
        NSLog(@"数据库打开失败");
    }
    return db;
}
// 关闭数据库
+ (void)closeDB{
    int result = sqlite3_close(db);
    if (result == SQLITE_OK) {
        NSLog(@"数据库关闭成功");
    } else {
        NSLog(@"数据库关闭失败");
    }
    db = nil;
}


// 新建表格
+ (void)creatTableWithTabName:(NSString *)tabName{
    // 1.准备sqlite语句
    NSString *sqlite = [NSString stringWithFormat:@"create table if not exists '%@' ('ID' integer primary key autoincrement not null,'name' text,'sex' text,'age' integer, 'email' text)",tabName];
    
    // 2.打开数据库
    sqlite3 *db = [RFSQLiteManager openDB];
    
    // 3.执行sqlite语句
    char *error = NULL;//执行sqlite语句失败的时候,会把失败的原因存储到里面
    int result = sqlite3_exec(db, [sqlite UTF8String], nil, nil, &error);
    
    // 4.sqlite语句是否执行成功
    
    if (result == SQLITE_OK) {
        NSLog(@"创建表成功 tabName:%@",tabName);
    } else {
        NSLog(@"创建表失败 %s",error);
    }
    
    // 5.关闭数据库
    [RFSQLiteManager closeDB];
}

// 添加数据
+ (void)addStudentModel:(StudentModel *)stu{
    sqlite3 *db = [RFSQLiteManager openDB];
    
    //1.准备sqlite语句
    NSString *sqlite = [NSString stringWithFormat:@"insert into student(name,sex,age,email) values ('%@','%@','%ld','%@')",stu.name,stu.sex,stu.age,stu.email];
    //2.执行sqlite语句
    char *error = NULL;//执行sqlite语句失败的时候,会把失败的原因存储到里面
    int result = sqlite3_exec(db, [sqlite UTF8String], nil, nil, &error);
    if (result == SQLITE_OK) {
        NSLog(@"添加数据成功 name:%@ sex:%@ age:%ld email:%@",stu.name, stu.sex, stu.age, stu.email);
    } else {
        NSLog(@"添加数据失败 %s",error);
    }
}

// 删除数据
+ (void)deleteDataWithName:(NSString *)name {
    sqlite3 *db =[RFSQLiteManager openDB];
    //1.准备sqlite语句
    NSString *sqlite = [NSString stringWithFormat:@"delete from student where name = '%@'",name];
    //2.执行sqlite语句
    char *error = NULL;//执行sqlite语句失败的时候,会把失败的原因存储到里面
    int result = sqlite3_exec(db, [sqlite UTF8String], nil, nil, &error);
    if (result == SQLITE_OK) {
        NSLog(@"删除数据成功 name:%@被删除",name);
    } else {
        NSLog(@"删除数据失败 %s",error);
    }
}


// 根据ID 更新、修改数据
+ (void)updataWithStu:(StudentModel *)stu {
    
    sqlite3 *db =[RFSQLiteManager openDB];
    //1.sqlite语句
    NSString *sqlite = [NSString stringWithFormat:@"update student set name = '%@',sex = '%@',age = '%ld' where ID = '%ld'",stu.name,stu.sex,stu.age,stu.number];
    //2.执行sqlite语句
    char *error = NULL;//执行sqlite语句失败的时候,会把失败的原因存储到里面
    int result = sqlite3_exec(db, [sqlite UTF8String], nil, nil, &error);
    if (result == SQLITE_OK) {
        NSLog(@"修改数据成功 ID:%ld  新数据--> name:%@ sex:%@ age:%ld email:%@ ",stu.number,stu.name, stu.sex, stu.age, stu.email);
    } else {
        NSLog(@"修改数据失败 %s",error);
    }
}


// 查询所有数据
+ (NSMutableArray*)findAllDataWithTabName:(NSString *)tabName {
    
    sqlite3 *db =[RFSQLiteManager openDB];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    //1.准备sqlite语句
    NSString *sqlite = [NSString stringWithFormat:@"select * from %@",tabName];
    //2.伴随指针
    sqlite3_stmt *stmt = NULL;
    //3.预执行sqlite语句
    int result = sqlite3_prepare(db, sqlite.UTF8String, -1, &stmt, NULL);//第4个参数是一次性返回所有的参数,就用-1
    if (result == SQLITE_OK) {
        NSLog(@"查询成功");
        //4.执行n次
        // SQLite_ROW仅用于查询语句，sqlite3_step()函数执行后的结果如果是SQLite_ROW，说明结果集里面还有数据，会自动跳到下一条结果，如果已经是最后一条数据，再次执行sqlite3_step()，会返回SQLite_DONE，结束整个查询
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            StudentModel *stu = [[StudentModel alloc] init];
            //从伴随指针获取数据,第0列
            // 第一个参数是语句对象，第二个参数是字段的下标，从0开始
            stu.number = sqlite3_column_int(stmt, 0);
            //从伴随指针获取数据,第1列
            stu.name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)] ;
            //从伴随指针获取数据,第2列
            stu.sex = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)] ;
            //从伴随指针获取数据,第3列
            stu.age = sqlite3_column_int(stmt, 3);
            //从伴随指针获取数据,第4列
            stu.email = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
            
            [array addObject:stu];
            NSLog(@"找到数据 ID:%ld name:%@ sex:%@ age:%ld email:%@ ",stu.number,stu.name, stu.sex, stu.age, stu.email);
        }
        NSLog(@"共 %ld 条数据",array.count);
    } else {
        NSLog(@"查询失败");
    }
    //5.关闭伴随指针
    sqlite3_finalize(stmt);
    return array;
}

// 根据指定的ID，查找相对应的学生
+ (StudentModel *)findStudentByID:(int)ID {
    
    // 打开数据库
    sqlite3 *db = [RFSQLiteManager openDB];
    
    // 创建一个语句对象
    sqlite3_stmt *stmt = nil;
    
    StudentModel *stu = [[StudentModel alloc] init];
    
    // 生成语句对象
    int result = sqlite3_prepare_v2(db, "select * from student where ID = ?", -1, &stmt, nil); // student表查找
    
    if (result == SQLITE_OK) {
        
        // 如果查询语句或者其他sql语句有条件，在准备语句对象的函数内部，sql语句中用？来代替条件，那么在执行语句之前，一定要绑定
        // 1代表sql语句中的第一个问号，问号的下标是从1开始的
        sqlite3_bind_int(stmt, 1, ID);
        
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            
            
            //从伴随指针获取数据,第0列
            // 第一个参数是语句对象，第二个参数是字段的下标，从0开始
            stu.number = sqlite3_column_int(stmt, 0);
            //从伴随指针获取数据,第1列
            stu.name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)] ;
            //从伴随指针获取数据,第2列
            stu.sex = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)] ;
            //从伴随指针获取数据,第3列
            stu.age = sqlite3_column_int(stmt, 3);
            //从伴随指针获取数据,第4列
            stu.email = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
            
        }
    }
    NSLog(@"根据ID找到数据 ID:%ld name:%@ sex:%@ age:%ld email:%@ ",stu.number,stu.name, stu.sex, stu.age, stu.email);

    // 先释放语句对象
    sqlite3_finalize(stmt);
    return stu;
    
}
















@end
