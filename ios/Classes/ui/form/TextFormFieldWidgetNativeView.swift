import Flutter
import UIKit

class TextFormFieldWidgetNativeView: NSObject, FlutterPlatformView, UITextFieldDelegate {
    private let _channel: FlutterMethodChannel
    private var _view: UIView!
    private var _params: IOSUseNativeTextFieldParams!

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
        
        _channel.setMethodCallHandler { methodCall, result in
            self.onMethodCall(call: methodCall, result: result)
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
        _params = params
        
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
            
            var fontSize: Double = 16
            if let theFontSize = theInputStyle["fontSize"] as? Double {
                fontSize = theFontSize
            }
            
            var isBold = false;
            if let theFontWeightBold = theInputStyle["fontWeightBold"] as? Bool {
                isBold = theFontWeightBold
            }
            
            if let theFontFamily = theInputStyle["fontFamily"] as? String {
                textField.font = UIFont(name: theFontFamily, size: CGFloat(fontSize))
            } else {
                textField.font = UIFont.systemFont(ofSize: CGFloat(fontSize), weight: isBold ? .bold : .regular)
            }
        }
        
        if let theKeyboardType = params.keyboardType {
            print("TCH_d_is theKeyboardType \(theKeyboardType) \(keyboardTypeForFlutterInputType(inputType: theKeyboardType).rawValue)") //TODO remove
            textField.keyboardType = keyboardTypeForFlutterInputType(inputType: theKeyboardType)
        }
        
        if let theTextInputAction = params.textInputAction {
            print("TCH_d_is returnKeyType \(theTextInputAction) \(keyboardReturnKeyTypeForFlutterInputAction(inputAction: theTextInputAction).rawValue)") //TODO remove
            textField.returnKeyType = keyboardReturnKeyTypeForFlutterInputAction(inputAction: theTextInputAction)
        }
        
        textField.autocapitalizationType = autocapitalizationForFlutterTextCapitalization(textCapitalization: params.textCapitalization)
        
        textField.autocorrectionType = params.autocorrect ? .yes : .no
        
        weak var theDelegate: UITextFieldDelegate? = self
        textField.delegate = theDelegate
        
        return textField
    }
    
    /**
     * On method called from Flutter do action.
     */
    func onMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let textField = _view as! UITextField
        
        switch call.method {
        case "focus":
            textField.becomeFirstResponder()
            result(nil)
            break
        case "unFocus":
            textField.resignFirstResponder()
            result(nil)
            break
        case "getText":
            result(textField.text ?? "")
            break
        case "setText":
            textField.text = (call.arguments as? String) ?? ""
            result(nil)
            break
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    /**
     * Editing started on the UITextField, inform Flutter.
     */
    func textFieldDidBeginEditing(_ textField: UITextField) {
        _channel.invokeMethod("focused", arguments: nil)
    }
    
    /**
     * TextField return key pressed, on single line end ediding, on multilne let new line.
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("TCH_d_ios \(_params.text) textFieldShouldReturn \(_params.maxLines == 1)") //TODO remove
        
        if _params.maxLines == 1 {
            _channel.invokeMethod("didEndEditing", arguments: textField.text ?? "")
        }
        
        return _params.maxLines == 1
    }
    
    /**
     * Get iOS UIKeyboardType for Flutter TextInputType.
     */
    fileprivate func keyboardTypeForFlutterInputType(inputType: String) -> UIKeyboardType {
        switch inputType {
        case "TextInputType.text":
            return .default
        case "TextInputType.multiline": //TODO this is supposed to accept new lines
            return .default
        case "TextInputType.number":
            return .numbersAndPunctuation
        case "TextInputType.phone":
            return .phonePad
        case "TextInputType.datetime":
            return .default
        case "TextInputType.emailAddress":
            return .emailAddress
        case "TextInputType.url":
            return .URL
        case "TextInputType.visiblePassword":
            return .default
        case "TextInputType.name":
            return .namePhonePad
        case "TextInputType.address":
            return .default
        default:
            return .default
        }
    }
    
    /**
     * Get iOS UIReturnKeyType for Flutter TextInputAction.
     */
    fileprivate func keyboardReturnKeyTypeForFlutterInputAction(inputAction: String) -> UIReturnKeyType {
        switch inputAction {
        case "TextInputAction.none", "TextInputAction.unspecified":
            return .default
        case "TextInputAction.done":
            return .done
        case "TextInputAction.go":
            return .go
        case "TextInputAction.search":
            return .search
        case "TextInputAction.send":
            return .send
        case "TextInputAction.next":
            return .next
        case "TextInputAction.previous":
            return .default
        case "TextInputAction.continueAction":
            return .continue
        case "TextInputAction.join":
            return .join
        case "TextInputAction.route":
            return .route
        case "TextInputAction.emergencyCall":
            return .emergencyCall
        case "TextInputAction.newline":  //TODO this is supposed to accept new lines
            return .default
        default:
            return .default
        }
    }
    
    /**
     * Get iOS UITextAutocorrectionType for Flutter TextCapitalization.
     */
    fileprivate func autocapitalizationForFlutterTextCapitalization(textCapitalization: String) -> UITextAutocapitalizationType {
        switch textCapitalization {
        case "TextCapitalization.words":
            return .words
        case "TextCapitalization.sentences":
            return .sentences
        case "TextCapitalization.characters":
            return .allCharacters
        case "TextCapitalization.none":
            return .none
        default:
            return .none
        }
    }
}

struct IOSUseNativeTextFieldParams {
    var text: String
    var inputStyle: NSDictionary?
    var maxLines: Int
    var keyboardType: String?
    var textInputAction: String?
    var textCapitalization: String
    var autocorrect: Bool
    
    /**
     * Convert JSON map into IOSUseNativeTextFieldParams.
     */
    static func fromJson(dictionary: NSDictionary) -> IOSUseNativeTextFieldParams {
        return IOSUseNativeTextFieldParams(
            text: dictionary["text"] as! String,
            inputStyle: dictionary["inputStyle"] as? NSDictionary,
            maxLines: dictionary["maxLines"] as! Int,
            keyboardType: dictionary["keyboardType"] as? String,
            textInputAction: dictionary["textInputAction"] as? String,
            textCapitalization: dictionary["textCapitalization"] as! String,
            autocorrect: dictionary["autocorrect"] as! Bool
        )
    }
}
