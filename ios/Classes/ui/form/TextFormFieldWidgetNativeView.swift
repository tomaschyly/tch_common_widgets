import Flutter
import UIKit

class TextFormFieldWidgetNativeView: NSObject, FlutterPlatformView, UITextViewDelegate, UITextFieldDelegate {
    private let _channel: FlutterMethodChannel
    private var _view: UIView!
    private var _params: IOSUseNativeTextFieldParams!
    private var _isFocused = false

    /**
     * TextFormFieldWidgetNativeView initialization with frame and other params.
     */
    init(frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, messenger: FlutterBinaryMessenger) {
        _channel = FlutterMethodChannel(name: "tch_common_widgets/TextFormFieldWidget\(viewId)", binaryMessenger: messenger)
        
        super.init()
        
        if args is NSDictionary {
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
        
        if params.maxLines == 1 {
            let textField = UITextField(frame: frame)
            
            textField.backgroundColor = .clear
            textField.layer.borderColor = UIColor.clear.cgColor
            textField.layer.borderWidth = 0
            
            textField.text = params.text
            
            if params.text.isEmpty, let theHintText = params.hintText, !theHintText.isEmpty {
                textField.text = theHintText
                
                styleTextField(textField: textField, params: params, requestingPlaceholder: true)
            } else {
                styleTextField(textField: textField, params: params, requestingPlaceholder: false)
            }
            
            if let theKeyboardType = params.keyboardType {
                textField.keyboardType = keyboardTypeForFlutterInputType(inputType: theKeyboardType)
            }
            
            if let theTextInputAction = params.textInputAction {
                textField.returnKeyType = keyboardReturnKeyTypeForFlutterInputAction(inputAction: theTextInputAction)
            }
            
            textField.autocapitalizationType = autocapitalizationForFlutterTextCapitalization(textCapitalization: params.textCapitalization)
            
            textField.textAlignment = textAlignmentForFlutterTextAlign(textAlignment: params.textAlign, textField: textField)
            
            textField.autocorrectionType = params.autocorrect ? .yes : .no
            
            weak var theDelegate: UITextFieldDelegate? = self
            textField.delegate = theDelegate
            
            return textField
        } else {
            let textField = UITextView(frame: frame)
            textField.isEditable = true
            
            textField.backgroundColor = .clear
            textField.layer.borderColor = UIColor.clear.cgColor
            textField.layer.borderWidth = 0
            
            textField.text = params.text
            
            if params.text.isEmpty, let theHintText = params.hintText, !theHintText.isEmpty {
                textField.text = theHintText
                
                styleTextField(textField: textField, params: params, requestingPlaceholder: true)
            } else {
                styleTextField(textField: textField, params: params, requestingPlaceholder: false)
            }
            
            if let theKeyboardType = params.keyboardType {
                textField.keyboardType = keyboardTypeForFlutterInputType(inputType: theKeyboardType)
            }
            
            if let theTextInputAction = params.textInputAction {
                textField.returnKeyType = keyboardReturnKeyTypeForFlutterInputAction(inputAction: theTextInputAction)
            }
            
            textField.autocapitalizationType = autocapitalizationForFlutterTextCapitalization(textCapitalization: params.textCapitalization)
            
            textField.textAlignment = textAlignmentForFlutterTextAlign(textAlignment: params.textAlign, textField: textField)
            
            textField.autocorrectionType = params.autocorrect ? .yes : .no
            
            weak var theDelegate: UITextViewDelegate? = self
            textField.delegate = theDelegate
            
            return textField
        }
    }
    
    /**
     * Style the text field depending on placeholder, focused, etc.
     */
    fileprivate func styleTextField(textField: UIView, params: IOSUseNativeTextFieldParams, requestingPlaceholder: Bool) {
        var inputStyle: NSDictionary?
        
        if let theHintText = params.hintText, !theHintText.isEmpty, requestingPlaceholder, let theHintStyle = params.hintStyle {
            inputStyle = theHintStyle
        } else {
            inputStyle = params.inputStyle
        }
        
        if let theTextField = textField as? UITextField {
            theTextField.isSecureTextEntry = params.obscureText && !requestingPlaceholder
        } else if let theTextView = textField as? UITextView {
            theTextView.isSecureTextEntry = params.obscureText && !requestingPlaceholder
        }
        
        if let theInputStyle = inputStyle {
            if let theTextField = textField as? UITextField {
                var color: UIColor?
                
                if let theColor = theInputStyle["color"] as? String {
                    color = UIColor(flutterColorHex: theColor)
                }
                
                theTextField.textColor = color
                
                var fontSize: Double = 16
                if let theFontSize = theInputStyle["fontSize"] as? Double {
                    fontSize = theFontSize
                }
                
                var isBold = false;
                if let theFontWeightBold = theInputStyle["fontWeightBold"] as? Bool {
                    isBold = theFontWeightBold
                }
                
                if let theFontFamily = theInputStyle["fontFamily"] as? String, theFontFamily.isEmpty == false {
                    theTextField.font = UIFont(name: theFontFamily, size: CGFloat(fontSize))
                } else if let iOSFontFamily = params.iOSFontFamily as? String, iOSFontFamily.isEmpty == false {
                    theTextField.font = UIFont(name: iOSFontFamily, size: CGFloat(fontSize))
                } else {
                    theTextField.font = UIFont.systemFont(ofSize: CGFloat(fontSize), weight: isBold ? .bold : .regular)
                }
            } else if let theTextField = textField as? UITextView {
                var color: UIColor?
                
                if let theColor = theInputStyle["color"] as? String {
                    color = UIColor(flutterColorHex: theColor)
                }
                
                theTextField.textColor = color
                
                var fontSize: Double = 16
                if let theFontSize = theInputStyle["fontSize"] as? Double {
                    fontSize = theFontSize
                }
                
                var isBold = false;
                if let theFontWeightBold = theInputStyle["fontWeightBold"] as? Bool {
                    isBold = theFontWeightBold
                }
                
                if let theFontFamily = theInputStyle["fontFamily"] as? String, theFontFamily.isEmpty == false {
                    theTextField.font = UIFont(name: theFontFamily, size: CGFloat(fontSize))
                } else if let iOSFontFamily = params.iOSFontFamily as? String, iOSFontFamily.isEmpty == false {
                    theTextField.font = UIFont(name: iOSFontFamily, size: CGFloat(fontSize))
                } else {
                    theTextField.font = UIFont.systemFont(ofSize: CGFloat(fontSize), weight: isBold ? .bold : .regular)
                }
            }
        }
    }
    
    /**
     * On method called from Flutter do action.
     */
    func onMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let theTextField = _view as? UITextField {
            switch call.method {
            case "focus":
                theTextField.becomeFirstResponder()
                result(nil)
                break
            case "unFocus":
                theTextField.resignFirstResponder()
                result(nil)
                break
            case "getText":
                var text = theTextField.text ?? ""
                text = text == _params.hintText ? "" : text

                result(text)
                break
            case "setText":
                theTextField.text = (call.arguments as? String) ?? ""
                result(nil)
                break
            case "sync":
                _params = IOSUseNativeTextFieldParams.fromJson(dictionary: call.arguments as! NSDictionary)

                if !_isFocused, _params.text.isEmpty, let theHintText = _params.hintText, !theHintText.isEmpty {
                    theTextField.text = theHintText
                    
                    styleTextField(textField: theTextField, params: _params, requestingPlaceholder: true)
                } else {
                    styleTextField(textField: theTextField, params: _params, requestingPlaceholder: false)
                }
                break
            default:
                result(FlutterMethodNotImplemented)
            }
        } else if let theTextView = _view as? UITextView {
            switch call.method {
            case "focus":
                theTextView.becomeFirstResponder()
                result(nil)
                break
            case "unFocus":
                theTextView.resignFirstResponder()
                result(nil)
                break
            case "getText":
                var text = theTextView.text ?? ""
                text = text == _params.hintText ? "" : text

                result(text)
                break
            case "setText":
                theTextView.text = (call.arguments as? String) ?? ""
                result(nil)
                break
            case "sync":
                _params = IOSUseNativeTextFieldParams.fromJson(dictionary: call.arguments as! NSDictionary)

                if !_isFocused, _params.text.isEmpty, let theHintText = _params.hintText, !theHintText.isEmpty {
                    theTextView.text = theHintText
                    
                    styleTextField(textField: theTextView, params: _params, requestingPlaceholder: true)
                } else {
                    styleTextField(textField: theTextView, params: _params, requestingPlaceholder: false)
                }
                break
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    /**
     * Editing started on the UITextField, inform Flutter.
     * Handle custom placeholder.
     */
    func textFieldDidBeginEditing(_ textField: UITextField) {
        _isFocused = true

        if let theHintText = _params.hintText, !theHintText.isEmpty, textField.text == theHintText {
            textField.text = ""
            
            styleTextField(textField: textField, params: _params, requestingPlaceholder: false)
        }

        OperationQueue.main.addOperation {
            self._channel.invokeMethod("focused", arguments: nil)
        }
    }
    
    /**
     * Editing started on the UITextView, inform Flutter.
     * Handle custom placeholder.
     */
    func textViewDidBeginEditing(_ textView: UITextView) {
        _isFocused = true

        if let theHintText = _params.hintText, !theHintText.isEmpty, textView.text == theHintText {
            textView.text = ""
            
            styleTextField(textField: textView, params: _params, requestingPlaceholder: false)
        }

        OperationQueue.main.addOperation {
            self._channel.invokeMethod("focused", arguments: nil)
        }
    }
    
    /**
     * Editing ended on the UITextField, handle custom placeholder.
     */
    func textFieldDidEndEditing(_ textField: UITextField) {
        _isFocused = false

        if let theHintText = _params.hintText, !theHintText.isEmpty, textField.text!.isEmpty {
            textField.text = theHintText
            
            styleTextField(textField: textField, params: _params, requestingPlaceholder: true)
        }
    }
    
    /**
     * Editing ended on the UITextView, handle custom placeholder.
     */
    func textViewDidEndEditing(_ textView: UITextView) {
        _isFocused = false

        if let theHintText = _params.hintText, !theHintText.isEmpty, textView.text.isEmpty {
            textView.text = theHintText
            
            styleTextField(textField: textView, params: _params, requestingPlaceholder: true)
        }
    }
    
    /**
     * On realtime change text of UITextField, update Flutter.
     */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var text = textField.text?.replacingCharacters(in: Range(range, in: textField.text!)!, with: string) ?? ""

        text = text == _params.hintText ? "" : text
        
        _channel.invokeMethod("setText", arguments: text)
        
        return true
    }
    
    /**
     * On realtime change text of UITextView, update Flutter.
     */
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var text = textView.text.replacingCharacters(in: Range(range, in: textView.text)!, with: text)

        text = text == _params.hintText ? "" : text
        
        _channel.invokeMethod("setText", arguments: text)
        
        return true
    }
    
    /**
     * TextField return key pressed, on single line end ediding, on multilne let new line.
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if _params.maxLines == 1 {
            var text = textField.text ?? ""
            text = text == _params.hintText ? "" : text

            _channel.invokeMethod("didEndEditing", arguments: text)
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
        case "TextInputType.multiline":
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
        case "TextInputAction.newline":
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
    
    /**
     * Get iOS NSTextAlignment for Flutter TextAlignment.
     */
    fileprivate func textAlignmentForFlutterTextAlign(textAlignment: String, textField: UIView) -> NSTextAlignment {
        switch textAlignment {
        case "TextAlign.left":
            return .left
        case "TextAlign.right":
            return .right
        case "TextAlign.center":
            return .center
        case "TextAlign.justify":
            return .justified
        case "TextAlign.start":
            if UIView.userInterfaceLayoutDirection(for: textField.semanticContentAttribute) == .leftToRight {
                return .left
            } else {
                return .right
            }
        case "TextAlign.end":
            if UIView.userInterfaceLayoutDirection(for: textField.semanticContentAttribute) == .leftToRight {
                return .right
            } else {
                return .left
            }
        default:
            return .natural
        }
    }
}

struct IOSUseNativeTextFieldParams {
    var iOSFontFamily: String?
    var text: String
    var inputStyle: NSDictionary?
    var hintText: String?
    var hintStyle: NSDictionary?
    var maxLines: Int
    var keyboardType: String?
    var textInputAction: String?
    var textCapitalization: String
    var textAlign: String
    var autocorrect: Bool
    var obscureText: Bool
    
    /**
     * Convert JSON map into IOSUseNativeTextFieldParams.
     */
    static func fromJson(dictionary: NSDictionary) -> IOSUseNativeTextFieldParams {
        return IOSUseNativeTextFieldParams(
            iOSFontFamily: dictionary["iOSFontFamily"] as? String,
            text: dictionary["text"] as! String,
            inputStyle: dictionary["inputStyle"] as? NSDictionary,
            hintText: dictionary["hintText"] as? String,
            hintStyle: dictionary["hintStyle"] as? NSDictionary,
            maxLines: dictionary["maxLines"] as! Int,
            keyboardType: dictionary["keyboardType"] as? String,
            textInputAction: dictionary["textInputAction"] as? String,
            textCapitalization: dictionary["textCapitalization"] as! String,
            textAlign: dictionary["textAlign"] as! String,
            autocorrect: dictionary["autocorrect"] as! Bool,
            obscureText: dictionary["obscureText"] as! Bool
        )
    }
}

/**
 * Log Fonts available in the app.
 */
func logFonts() {
    print("logFonts")
    for family: String in UIFont.familyNames {
        print("\(family)")
        for names: String in UIFont.fontNames(forFamilyName: family) {
            print("== \(names)")
        }
    }
}
