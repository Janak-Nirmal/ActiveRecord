//
//  NSPersistentStoreCoordinator+ActiveRecord.m
//  ActiveRecord
//
//  Created by Michal Konturek on 22/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import "NSPersistentStoreCoordinator+AR.h"

#import "NSManagedObjectModel+AR.h"

@implementation NSPersistentStoreCoordinator (AR)

static dispatch_once_t pred;
static NSPersistentStoreCoordinator *sharedInstance;

+ (instancetype)persistentStoreCoordinator {
    
    dispatch_once(&pred, ^{
        NSString *fileName = @"Data.sqlite";
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:fileName];
        sharedInstance = [self persistentStoreCoordinatorWithURL:storeURL withType:NSSQLiteStoreType];
    });
    
    return sharedInstance;
}

+ (instancetype)persistentStoreCoordinatorWithAutoMigration {
    
    dispatch_once(&pred, ^{
        NSString *fileName = @"Data.sqlite";
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:fileName];
        sharedInstance = [self persistentStoreCoordinatoWithAutoMigrationrWithURL:storeURL withType:NSSQLiteStoreType];
    });
    
    return sharedInstance;
}

+ (instancetype )persistentStoreCoordinatorWithURL:(NSURL *)storeURL withType:(NSString *)storeType {
    return [self persistentStoreCoordinatorWithURL:storeURL withType:storeType withOptions:nil];
}

+ (instancetype)persistentStoreCoordinatoWithAutoMigrationrWithURL:(NSURL *)storeURL withType:(NSString *)storeType {
    NSDictionary *options = [self autoMigrationOptions];
    return [self persistentStoreCoordinatorWithURL:storeURL withType:storeType withOptions:options];
}

+ (instancetype )persistentStoreCoordinatorWithURL:(NSURL *)storeURL
                                          withType:(NSString *)storeType
                                       withOptions:(NSDictionary *)options {
    
    NSError *error = nil;
    NSManagedObjectModel *model = [NSManagedObjectModel managedObjectModel];
    sharedInstance = [[self alloc] initWithManagedObjectModel:model];
    
    if (![sharedInstance addPersistentStoreWithType:storeType configuration:nil URL:storeURL options:options error:&error]) {
        sharedInstance = nil;
#if DEBUG
        NSLog(@"*** Persistance Store Error: %@, %@, %@", error, [error userInfo], [error localizedDescription]);
        abort();
#endif
    }
    
    if (sharedInstance == nil) {
        NSString *format = @"Could not setup persistance store of type %@ at URL %@ (Error: %@)";
        [NSException raise:NSInternalInconsistencyException format:format, storeType, [storeURL absoluteURL], [error localizedDescription]];
    }
    
    return sharedInstance;
}

+ (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSDictionary *)autoMigrationOptions {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
            [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
            nil];
}


@end
