//
//  main.m
//  Play
//
//  Created by Aung Moe on 8/27/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSArray<NSNumber *> *rowArray = @[@2, @3, @12, @13];
        
        NSMutableArray<NSNumber *> *attributesInRow = [NSMutableArray arrayWithCapacity:4];
        for (NSInteger index = 0; index < 4; index++) {
            NSInteger num = rowArray[index].integerValue;
            
            if (num == 0) {
                [attributesInRow setObject:@(0000) atIndexedSubscript:index];
            } else if (num == 1) {
                [attributesInRow setObject:@(0001) atIndexedSubscript:index];
            } else if (num == 2) {
                [attributesInRow setObject:@(0010) atIndexedSubscript:index];
            } else if (num == 3) {
                [attributesInRow setObject:@(0011) atIndexedSubscript:index];
            } else if (num == 4) {
                [attributesInRow setObject:@(0100) atIndexedSubscript:index];
            } else if (num == 5) {
                [attributesInRow setObject:@(0101) atIndexedSubscript:index];
            } else if (num == 6) {
                [attributesInRow setObject:@(0110) atIndexedSubscript:index];
            } else if (num == 7) {
                [attributesInRow setObject:@(0111) atIndexedSubscript:index];
            } else if (num == 8) {
                [attributesInRow setObject:@(1000) atIndexedSubscript:index];
            } else if (num == 9) {
                [attributesInRow setObject:@(1001) atIndexedSubscript:index];
            } else if (num == 10) {
                [attributesInRow setObject:@(1010) atIndexedSubscript:index];
            } else if (num == 11) {
                [attributesInRow setObject:@(1011) atIndexedSubscript:index];
            } else if (num == 12) {
                [attributesInRow setObject:@(1100) atIndexedSubscript:index];
            } else if (num == 13) {
                [attributesInRow setObject:@(1101) atIndexedSubscript:index];
            } else if (num == 14) {
                [attributesInRow setObject:@(1110) atIndexedSubscript:index];
            } else if (num == 15) {
                [attributesInRow setObject:@(1111) atIndexedSubscript:index];
            }
        }
        NSLog(@"%@", attributesInRow);
    }
    return 0;
}
