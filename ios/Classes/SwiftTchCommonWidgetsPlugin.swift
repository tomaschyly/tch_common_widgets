import Flutter
import UIKit

public class SwiftTchCommonWidgetsPlugin: NSObject, FlutterPlugin {
    /**
     * Register the plugin with Flutter.
     */
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "tch_common_widgets", binaryMessenger: registrar.messenger())
        let instance = SwiftTchCommonWidgetsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)

        let factory = TextFormFieldWidgetFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "tch_common_widgets/TextFormFieldWidget")
    }

    /**
     * Handle messages from Flutter.
     */
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        result("iOS " + UIDevice.current.systemVersion)
    }
}
