//
//  NSString+Hash.m
//  断点续传_01
//
//  Created by 吴锡坤 on 5/13/18.
//  Copyright © 2018 吴锡坤. All rights reserved.
//

#import "NSString+Hash.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation NSString (Hash)

- (NSString *)md5String
{
    const char *string = self.UTF8String;
    int length = (int)strlen(string);
    unsigned char bytes[CC_MD5_DIGEST_LENGTH];
    CC_MD5(string, length, bytes);
    NSString* md5 = [self stringFromBytes:bytes length:CC_MD5_DIGEST_LENGTH];
    return md5;
    
}

- (NSString *)sha1String
{
    const char *string = self.UTF8String;
    int length = (int)strlen(string);
    unsigned char bytes[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(string, length, bytes);
    return [self stringFromBytes:bytes length:CC_SHA1_DIGEST_LENGTH];
}

- (NSString *)sha256String
{
    const char *string = self.UTF8String;
    int length = (int)strlen(string);
    unsigned char bytes[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(string, length, bytes);
    return [self stringFromBytes:bytes length:CC_SHA256_DIGEST_LENGTH];
}

- (NSString *)hmacSHA1StringWithKey:(NSString *)key{
    
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *messageData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *multableData = [NSMutableData dataWithLength:CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, keyData.bytes, keyData.length, messageData.bytes, messageData.length, multableData.mutableBytes);
    return [self stringFromBytes:(unsigned char *)multableData.bytes length:(int)multableData.length];

}
- (NSString *)hmacSHA256StringWithKey:(NSString *)key{
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *messageData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *multableData = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, keyData.bytes, keyData.length, messageData.bytes, messageData.length, multableData.mutableBytes);
    return [self stringFromBytes:(unsigned char *)multableData.bytes length:(int)multableData.length];

}

- (NSString *)hmacSHA512StringWithKey:(NSString *)key{
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *messageData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *multableData = [NSMutableData dataWithLength:CC_SHA512_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA512, keyData.bytes, keyData.length, messageData.bytes, messageData.length, multableData.mutableBytes);
    return [self stringFromBytes:(unsigned char *)multableData.bytes length:(int)multableData.length];
}

#pragma mark - Helpers
- (NSString *)stringFromBytes:(unsigned char *)bytes length:(int)length{
    
//    NSMutableString *mutableString = @"".mutableCopy;
//    for (int i =0; i < length; i ++) {
//        [mutableString appendFormat:@"%02x", bytes[i]];
//
//    }
//    
//    return [NSString stringWithString:mutableString];
    
    NSMutableString *mutableString = @"".mutableCopy;
    for (int i = 0; i < length; i++)
        [mutableString appendFormat:@"%02x", bytes[i]];
    return [NSString stringWithString:mutableString];
}







@end
