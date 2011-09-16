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

#import "SSKeychain.h"

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
  ENSURE_ARG_COUNT(args, 2);
  ENSURE_STRING([args objectAtIndex:0]);
  ENSURE_STRING([args objectAtIndex:1]);
  
  NSString *password = [SSKeychain passwordForService:[args objectAtIndex:0] account:[args objectAtIndex:1]];
  
  return password;
}

-(void)setPasswordForService:(id)args {
  ENSURE_ARG_COUNT(args, 3);
  ENSURE_STRING([args objectAtIndex:0]);
  ENSURE_STRING([args objectAtIndex:1]);
  ENSURE_STRING([args objectAtIndex:2]);
  
  [SSKeychain setPassword:[args objectAtIndex:0] forService:[args objectAtIndex:1] account:[args objectAtIndex:2]];
}

-(void)deletePasswordForService:(id)args {
  ENSURE_ARG_COUNT(args, 2);
  ENSURE_STRING([args objectAtIndex:0]);
  ENSURE_STRING([args objectAtIndex:1]);

  [SSKeychain deletePasswordForService:[args objectAtIndex:0] account:[args objectAtIndex:1]];
}

@end
