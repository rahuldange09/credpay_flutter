#import "CredpayPlugin.h"
#if __has_include(<credpay/credpay-Swift.h>)
#import <credpay/credpay-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "credpay-Swift.h"
#endif

@implementation CredpayPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCredpayPlugin registerWithRegistrar:registrar];
}
@end
