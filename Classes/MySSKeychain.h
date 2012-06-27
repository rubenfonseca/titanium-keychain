//
//  SSKeychain.h
//  SSToolkit
//
//  Created by Sam Soffes on 5/19/10.
//  Copyright 2009-2010 Sam Soffes. All rights reserved.
//

#import <Security/Security.h>

typedef enum {
	SSKeychainErrorBadArguments = -1001,
	SSKeychainErrorNoPassword = -1002,
	SSKeychainErrorInvalidParameter = errSecParam,
	SSKeychainErrorFailedToAllocated = errSecAllocate,
	SSKeychainErrorNotAvailable = errSecNotAvailable,
	SSKeychainErrorAuthorizationFailed = errSecAuthFailed,
	SSKeychainErrorDuplicatedItem = errSecDuplicateItem,
	SSKeychainErrorNotFound = errSecItemNotFound,
	SSKeychainErrorInteractionNotAllowed = errSecInteractionNotAllowed,
	SSKeychainErrorFailedToDecode = errSecDecode
} MySSKeychainErrorCode;

extern NSString *MySSKeychainErrorDomain;

@interface MySSKeychain : NSObject {
	
}

+ (NSString *)passwordForService:(NSString *)service account:(NSString *)account options:(NSDictionary *)options;
+ (NSString *)passwordForService:(NSString *)service account:(NSString *)account options:(NSDictionary *)options error:(NSError **)error;

+ (BOOL)deletePasswordForService:(NSString *)service account:(NSString *)account options:(NSDictionary *)options;
+ (BOOL)deletePasswordForService:(NSString *)service account:(NSString *)account options:(NSDictionary *)options error:(NSError **)error;

+ (BOOL)setPassword:(NSString *)password forService:(NSString *)service account:(NSString *)account options:(NSDictionary *)options;
+ (BOOL)setPassword:(NSString *)password forService:(NSString *)service account:(NSString *)account options:(NSDictionary *)options error:(NSError **)error;

@end
