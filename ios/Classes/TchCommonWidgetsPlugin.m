#import "TchCommonWidgetsPlugin.h"
#if __has_include(<tch_common_widgets/tch_common_widgets-Swift.h>)
#import <tch_common_widgets/tch_common_widgets-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "tch_common_widgets-Swift.h"
#endif

@implementation TchCommonWidgetsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTchCommonWidgetsPlugin registerWithRegistrar:registrar];
}
@end
