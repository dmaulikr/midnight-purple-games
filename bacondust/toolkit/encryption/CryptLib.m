
#import "CryptLib.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation StringEncryption

- (NSString *) encrypt: (NSData *) plainText key: (NSString *) key iv: (NSString *) iv {
    char keyPointer[kCCKeySizeAES256+2],// room for terminator (unused) ref: https://devforums.apple.com/message/876053#876053
    ivPointer[kCCBlockSizeAES128+2];
    BOOL patchNeeded;
    bzero(keyPointer, sizeof(keyPointer)); // fill with zeroes for padding
    patchNeeded= ([key length] > kCCKeySizeAES256 + 1);
    
    if(patchNeeded) {
        key = [key substringToIndex:kCCKeySizeAES256]; // Ensure that the key isn't longer than what's needed (kCCKeySizeAES256)
    }
    
    [key getCString:keyPointer maxLength:sizeof(keyPointer) encoding:NSUTF8StringEncoding];
    [iv getCString:ivPointer maxLength:sizeof(ivPointer) encoding:NSUTF8StringEncoding];
    
    if (patchNeeded) {
        keyPointer[0] = '\0';  // Previous iOS version than iOS7 set the first char to '\0' if the key was longer than kCCKeySizeAES256
    }
    
    NSUInteger dataLength = [plainText length];
    size_t buffSize = dataLength + kCCBlockSizeAES128;
    void *buff = malloc(buffSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus status = CCCrypt(kCCEncrypt, /* kCCEncrypt, etc. */
                                     kCCAlgorithmAES128, /* kCCAlgorithmAES128, etc. */
                                     kCCOptionPKCS7Padding, /* kCCOptionPKCS7Padding, etc. */
                                     keyPointer, kCCKeySizeAES256, /* key and its length */
                                     ivPointer, /* initialization vector - use random IV everytime */
                                     [plainText bytes], [plainText length], /* input  */
                                     buff, buffSize,/* data RETURNED here */
                                     &numBytesEncrypted);
    if (status == kCCSuccess) {
        NSData* n = [NSData dataWithBytesNoCopy:buff length:numBytesEncrypted];
        NSString* s = [n base64EncodedStringWithOptions: NSUTF8StringEncoding];
        return s;
    }
    
    free(buff);
    return nil;
}


-(NSString *) decrypt: (NSData *) encryptedText key:(NSString *) key iv: (NSString *) iv {
    char keyPointer[kCCKeySizeAES256 + 2],// room for terminator (unused) ref: https://devforums.apple.com/message/876053#876053
    ivPointer[kCCBlockSizeAES128 + 2];
    BOOL patchNeeded = ([key length] > kCCKeySizeAES256+1);
    
    if(patchNeeded) {
        key = [key substringToIndex:kCCKeySizeAES256]; // Ensure that the key isn't longer than what's needed (kCCKeySizeAES256)
    }
    
    [key getCString: keyPointer maxLength:sizeof(keyPointer) encoding: NSUTF8StringEncoding];
    [iv getCString: ivPointer maxLength:sizeof(ivPointer) encoding: NSUTF8StringEncoding];
    
    if (patchNeeded) {
        keyPointer[0] = '\0';  // Previous iOS version than iOS7 set the first char to '\0' if the key was longer than kCCKeySizeAES256
    }
    
    NSUInteger dataLength = [encryptedText length];
    size_t buffSize = dataLength + kCCBlockSizeAES128;
    void *buff = malloc(buffSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus status = CCCrypt(kCCDecrypt,/* kCCEncrypt, etc. */
                                     kCCAlgorithmAES128, /* kCCAlgorithmAES128, etc. */
                                     kCCOptionPKCS7Padding, /* kCCOptionPKCS7Padding, etc. */
                                     keyPointer, kCCKeySizeAES256,/* key and its length */
                                     ivPointer, /* initialization vector - use same IV which was used for decryption */
                                     [encryptedText bytes], [encryptedText length], //input
                                     buff, buffSize,//output
                                     &numBytesEncrypted);
    if (status == kCCSuccess) {
        NSData* n = [NSData dataWithBytesNoCopy:buff length:numBytesEncrypted];
        NSString* s = [[NSString alloc] initWithData:n encoding:NSUTF8StringEncoding];
        return s;
    }
    
    free(buff);
    return nil;
}

- (NSString*) generateRandomIV: (size_t) length {
    NSMutableData *data = [NSMutableData dataWithLength:length];
    NSAssert(SecRandomCopyBytes(NULL, length, data.mutableBytes) == 0, @"Error generating random bytes: %d", errno);
    NSString *base64EncodedData = [[data base64EncodedStringWithOptions:0] substringToIndex:length];
    return base64EncodedData;
}

- (NSString*) sha256: (NSString *) key length: (NSInteger) length{
    const char *s = [key cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH] = {0};
    CC_SHA256(keyData.bytes, (CC_LONG)keyData.length, digest);
    NSData* out = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString* hash = [out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    if(length > [hash length]) {
        return hash;
    } else {
        return [hash substringToIndex:length];
    }
}

@end
