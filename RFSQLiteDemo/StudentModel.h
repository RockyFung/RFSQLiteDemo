//
//  StudentModel.h
//  RFSQLiteDemo
//
//  Created by rocky on 2017/2/22.
//  Copyright © 2017年 RockyFung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudentModel : NSObject
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, assign) NSInteger age;
@end
