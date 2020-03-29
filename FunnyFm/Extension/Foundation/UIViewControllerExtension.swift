import UIKit
import SCLAlertView

extension UIViewController {
    
    public func isPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    func alertVip(){
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false,
            contentViewColor: R.color.background()!,
            contentViewBorderColor: R.color.background()!,
            titleColor: R.color.titleColor()!
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("解锁 Pro".localized, backgroundColor: R.color.mainRed(), textColor: .white, showTimeout: nil, action: {
            alertView.hideView()
            self.dismiss(animated: true) {
                let purchaseVC = InPurchaseViewController()
                let navi = UIApplication.shared.keyWindow?.rootViewController! as! UINavigationController
                navi.pushViewController(purchaseVC)
            }
        })
        alertView.addButton("知道了", backgroundColor: R.color.mainRed(), textColor: .white, showTimeout: nil, action: {
            alertView.hideView()
            self.dismiss(animated: true) {}
        })
        alertView.showWarning("提示".localized, subTitle: "此功能仅向 Pro 用户开放 \n 请先解锁 Pro 功能".localized)
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
