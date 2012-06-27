//
//  SSKeychain.m
//  SSToolkit
//
//  Created by Sam Soffes on 5/19/10.
//  Copyright 2009-2010 Sam Soffes. All rights reserved.
//

#import "MySSKeychain.h"

NSString *MySSKeychainErrorDomain = @"com.samsoffes.sskeychain";

@interface MySSKeychain (PrivateMethods)
+ (NSMutableDictionary *)_keychainQueryForService:(NSString *)service account:(NSString *)account options:(NSDictionary *)options;
@end

@implementation MySSKeychain

#pragma mark Class Methods

+ (NSMutableDictionary *)_keychainQueryForService:(NSString *)service account:(NSString *)account options:(NSDictionary *)options {
	NSMutableDictionary *res = [NSMutableDictionary dictionary];
	
	[res setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
	[res setObject:account forKey:(id)kSecAttrAccount];
	[res setObject:service forKey:(id)kSecAttrService];
	
	if(options != nil) {
		for(id key in options) {
			// NSLog(@"---> %@ ---> %@", key, [options valueForKey:key]);
			[res setObject:[options valueForKey:key] forKey:key];
		}
	}
	
	return res;
}

+ (NSString *)passwordForService:(NSString *)service account:(NSString *)account options:(NSDictionary *)options {
	return [self passwordForService:service account:account options:options error:nil];
}

+ (NSString *)passwordForService:(NSString *)service account:(NSString *)account options:(NSDictionary *)options error:(NSError **)error {
	OSStatus status = SSKeychainErrorBadArguments;
	NSString *result = nil;
	
	if (0 < [service length] && 0 < [account length]) {
		CFDataRef passwordData = NULL;
		NSMutableDictionary *keychainQuery = [self _keychainQueryForService:service account:account options:options];
		[keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
		[keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
		
		status = SecItemCopyMatching((CFDictionaryRef)keychainQuery,
											  (CFTypeRef *)&passwordData);
		if (status == noErr && 0 < [(NSData *)passwordData length]) {
			result = [[[NSString alloc] initWithData:(NSData *)passwordData
											encoding:NSUTF8StringEncoding] autorelease];
		}
		
		if (passwordData != NULL) {
			CFRelease(passwordData);
		}
	}
	
	if (status != noErr && status != errSecItemNotFound && error != NULL) {
		*error = [NSError errorWithDomain:MySSKeychainErrorDomain code:status userInfo:nil];
	}
	
	return result;
}


+ (BOOL)deletePasswordForService:(NSString *)service account:(NSString *)account options:(NSDictionary *)options {
	return [self deletePasswordForService:service account:account options:options error:nil];
}


+ (BOOL)deletePasswordForService:(NSString *)service account:(NSString *)account options:(NSDictionary *)options error:(NSError **)error {
	OSStatus status = SSKeychainErrorBadArguments;
	if (0 < [service length] && 0 < [account length]) {
		NSMutableDictionary *keychainQuery = [self _keychainQueryForService:service account:account options:options];
		status = SecItemDelete((CFDictionaryRef)keychainQuery);
	}
	
	if (status != noErr && status != errSecItemNotFound && error != NULL) {
		*error = [NSError errorWithDomain:MySSKeychainErrorDomain code:status userInfo:nil];
	}
	
	return status == noErr;
}


+ (BOOL)setPassword:(NSString *)password forService:(NSString *)service account:(NSString *)account options:(NSDictionary *)options {
	return [self setPassword:password forService:service account:account options:options error:nil];
}


+ (BOOL)setPassword:(NSString *)password forService:(NSString *)service account:(NSString *)account options:(NSDictionary *)options error:(NSError **)error {
	OSStatus status = SSKeychainErrorBadArguments;
	if (0 < [service length] && 0 < [account length]) {
		[self deletePasswordForService:service account:account options:options];
		if (0 < [password length]) {
			NSMutableDictionary *keychainQuery = [self _keychainQueryForService:service account:account options:options];
			NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
			[keychainQuery setObject:passwordData forKey:(id)kSecValueData];
			status = SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
		}
	}
	
	if (status != noErr && error != NULL) {
		*error = [NSError errorWithDomain:MySSKeychainErrorDomain code:status userInfo:nil];
	}
	
	return status == noErr;
}

@end
