//
//  PodPreviewViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/2/11.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class PodPreviewViewController: BaseViewController {
	
	var podImageView: UIImageView!
	var podNameLB: UILabel!
	var desLB: UILabel!
	var sourceLB: UILabel!
	var authorLB: UILabel!
	var subscribeBtn: UIButton!
	var loadingView: UIActivityIndicatorView!
	var pod: Pod!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.dw_addSubViews()
		self.dw_addConstraints()
        // Do any additional setup after loading the view.
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		FMToolBar.shared.isHidden = true
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		FMToolBar.shared.isHidden = false
	}
	
	func configWithPod(pod :Pod){
		self.pod = pod;
		self.podNameLB.text = pod.name
		self.authorLB.text = pod.author
		self.desLB.text = pod.des
		self.podImageView.kf.setImage(with: ImageResource.init(downloadURL: URL.init(string: pod.img)!))
		self.sourceLB.text = "来自：" + pod.sourceType;
	}
	
	@objc func addPodToLibary(){
		GlobalViewModel.shared.addItunesPod(podId: String(self.pod.albumId), feedUrl: self.pod.sourceUrl, sourceType: self.pod.sourceType)
		GlobalViewModel.shared.delegate = self;
	}
}


extension PodPreviewViewController: ViewModelDelegate {
	func viewModelDidGetDataSuccess() {
		self.dismiss(animated: true, completion: nil)
	}
	
	func viewModelDidGetDataFailture(msg: String?) {
		
	}
	
}


extension PodPreviewViewController {
	
	func dw_addConstraints(){
		self.podImageView.snp.makeConstraints { (make) in
			make.top.equalTo(self.view).offset(44);
			make.left.equalTo(self.view).offset(15);
			make.size.equalTo(CGSize.init(width: 150, height: 150));
		}
		
		self.podNameLB.snp.makeConstraints { (make) in
			make.top.equalTo(self.podImageView).offset(5);
			make.left.equalTo(self.podImageView.snp.right).offset(10);
			make.right.equalTo(self.view).offset(-6);
		}
		
		self.authorLB.snp.makeConstraints { (make) in
			make.width.left.equalTo(self.podNameLB);
			make.top.equalTo(self.podNameLB.snp.bottom).offset(12)
		}
		
		self.sourceLB.snp.makeConstraints { (make) in
			make.width.left.equalTo(self.podNameLB);
			make.top.equalTo(self.authorLB.snp.bottom).offset(12)
		}
		
		self.desLB.snp.makeConstraints { (make) in
			make.centerX.equalTo(self.view);
			make.width.equalTo(self.view).offset(-30);
			make.top.equalTo(self.podImageView.snp.bottom).offset(12)
		}
		
		self.subscribeBtn.snp.makeConstraints { (make) in
			make.centerX.equalTo(self.view);
			make.width.equalTo(self.view).offset(-30);
			make.height.equalTo(50);
			make.top.equalTo(self.desLB.snp.bottom).offset(20)
		}
		
		self.loadingView.snp.makeConstraints { (make) in
			make.center.equalTo(self.podImageView)
		}
	}
	
	func dw_addSubViews() {
		
		self.loadingView = UIActivityIndicatorView.init(style: .gray)
		self.loadingView.startAnimating()
		self.view.addSubview(self.loadingView)
		
		self.podImageView = UIImageView.init()
		self.podImageView.cornerRadius = 15
		self.view.addSubview(self.podImageView)
		
		self.podNameLB = UILabel.init();
		self.podNameLB.font = h_bfont(22);
		self.podNameLB.textColor = .black
		self.podNameLB.numberOfLines = 2;
		self.view.addSubview(self.podNameLB)
		
		self.desLB = UILabel.init();
		self.desLB.font = hfont(14);
		self.desLB.numberOfLines = 3;
		self.desLB.textColor = CommonColor.content.color
		self.view.addSubview(self.desLB)
		
		self.sourceLB = UILabel.init();
		self.sourceLB.font = hfont(14);
		self.sourceLB.textColor = CommonColor.content.color
		self.view.addSubview(self.sourceLB)
		
		self.authorLB = UILabel.init()
		self.authorLB.font = hfont(14)
		self.authorLB.textColor = CommonColor.content.color
		self.view.addSubview(self.authorLB)
		
		self.subscribeBtn = UIButton.init(type: .custom)
		self.subscribeBtn.setTitle("添加至订阅库", for: .normal)
		self.subscribeBtn.setTitleColor(.white, for: .normal)
		self.subscribeBtn.titleLabel?.font = h_bfont(18);
		self.subscribeBtn.cornerRadius = 15;
		self.subscribeBtn.layer.masksToBounds = true;
		self.subscribeBtn.backgroundColor = CommonColor.mainRed.color
		self.subscribeBtn.addTarget(self, action: #selector(addPodToLibary), for: .touchUpInside)
		self.view.addSubview(self.subscribeBtn)
	}
	
	
}
