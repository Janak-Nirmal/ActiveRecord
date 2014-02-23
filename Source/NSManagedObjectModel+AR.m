//
//  NSManagedObjectModel+ActiveRecord.m
//  ActiveRecord
//
//  Created by Michal Konturek on 22/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import "NSManagedObjectModel+AR.h"

static dispatch_once_t pred;
static NSManagedObjectModel *sharedManagedObject;

@implementation NSManagedObjectModel (AR)

+ (instancetype)managedObjectModel {
    
    dispatch_once(&pred, ^{
        NSArray *bundles = [NSArray arrayWithObject:[NSBundle mainBundle]];
        sharedManagedObject = [NSManagedObjectModel mergedModelFromBundles:bundles];
    });
    
    return sharedManagedObject;
}

+ (instancetype)managedObjectModelWithName:(NSString *)modelName {
    
    dispatch_once(&pred, ^{
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:modelName withExtension:@"momd"];
        sharedManagedObject = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    });
    
    return sharedManagedObject;
}

@end
