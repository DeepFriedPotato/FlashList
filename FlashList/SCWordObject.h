//
//  SCWordObject.h
//  FlashList
//
//  Created by Steven Shen on 7/21/14.
//  Copyright (c) 2014 Steven Shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCWordObject : NSObject

@property NSString *wordTitle;
@property NSInteger *correctCount;
@property NSInteger *wrongCount;
@property NSDate *createdDate;

- (instancetype) initWithWordTitle:(NSString *)word;
- (NSString *)description;

@end
