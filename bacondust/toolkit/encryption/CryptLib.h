
#import <Foundation/Foundation.h>

@interface StringEncryption: NSObject
-  (NSString*)encrypt:(NSData *)plainText key:(NSString *)key iv:(NSString *)iv;
-  (NSString*)decrypt:(NSData *)encryptedText key:(NSString *)key iv:(NSString *)iv;
-  (NSString*) generateRandomIV:(size_t) length;
-  (NSString*) sha256:(NSString *)key length:(NSInteger) length;
@end
