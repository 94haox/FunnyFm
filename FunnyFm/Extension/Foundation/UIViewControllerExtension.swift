import UIKit

extension UIViewController {
    
    public func isPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }

    func alert(_ message: String, actionTitle: String = "OK", cancelHandler: ((UIAlertAction) -> Void)? = nil) {
        let alc = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alc.addAction(UIAlertAction(title: actionTitle, style: .default, handler: cancelHandler))

        if let window = UIApplication.shared.windows.last, window.windowLevel.rawValue == 10000001.0 {
            window.rootViewController?.present(alc, animated: true, completion: nil)
        } else {
            present(alc, animated: true, completion: nil)
        }
    }

    func alert(_ title: String?, message: String?, handler: ((UIAlertAction) -> Void)? = nil) {
        let alc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alc.addAction(UIAlertAction(title: "OK", style: .cancel, handler: handler))
        self.present(alc, animated: true, completion: nil)
    }

    func alert(_ title: String, message: String? = nil, cancelTitle: String = "取消", actionTitle: String, handler: @escaping ((UIAlertAction) -> Void)) {
        let alc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alc.addAction(UIAlertAction(title: cancelTitle, style: .default, handler: nil))
        alc.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: handler))
        self.present(alc, animated: true, completion: nil)
    }


    
}
