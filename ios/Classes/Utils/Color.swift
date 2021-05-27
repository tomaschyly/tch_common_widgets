import Flutter
import UIKit

extension UIColor {
    /**
     * Create UIColor from hex string sent from Flutter.
     */
    public convenience init?(flutterColorHex: String) {
        let r, g, b, a: CGFloat

        if flutterColorHex.hasPrefix("#") {
            let start = flutterColorHex.index(flutterColorHex.startIndex, offsetBy: 1)
            let hexColor = String(flutterColorHex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    a = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    r = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
