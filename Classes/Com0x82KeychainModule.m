/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "Com0x82KeyChainModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

#import "MySSKeychain.h"

@interface Com0x82KeyChainModule (Private)
	-(NSDictionary *)_validateOptions:(NSDictionary *)options;
	-(id)_validateAccessabilityOption:(NSNumber *)option;
@end

@implementation Com0x82KeyChainModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"0c76bec2-d685-4970-b12c-91eacecd8fc1";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"com.0x82.key.chain";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
	
	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma Public APIs

-(id)getPasswordForService:(id)args {
	enum {
		kArgService = 0,
		kArgAccount,
		kArgCount,
		kArgOptions = kArgCount
	};
	
	ENSURE_TYPE(args, NSArray);
	ENSURE_ARG_COUNT(args, kArgCount);
	
	NSString *service = [TiUtils stringValue:[args objectAtIndex:kArgService]];
	NSString *account = [TiUtils stringValue:[args objectAtIndex:kArgAccount]];
	NSDictionary *options = nil;
	if([args count] > kArgOptions) {
		ENSURE_TYPE([args objectAtIndex:kArgOptions], NSDictionary);
		options = [self _validateOptions:[args objectAtIndex:kArgOptions]];
	}
  
	NSError *error = NULL;
  NSString *password = [MySSKeychain passwordForService:service account:account options:options error:&error];
	
	if(error != nil) {
		NSLog(@"Keychain Get error: %@", [error description]);
	}
  
  return password;
}

-(void)setPasswordForService:(id)args {
	enum {
		kArgPassword = 0,
		kArgService,
		kArgAccount,
		kArgCount,
		kArgOptions = kArgCount
	};
	
	ENSURE_TYPE(args, NSArray);
	ENSURE_ARG_COUNT(args, kArgCount);
	
	NSString *password = [TiUtils stringValue:[args objectAtIndex:kArgPassword]];
	NSString *service = [TiUtils stringValue:[args objectAtIndex:kArgService]];
	NSString *account = [TiUtils stringValue:[args objectAtIndex:kArgAccount]];
	NSDictionary *options = nil;
	if([args count] > kArgOptions) {
		ENSURE_TYPE([args objectAtIndex:kArgOptions], NSDictionary);
		options = [self _validateOptions:[args objectAtIndex:kArgOptions]];
	}
  
	NSError *error = NULL;
  [MySSKeychain setPassword:password forService:service account:account options:options error:&error];
	
	if(error != nil) {
		NSLog(@"Keychain Set error: %@", [error description]);
	}
}

-(void)deletePasswordForService:(id)args {
	enum {
		kArgService = 0,
		kArgAccount,
		kArgCount,
		kArgOptions = kArgCount
	};
	
	ENSURE_TYPE(args, NSArray);
	ENSURE_ARG_COUNT(args, kArgCount);
	
	NSString *service = [TiUtils stringValue:[args objectAtIndex:kArgService]];
	NSString *account = [TiUtils stringValue:[args objectAtIndex:kArgAccount]];
	NSDictionary *options = nil;
	if([args count] > kArgOptions) {
		ENSURE_TYPE([args objectAtIndex:kArgOptions], NSDictionary);
		options = [self _validateOptions:[args objectAtIndex:kArgOptions]];
	}

	NSError *error = NULL;
  [MySSKeychain deletePasswordForService:service account:account options:options error:&error];
	
	if(error != nil) {
		NSLog(@"Keychain Delete error: %@", [error description]);
	}
}

-(NSDictionary *)_validateOptions:(NSDictionary *)options {
	if(options == nil)
		return options;
	
	NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithCapacity:[options count]];
	
	for(NSString *key in options) {
		id value = [options valueForKey:key];
		
		if([key isEqualToString:[self ATTR_ACCESSIBLE]]) {
			[newDict setObject:[self _validateAccessabilityOption:[TiUtils numberFromObject:value]] forKey:(id)kSecAttrAccessible];
		} else if([key isEqualToString:[self ATTR_ACCESS_GROUP]]) {
			[newDict setObject:[TiUtils stringValue:value] forKey:(id)kSecAttrAccessGroup];
		} else {
			NSLog(@"Unkown keychain option key %@", key);
		}
	}
	
	return newDict;
}

-(id)_validateAccessabilityOption:(NSNumber *)option {
	switch([option intValue]) {
		case kAttrAccessibleAfterFirstUnlock:
			return (id)kSecAttrAccessibleAfterFirstUnlock;
		case kAttrAccessibleWhenUnlocked:
			return (id)kSecAttrAccessibleWhenUnlocked;
		case kAttrAccessibleWhenUnlockedThisDeviceOnly:
			return (id)kSecAttrAccessibleWhenUnlockedThisDeviceOnly;
		case kAttrAccessibleAfterFirstUnlockThisDeviceOnly:
			return (id)kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly;
		case kAttrAccessibleAlways:
			return (id)kSecAttrAccessibleAlways;
		case kAttrAccessibleAlwaysThisDeviceOnly:
			return (id)kSecAttrAccessibleAlwaysThisDeviceOnly;
		default:
			return nil;
	}
}

enum {
	kAttrAccessibleWhenUnlocked = 0,
	kAttrAccessibleAfterFirstUnlock,
	kAttrAccessibleAfterFirstUnlockThisDeviceOnly,
	kAttrAccessibleAlways,
	kAttrAccessibleAlwaysThisDeviceOnly,
	kAttrAccessibleWhenUnlockedThisDeviceOnly
};

MAKE_SYSTEM_STR(ATTR_ACCESSIBLE, @"accessible")
MAKE_SYSTEM_STR(ATTR_ACCESS_GROUP, @"access_group")

MAKE_SYSTEM_PROP(ATTR_ACCESSIBLE_WHEN_UNLOCKED, kAttrAccessibleWhenUnlocked)
MAKE_SYSTEM_PROP(ATTR_ACCESSIBLE_AFTER_FIRST_UNLOCK, kAttrAccessibleAfterFirstUnlock)
MAKE_SYSTEM_PROP(ATTR_ACCESSIBLE_AFTER_FIRST_UNLOCK_THIS_DEVICE_ONLY, kAttrAccessibleAfterFirstUnlockThisDeviceOnly)
MAKE_SYSTEM_PROP(ATTR_ACCESSIBLE_ALWAYS, kAttrAccessibleAlways)
MAKE_SYSTEM_PROP(ATTR_ACCESSIBLE_ALWAYS_THIS_DEVICE_ONLY, kAttrAccessibleAlwaysThisDeviceOnly)
MAKE_SYSTEM_PROP(ATTR_ACESSIBLE_WHEN_UNLOCKED_THIS_DEVICE_ONLY, kAttrAccessibleWhenUnlockedThisDeviceOnly)

@end
