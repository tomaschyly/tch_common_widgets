import Flutter
import UIKit
import MaterialComponents.MaterialTextControls_OutlinedTextAreas
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class TextFormFieldWidgetNativeView: NSObject, FlutterPlatformView {
    private var _view: UIView!

    /**
     * TextFormFieldWidgetNativeView initialization with frame and other params.
     */
    init(frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, messenger: FlutterBinaryMessenger) {
        super.init()
        
        if args is NSDictionary {
            print("TCH_d_ios frame \(frame) viewId \(viewId) args \(args!)") //TODO remove
            createTextField(frame: frame, arguments: args as! NSDictionary)
        } else {
            _view = UIView(frame: frame)
        }
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
    fileprivate func createTextField(frame: CGRect, arguments args: NSDictionary) {
//        let textField = UITextField(frame: frame)
//
//        textField.text = "Native UITextField"
//        textField.backgroundColor = UIColor.red
//
//        _view = textField
        
        let textField = MDCOutlinedTextField(frame: frame)
        
        textField.label.text = "Label" //TODO
        textField.placeholder = "Placeholder" //TODO
        
        _view = textField
    }
}
