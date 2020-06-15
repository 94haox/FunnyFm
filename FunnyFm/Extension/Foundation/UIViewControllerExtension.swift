import UIKit
import SCLAlertView

func showAutoHiddenHud(style: Hud.Style, text: String) {
    guard Thread.isMainThread else {
        DispatchQueue.main.async {
            showAutoHiddenHud(style: style, text: text)
        }
        return
    }
    let hud = Hud()
    hud.show(style: style, text: text, on: AppDelegate.current.window)
    hud.scheduleAutoHidden()
}

func showHud(style: Hud.Style, text: String) {
    guard Thread.isMainThread else {
        DispatchQueue.main.async {
            showHud(style: style, text: text)
        }
        return
    }
    let hud = Hud.shared
    hud.show(style: style, text: text, on: AppDelegate.current.window)
}

extension UIViewController {
    

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
                let navi = UINavigationController.init(rootViewController: purchaseVC)
                navi.isNavigationBarHidden = true
                AppDelegate.current.window.rootViewController!.present(navi, animated: true, completion: nil)
            }
        })
        alertView.addButton("知道了".localized, backgroundColor: R.color.mainRed(), textColor: .white, showTimeout: nil, action: {
            alertView.hideView()
            self.dismiss(animated: true) {}
        })
        alertView.showWarning("提示".localized, subTitle: "此功能仅向 Pro 用户开放 \n 请先解锁 Pro 功能".localized)
    }
 
}
