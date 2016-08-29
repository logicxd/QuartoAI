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
        
        NSMutableSet *temporaryBoardPieces = [NSMutableSet setWithCapacity:16];
        for (NSInteger index = 0; index < 16; index++) {
            [temporaryBoardPieces addObject:@(index)];
        }
        
        NSLog(@"%@",temporaryBoardPieces);
        
        NSMutableDictionary *board = [@{
                                       @"0" : @4,
                                       @"1" : @5,
                                       } mutableCopy];
        
        for (NSNumber *piece in [board allValues]) {
            [temporaryBoardPieces removeObject:piece];
        }
        
        NSLog(@"%@",temporaryBoardPieces);
    }
    return 0;
}
