import Flutter
import UIKit

public class AppScreenPrivacyPlugin: NSObject, FlutterPlugin {
    var privacyView: UIView?
    static var registrar: FlutterPluginRegistrar?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "app_screen_privacy", binaryMessenger: registrar.messenger())
        let instance = AppScreenPrivacyPlugin()
        self.registrar = registrar // Store the registrar
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "showPrivacyScreen":
            if let args = call.arguments as? [String: Any] {
                let logo = args["logo"] as? String
                let bgColor = args["backgroundColor"] as? String
                showPrivacyView(logo: logo, bgColor: bgColor)
            }
            result(nil)
        case "hidePrivacyScreen":
            hidePrivacyView()
            result(nil)
        case "enableScreenShotProtection":
            result(nil)
        case "disableScreenShotProtection":
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func loadImageFromFlutterAssets(assetPath: String) -> UIImage? {
        guard let registrar = AppScreenPrivacyPlugin.registrar else {
            print("Registrar is nil")
            return nil
        }
        
        // Get the Flutter asset key
        let key = registrar.lookupKey(forAsset: assetPath)
        print("Asset path: \(assetPath), Key: \(key)")
        
        // Get the path to the asset
        guard let path = Bundle.main.path(forResource: key, ofType: nil) else {
            print("Could not find asset at path: \(key)")
            return nil
        }
        
        print("Found asset at: \(path)")
        // Load the image
        return UIImage(contentsOfFile: path)
    }
    
    private func showPrivacyView(logo: String?, bgColor: String?) {
        guard privacyView == nil else { return }
        guard let window = getKeyWindow() else { return }
        
        let containerView = UIView(frame: window.bounds)
        
        // Set background color
        if let bgColor = bgColor {
            containerView.backgroundColor = UIColor(hex: bgColor)
        } else {
            containerView.backgroundColor = UIColor.white
        }
        
        // Add logo if provided
        if let logo = logo {
            let imageView = UIImageView()
            
            // Load image from Flutter assets
            if let image = loadImageFromFlutterAssets(assetPath: logo) {
                imageView.image = image
            } else {
                // Fallback: try loading from iOS bundle
                if let image = UIImage(named: logo) {
                    imageView.image = image
                }
            }
            
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(imageView)
            
            // Center the image
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                imageView.widthAnchor.constraint(lessThanOrEqualTo: containerView.widthAnchor, multiplier: 0.8),
                imageView.heightAnchor.constraint(lessThanOrEqualTo: containerView.heightAnchor, multiplier: 0.8)
            ])
        }
        
        privacyView = containerView
        window.addSubview(containerView)
        window.bringSubviewToFront(containerView)
    }
    
    private func hidePrivacyView(){
        privacyView?.removeFromSuperview()
        privacyView = nil
    }
    
    private func getKeyWindow() -> UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexSanitized.hasPrefix("#") {
            hexSanitized.remove(at: hexSanitized.startIndex)
        }
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        let r = CGFloat((rgb & 0xff0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00ff00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000ff) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}
