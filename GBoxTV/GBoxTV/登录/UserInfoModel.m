//
//  UserInfoModel.m
//  GBoxTV
//
//  Created by PC_201310113421 on 16/4/19.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "UserInfoModel.h"
#import "AppDelegate.h"

@implementation UserInfoModel

+(void)insertModel:(UserInfoModel *)model{
//    AppDelegate *appdelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
//    NSManagedObjectContext  *context=appdelegate.managedObjectContext;
//    
//    //    //存在model不
//    //    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"username==%@",model.username];
//    //    NSFetchRequest  *request=[[NSFetchRequest alloc]initWithEntityName:@"UserInfoDB"];
//    //    request.predicate=predicate;
//    //
//    NSError *error=nil;
//    //    NSArray *existModels=[context executeFetchRequest:request error:&error];
//    //
//    //    if (existModels==nil||existModels.count<=0) {
//    NSEntityDescription *description=[NSEntityDescription entityForName:@"UserInfoDB" inManagedObjectContext:context];
//    
//    UserInfoDB *newmodel=[[UserInfoDB alloc]initWithEntity:description insertIntoManagedObjectContext:context];
//    [newmodel setUsername:model.username];
//    [newmodel setPwd:model.pwd];
//    [newmodel setSesion:model.sesion];
//    [newmodel setExpiredtime:model.expiredtime];
//    [newmodel setIsuse:[NSNumber numberWithBool:model.isuse]];
//    
//    [context save:&error];
//    //    }
}
+(void)deleteModelWithUsername:(NSString *)userName{
//    AppDelegate *appdelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
//    NSManagedObjectContext  *context=appdelegate.managedObjectContext;
//    
//    //存在model不
//    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"username==%@",userName];
//    NSFetchRequest  *request=[[NSFetchRequest alloc]initWithEntityName:@"UserInfoDB"];
//    request.predicate=predicate;
//    
//    NSError *error=nil;
//    NSArray *existModels=[context executeFetchRequest:request error:&error];
//    if (existModels) {
//        for (UserInfoDB *model in existModels) {
//            [context deleteObject:model];
//        }
//    }
//    [context save:&error];
}
+(BOOL)existModelWithUsername:(NSString *)userName{
//    AppDelegate *appdelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
//    NSManagedObjectContext  *context=appdelegate.managedObjectContext;
//    
//    //存在model不
//    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"username==%@",userName];
//    NSFetchRequest  *request=[[NSFetchRequest alloc]initWithEntityName:@"UserInfoDB"];
//    request.predicate=predicate;
//    
//    NSError *error=nil;
//    NSArray *existModels=[context executeFetchRequest:request error:&error];
//    if (existModels&&existModels.count>0) {
//        return YES;
//    }
//    else{
//        return NO;
//    }
    return NO;
    
}
+(void)updateModel:(UserInfoModel *)model{
//    AppDelegate *appdelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
//    NSManagedObjectContext  *context=appdelegate.managedObjectContext;
//    
//    //存在model不
//    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"username==%@",model.username];
//    NSFetchRequest  *request=[[NSFetchRequest alloc]initWithEntityName:@"UserInfoDB"];
//    request.predicate=predicate;
//    
//    NSError *error=nil;
//    NSArray *existModels=[context executeFetchRequest:request error:&error];
//    
//    if (existModels&&existModels.count>0) {
//        for (UserInfoDB *updatemodel in existModels) {
//            if (![updatemodel.expiredtime isEqualToString:model.expiredtime]) {
//                [updatemodel setExpiredtime:model.expiredtime];
//            }
//            if (![updatemodel.sesion isEqualToString:model.sesion]) {
//                updatemodel.sesion=model.sesion;
//            }
//            if (![updatemodel.pwd isEqualToString:model.pwd]) {
//                updatemodel.pwd=model.pwd;
//            }
//            if ([updatemodel.isuse boolValue]==model.isuse) {
//                updatemodel.isuse=[NSNumber numberWithBool:model.isuse];
//            }
//        }
//        
//        [context save:&error];
//    }
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.expiredtime forKey:@"expiredtime"];
    [aCoder encodeObject:self.pwd forKey:@"pwd"];
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.sesion forKey:@"sesion"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.isuse] forKey:@"isuse"];
    
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self=[super init];
    if (self) {
        self.expiredtime=[aDecoder decodeObjectForKey:@"expiredtime"];
        self.pwd=[aDecoder decodeObjectForKey:@"pwd"];
        self.username=[aDecoder decodeObjectForKey:@"username"];
        self.sesion=[aDecoder decodeObjectForKey:@"sesion"];
        self.isuse=[[aDecoder decodeObjectForKey:@"isuse"] boolValue];
        
    }
    return self;
}


@end
