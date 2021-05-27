import Flutter
import UIKit
//import MaterialComponents.MaterialTextControls_OutlinedTextAreas
//import MaterialComponents.MaterialTextControls_OutlinedTextFields
//import MaterialComponents.MaterialTextControls_OutlinedTextAreasTheming
//import MaterialComponents.MaterialTextControls_OutlinedTextFieldsTheming

class TextFormFieldWidgetNativeView: NSObject, FlutterPlatformView {
    private var _view: UIView!

    /**
     * TextFormFieldWidgetNativeView initialization with frame and other params.
     */
    init(frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, messenger: FlutterBinaryMessenger) {
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
        
        //TODO do not use IOS Material components, they do not have the same options, use just UITextField for pure text, everything else in Flutter
        
        let textField = UITextField(frame: frame)
        
        textField.backgroundColor = .clear
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 0
        
        textField.text = params.text
        
        return textField
        
//        let textField = UITextField(frame: frame)
//
//        textField.text = "Native UITextField"
//        textField.backgroundColor = UIColor.red
//
//        _view = textField
        
//        let containerScheme = MDCContainerScheme()
//
////        containerScheme.colorScheme.primaryColor = .blue
//        containerScheme.typographyScheme.subtitle1 = UIFont.systemFont(ofSize: 16, weight: .bold) //TODO this works, but it is shared by input and label
//
//        let textField = MDCOutlinedTextField(frame: frame)
//        textField.applyTheme(withScheme: containerScheme)
//        textField.applyErrorTheme(withScheme: containerScheme)
//        textField.verticalDensity = 1 //TODO from params
//
//        textField.label.text = params.labelText ?? ""
//
////        if let theLabelStyle = params.labelStyle {
////            if let theLabelColor = theLabelStyle["color"] as? String {
////                let textColor = UIColor(flutterColorHex: theLabelColor)!
////
////                textField.setNormalLabelColor(textColor, for: .normal)
////                textField.setNormalLabelColor(textColor, for: .editing)
////                textField.setFloatingLabelColor(textColor, for: .normal)
////                textField.setFloatingLabelColor(textColor, for: .editing)
////            }
////
////            //TODO default font is not needed to include, but custom is going to be
////            textField.label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
////        }
//
//        return textField
    }
}

struct IOSUseNativeTextFieldParams {
//    var labelText: String?
//    var labelStyle: NSDictionary?
    var text: String
    
    /**
     * Convert JSON map into IOSUseNativeTextFieldParams.
     */
    static func fromJson(dictionary: NSDictionary) -> IOSUseNativeTextFieldParams {
        return IOSUseNativeTextFieldParams(
//            labelText: dictionary["labelText"] as? String,
//            labelStyle: dictionary["labelStyle"] as? NSDictionary
            text: dictionary["text"] as! String
        )
    }
}
