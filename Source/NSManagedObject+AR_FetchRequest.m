//
//  NSManagedObject+NSFetchRequest.m
//  ActiveRecord
//
//  Created by Michal Konturek on 19/02/2014.
//  Copyright (c) 2014 Michal Konturek. All rights reserved.
//

#import "NSManagedObject+AR_FetchRequest.h"

#import "NSFetchRequest+ActiveRecord.h"
#import "NSManagedObject+ActiveRecord.h"

@implementation NSManagedObject (AR_FetchRequest)

+ (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate
                           withSortDescriptor:(NSSortDescriptor *)descriptor {
    
    return [self fetchRequestWithPredicate:predicate withSortDescriptors:@[descriptor]];
}

+ (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate
                          withSortDescriptors:(NSArray *)descriptors {
    
    id request = [NSFetchRequest createWithPredicate:predicate withSortDescriptors:descriptors];
    [request setEntity:[self entityDescription]];
    return request;
}

@end
