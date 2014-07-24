//
//  SCWordObject.m
//  FlashList
//
//  Created by Steven Shen on 7/21/14.
//  Copyright (c) 2014 Steven Shen. All rights reserved.
//

#import "SCWordObject.h"

@implementation SCWordObject



- (instancetype)initWithWordTitle:(NSString *)word{
    self = [super init];
    if (self){
        _wordTitle = word;
        _correctCount = 0;
        _wrongCount = 0;
        _createdDate = [NSDate date];
    }
    return self;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"Summary for \"%@\", Created on %@", _wordTitle, _createdDate];
}

@end