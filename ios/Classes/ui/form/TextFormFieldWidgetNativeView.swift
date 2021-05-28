import Flutter
import UIKit

class TextFormFieldWidgetNativeView: NSObject, FlutterPlatformView, UITextFieldDelegate {
    private let _channel: FlutterMethodChannel
    private var _view: UIView!

    /**
     * TextFormFieldWidgetNativeView initialization with frame and other params.
     */
    init(frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, messenger: FlutterBinaryMessenger) {
        _channel = FlutterMethodChannel(name: "tch_common_widgets/TextFormFieldWidget\(viewId)", binaryMessenger: messenger)
        
        super.init()
        
        if args is NSDictionary {
            print("TCH_d_ios frame \(frame) viewId \(viewId) args \(args!)") //TODO remove
            _view = createTextField(frame: frame, arguments: args as! NSDictionary)
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
    fileprivate func createTextField(frame: CGRect, arguments args: NSDictionary) -> UIView {
        let params = IOSUseNativeTextFieldParams.fromJson(dictionary: args)
        
        let textField = UITextField(frame: frame)
        
        textField.backgroundColor = .clear
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 0
        
        textField.text = params.text
        
        if let theInputStyle = params.inputStyle {
            var color: UIColor?
            
            if let theColor = theInputStyle["color"] as? String {
                color = UIColor(flutterColorHex: theColor)
            }
            
            textField.textColor = color
            
            //TODO handle fontWeight and fontFamily
        }
        
        weak var theDelegate: UITextFieldDelegate? = self
        textField.delegate = theDelegate
        
        return textField
    }
    
    /**
     * Editing started on the UITextField, inform Flutter.
     */
    func textFieldDidBeginEditing(_ textField: UITextField) {
        _channel.invokeMethod("focused", arguments: nil)
    }
}

struct IOSUseNativeTextFieldParams {
    var text: String
    var inputStyle: NSDictionary?
    
    /**
     * Convert JSON map into IOSUseNativeTextFieldParams.
     */
    static func fromJson(dictionary: NSDictionary) -> IOSUseNativeTextFieldParams {
        return IOSUseNativeTextFieldParams(
            text: dictionary["text"] as! String,
            inputStyle: dictionary["inputStyle"] as? NSDictionary
        )
    }
}
