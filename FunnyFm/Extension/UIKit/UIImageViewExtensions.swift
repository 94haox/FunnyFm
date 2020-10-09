//
//  UIImageViewExtensions.swift
//  SwifterSwift
//
//  Created by Omar Albeik on 8/25/16.
//  Copyright © 2016 SwifterSwift
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

// MARK: - Methods
public extension UIImageView {
    
    @IBInspectable var needReColor: Bool{
        get {
            return true
        }
        set {
            if newValue == true {
                let image = self.image?.tintImage
                self.image = image
            }
        }
    }
    

    /// SwifterSwift: Set image from a URL.
    ///
    /// - Parameters:
    ///   - url: URL of image.
    ///   - contentMode: imageView content mode (default is .scaleAspectFit).
    ///   - placeHolder: optional placeholder image
    ///   - completionHandler: optional completion handler to run when download finishs (default is nil).
    func download(
        from url: URL,
        contentMode: UIView.ContentMode = .scaleAspectFit,
        placeholder: UIImage? = nil,
        completionHandler: ((UIImage?) -> Void)? = nil) {

        image = placeholder
        self.contentMode = contentMode
        URLSession.shared.dataTask(with: url) { (data, response, _) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data,
                let image = UIImage(data: data)
                else {
                    completionHandler?(nil)
                    return
            }
            DispatchQueue.main.async {
                self.image = image
                completionHandler?(image)
            }
            }.resume()
    }

    /// SwifterSwift: Make image view blurry
    ///
    /// - Parameter style: UIBlurEffectStyle (default is .light).
    func blur(withStyle style: UIBlurEffect.Style = .light) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        addSubview(blurEffectView)
        clipsToBounds = true
    }

    /// SwifterSwift: Blurred version of an image view
    ///
    /// - Parameter style: UIBlurEffectStyle (default is .light).
    /// - Returns: blurred version of self.
    func blurred(withStyle style: UIBlurEffect.Style = .light) -> UIImageView {
        let imgView = self
        imgView.blur(withStyle: style)
        return imgView
    }
	

}
#endif



#if canImport(Nuke)
import Nuke

public extension UIImageView {
	
	func loadImage(url: String){
		self.loadImage(url: url, placeholder: nil)
	}
	
	func loadImage(url: String, placeholder: String?){
		self.loadImage(url: url, placeholder: placeholder, complete: nil)
	}
	
	func loadImage(url: String, placeholder: String?, complete:((UIImage)->Void)?){
		var holder = placeholder
		if placeholder.isNone{
			holder = "logo-white"
		}
		let options = ImageLoadingOptions(
			placeholder: UIImage(named: holder!),
			transition: .fadeIn(duration: 0.33),
			failureImage: UIImage(named: holder!)
		)
		
		let imgURL = URL.init(string: url)
		
		if imgURL.isNone {
			return
		}
		
		Nuke.loadImage(with: URL.init(string: url)!, options: options, into: self, progress: nil, completion: { result in
			switch result {
			case .success(let value):
				if complete.isSome{
					let request = ImageRequest(url: URL.init(string: url)!)
					ImageCache.shared[request] = ImageContainer(image: value.image)
					complete!(value.image)
				}
			case .failure(let error):
				print("Error: \(error)")
			}
		})
		
	}
	
}

#endif
