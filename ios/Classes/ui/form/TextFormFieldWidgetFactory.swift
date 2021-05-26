import Flutter
import UIKit

class TextFormFieldWidgetFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    /**
     * TextFormFieldWidgetFactory initialization messanger.
     */
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger

        super.init()
    }

    /**
     * Create the platform view for Flutter embedding.
     */
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return TextFormFieldWidgetNativeView(frame: frame, viewIdentifier: viewId, arguments: args, messenger: messenger)
    }
    
    /**
     * Return default Flutter messagner codec for communication with Flutter to work.
     */
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}
