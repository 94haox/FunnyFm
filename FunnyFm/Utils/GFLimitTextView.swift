//
//  GFLimitTextView.swift
//  GFTextViewLimitTextDemo
//
//  Created by ECHINACOOP1 on 2017/4/6.
//  Copyright © 2017年 蔺国防. All rights reserved.
//

import UIKit


///return textView.text.Characters.count 返回textView的字数
@objc protocol GFLiimitTextViewDelegate: NSObjectProtocol{

    @objc optional func getTextNum(textNum: Int)

}

class GFLimitTextView: UIView, UITextViewDelegate {
    
    //MARK: - Properties
    var textView: UITextView!
    var placeLabel: UILabel = UILabel.init()
	var limitLB: UILabel = UILabel.init()
	var placeText : String = "" {
		didSet {
			placeLabel.text = placeText
		}
	}
    var characterNum = 0
	var limitTextNum = 100 {
		didSet{
			limitLB.text = "0/\(limitTextNum)"
		}
	}

    let placeHeight = 30  //占位label的高度
	var isLimit: Bool {
		get {
			return characterNum > limitTextNum
		}
	}
    weak var delegate: GFLiimitTextViewDelegate?
    
    //MARK: - LifeCycle
    init(frame: CGRect, placeHolder: String?) {
        
        super.init(frame: frame)
		if placeHolder.isSome {
			placeText = placeHolder!
		}
        self.setup()
    }
	
	override func awakeFromNib() {
		super.awakeFromNib()
		placeText = ""
        self.setup()
	}
    
    required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
    }
	
	func alertAnimation(){
		if isLimit {
			self.limitLB.snp.updateConstraints { (make) in
				make.right.equalToSuperview().offset(-14)
			}
			
            self.layer.borderColor = R.color.mainRed()!.cgColor
			self.layer.borderWidth = 1
			
			UIView.animate(withDuration: 0.05, animations: {
				self.layoutIfNeeded()
			}) { (_) in
				self.limitLB.snp.updateConstraints { (make) in
					make.right.equalToSuperview().offset(-10)
				}
				UIView.animate(withDuration: 0.05, animations: {
					self.layoutIfNeeded()
				}) { (_) in
					self.limitLB.snp.updateConstraints { (make) in
						make.right.equalToSuperview().offset(-12)
					}
					UIView.animate(withDuration: 0.05, animations: {
						self.layoutIfNeeded()
					}) { (_) in
						self.layer.borderColor = UIColor.clear.cgColor
						self.layer.borderWidth = 5
					}
				}
			}
		}
	}
    
    
    //MARK: - Actions
    func setup() {
		self.cornerRadius = 5
		self.backgroundColor = CommonColor.background.color
        
        textView = UITextView.init(frame: CGRect.zero)
        textView.font = pfont(14)
		textView.tintColor = R.color.mainRed()!
		textView.textColor = CommonColor.content.color
        textView.delegate = self
		textView.backgroundColor = UIColor.clear
        addSubview(textView!)
		textView.snp.makeConstraints { (make) in
			make.top.equalToSuperview().offset(16)
			make.left.equalToSuperview().offset(12)
			make.bottom.equalToSuperview().offset(-10)
			make.right.equalToSuperview().offset(-12)
		}
        
        
        placeLabel.font = pfont(14)
        placeLabel.textColor = UIColor.lightGray
        addSubview(placeLabel)
		placeLabel.snp.makeConstraints { (make) in
			make.left.equalTo(textView)
			make.top.equalTo(textView)
		}
	
        limitLB.text = placeText
        limitLB.font = numFont(10)
		limitLB.textColor = R.color.mainRed()!
		limitLB.text = "0/\(limitTextNum)"
		addSubview(limitLB)
		limitLB.snp.makeConstraints { (make) in
			make.right.equalToSuperview().offset(-12)
			make.bottom.equalToSuperview().offset(-2)
		}
    }
    
    //MARK: - UITextViewDelegate
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        placeLabel.isHidden = true
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if characterNum == 0 {
            placeLabel.isHidden = false
        }else{
            placeLabel.isHidden = true
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        
        let str = textView.text ?? "";
        characterNum = str.count;
        
//        if characterNum > limitTextNum {
//            let startIndex = str.startIndex;
//            let endIndex = str.index(startIndex, offsetBy: limitTextNum);
//            let range = startIndex...endIndex;
//            textView.text = String(str[range]);
//
//            characterNum = limitTextNum
//        }
		self.limitLB.text = "\(characterNum)/\(limitTextNum)"
        self.delegate?.getTextNum!(textNum: characterNum)
    }
    
    //重写hitTest方法,来处理在View点击外区域收回键盘
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if self.isUserInteractionEnabled == false && self.alpha <= 0.01 && self.isHidden == true {
            
            return nil
        }
        
        if self.point(inside: point, with: event) == false {
            textView?.resignFirstResponder()
            return nil
        }else{
            
            for subView in self.subviews.reversed() {
                
                let convertPoint = subView.convert(point, from: self)
                let hitTestView = subView.hitTest(convertPoint, with: event)
                if (hitTestView != nil) {
                    return hitTestView
                }
            }
            return self
        }
    }
    
}
