import Flutter
import UIKit

class TextFormFieldWidgetNativeView: NSObject, FlutterPlatformView {
    private var _view: UIView

    /**
     * TextFormFieldWidgetNativeView initialization with frame and other params.
     */
    init(frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, messenger: FlutterBinaryMessenger) {
        _view = UIView()

        super.init()

        createTextField()
    }

    /**
     * Get the view for Flutter embedding.
     */
    func view() -> UIView {
        return _view;
    }

    /**
     * Create the TextField for input of Flutter TextFormFieldWidget.
     */
    func createTextField() {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 180, height: 48)); //TODO frame???

        textField.text = "Native UITextField"

        _view.addSubview(textField)
    }
}
