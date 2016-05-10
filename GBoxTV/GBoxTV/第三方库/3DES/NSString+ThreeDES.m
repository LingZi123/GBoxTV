//
//  NSString+ThreeDES.m
//  3DE
//
//  Created by Brandon Zhu on 31/10/2012.
//  Copyright (c) 2012 Brandon Zhu. All rights reserved.
//

#import "NSString+ThreeDES.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import "GTMBase64.h"

#define gkey @"b0326c4f1e0e2c2970584b14a5a36d1886b4b115"
#define gIv  @"01234567"
#define kSecrectKeyLength 8
@implementation NSString (ThreeDES)

+ (NSString*)encrypt:(NSString*)plainText withKey:(NSString*)key{
    const char *cstr = [key cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData = [NSData dataWithBytes:cstr length:key.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(keyData.bytes, keyData.length, digest);
    
    uint8_t keyByte[kSecrectKeyLength];
    
    if (keyData.length>=kSecrectKeyLength) {
        for (int i=0; i<kSecrectKeyLength; i++) {
            keyByte[i]=48;
        }
        
    }
    else{
        for (int i=0; i<keyData.length; i++) {
//            if (i>=keyData.length) {
                keyByte[i]=48;
//            }
//            else{
//            keyByte[i]=digest[i];
//            }
        }
    }

    
    
//    for (int i=0; i<16; i++) {
//        keyByte[i] = digest[i];
//    }
//    for (int i=0; i<8; i++) {
//        keyByte[16+i] = digest[i];
//    }
    
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    size_t plainTextBufferSize = [data length];
    const void *vplainText = (const void *)[data bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) keyByte;
    const void *vinitVec = (const void *) [gIv UTF8String];
    
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithmDES, //有修改
                       kCCOptionPKCS7Padding|kCCOptionECBMode,
                       vkey,
                       kCCKeySizeDES,//有修改
                       nil,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    NSString *result =[self hexStringFromData:myData];
//    [GTMBase64 stringByEncodingData:myData];
    return result;
}

+ (NSString*)decrypt:(NSString*)encryptText withKey:(NSString*)key{
    
    const char *cstr = [key cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:key.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    uint8_t keyByte[kSecrectKeyLength];
    for (int i=0; i<16; i++) {
        keyByte[i] = digest[i];
    }
    for (int i=0; i<8; i++) {
        keyByte[16+i] = digest[i];
    }
    
    NSData *encryptData = [GTMBase64 decodeData:[encryptText dataUsingEncoding:NSUTF8StringEncoding]];
    size_t plainTextBufferSize = [encryptData length];
    const void *vplainText = [encryptData bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) keyByte;
    NSLog(@"kkk %s",vkey);
    const void *vinitVec = (const void *) [gIv UTF8String];
    
    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithmDES,//有修改
                       kCCOptionPKCS7Padding|kCCOptionECBMode,//有修改
                       vkey,
                       kCCKeySizeDES,//有修改
                       nil,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSString *result = [[[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                                      length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding] autorelease];
    return result;
}
- (NSString*) sha1
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}


#pragma mark-
+(NSString *)hexStringFromData:(NSData *)data
{
    NSMutableString *str = [NSMutableString string];
    
    Byte *byte = (Byte *)[data bytes];
    
    for (int i = 0; i<[data length]; i++) {
        
        // byte+i为指针
        [str appendString:[self stringFromByte:*(byte+i)]];
        
    }
    return str;
}

+(NSString *)stringFromByte:(Byte)byteVal
{
    NSMutableString *str = [NSMutableString string];
    //取高四位
    
    Byte byte1 = byteVal>>4;
    //取低四位
    
    Byte byte2 = byteVal & 0xf;
    
    //拼接16进制字符串
    [str appendFormat:@"%x",byte1];
    
    [str appendFormat:@"%x",byte2];
    
    return str;
}


@end
