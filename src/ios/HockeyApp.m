#import "HockeyApp.h"
#import <HockeySDK/HockeySDK.h>
#import <Cordova/CDVViewController.h>

@implementation HockeyApp

- (id)init
{
    self = [super init];
    initialized = NO;
    return self;
}

- (void) start:(CDVInvokedUrlCommand*)command
{
    NSArray* arguments = command.arguments;
    CDVPluginResult* pluginResult = nil;

    if (initialized == YES) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"hockeyapp cordova plugin: plugin is already started!"];
    } else if ([arguments count] > 1) {

        NSString* token = [arguments objectAtIndex:0];
        NSString* autoSend = [arguments objectAtIndex:1];

        [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:token];
        if ([autoSend isEqual:@"true"]) {
            [[BITHockeyManager sharedHockeyManager].crashManager setCrashManagerStatus:BITCrashManagerStatusAutoSend];
        }
        [[BITHockeyManager sharedHockeyManager] startManager];
        
        // Set authentication mode prior to verifying the user
        NSInteger authType = BITAuthenticatorIdentificationTypeAnonymous;
        [[BITHockeyManager sharedHockeyManager].authenticator setIdentificationType:BITAuthenticatorIdentificationTypeHockeyAppUser];
        if ([arguments count] == 4) {
            NSString *authTypeString = [arguments objectAtIndex:2];
            authType = [authTypeString intValue];
            NSString *appSecret = [arguments objectAtIndex:3];
            
            [[BITHockeyManager sharedHockeyManager].authenticator setAuthenticationSecret:appSecret];
            [[BITHockeyManager sharedHockeyManager].authenticator setIdentificationType:authType];
        }
        
        // We will use manual mode for identification/authentication, since we do not want to callback
        // into the JS code until we have a definitive answer as to the success of the operation.
        [[BITHockeyManager sharedHockeyManager].authenticator identifyWithCompletion:
            ^(BOOL identified, NSError *identifyError) {
                if (!identified) {
                    CDVPluginResult *identifyResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
                    [self.commandDelegate sendPluginResult:identifyResult callbackId:command.callbackId];
                    return;
                }
                
                [[BITHockeyManager sharedHockeyManager].authenticator validateWithCompletion:
                    ^(BOOL validated, NSError *validateError) {
                        CDVPluginResult *validateResult = nil;
    
                        if (!validated) {
                            validateResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
                            [self.commandDelegate sendPluginResult:validateResult callbackId:command.callbackId];
                            return;
                        }
                        
                        validateResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                        initialized = YES;
                        [self.commandDelegate sendPluginResult:validateResult callbackId:command.callbackId];                        
                    }
                ];
            }
        ];
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT];
        [pluginResult setKeepCallbackAsBool:YES];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];    
}

- (void) feedback:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    if(initialized == YES) {
        [[BITHockeyManager sharedHockeyManager].feedbackManager showFeedbackListView];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"hockeyapp cordova plugin is not started, call hockeyapp.start(successcb, errorcb, appid) first!"];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) checkForUpdate:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    if(initialized == YES) {
        [[BITHockeyManager sharedHockeyManager].updateManager checkForUpdate];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"hockeyapp cordova plugin is not started, call hockeyapp.start(successcb, errorcb, hockeyapp_id) first!"];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)forceCrash:(CDVInvokedUrlCommand *)command {
    [[BITHockeyManager sharedHockeyManager].crashManager generateTestCrash];
}

@end
