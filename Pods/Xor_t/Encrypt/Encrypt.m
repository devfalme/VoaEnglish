//
//  Encrypt.c
//  Xor
//
//  Created by devfalme on 2018/12/11.
//  Copyright © 2018 devfalme. All rights reserved.
//

#import "Encrypt.h"

//因子
static NSString const *factor = @"3b453f04a6d54485a9672f7deafaeaf9";


void setFactor(NSString *string) {
    factor = string;
}

NSString *decode(NSString *string) {
    return encode(string);
}

NSString *encode(NSString *string) {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSInteger length = factor.length;
    const char *keys = [factor cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cKey[length];
    memcpy(cKey, keys, length);
    NSMutableData *encryptData = [[NSMutableData alloc] initWithCapacity:length];
    const Byte *point = data.bytes;
    for (int i = 0; i < data.length; i++) {
        int l = i % length;
        char c = cKey[l];
        Byte b = (Byte) ((point[i]) ^ c);
        [encryptData appendBytes:&b length:1];
    }
    return [[NSString alloc] initWithData:encryptData.copy encoding:NSUTF8StringEncoding];
}
