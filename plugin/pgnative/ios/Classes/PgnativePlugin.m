#import "PgnativePlugin.h"
//#import <UTDID/UTDevice.h>
#import "UIDevice+FCUUID.h"

@implementation PgnativePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"pgnative"
            binaryMessenger:[registrar messenger]];
  PgnativePlugin* instance = [[PgnativePlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  }else if ([@"uuid" isEqualToString:call.method]) {
    NSString *utdid = [[UIDevice currentDevice] uuid];
    result(utdid);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
