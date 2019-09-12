//
//  CloudSyncViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/9/11.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class CloudSyncViewController: UIViewController {
	
	var vm: PodListViewModel = PodListViewModel()
	
	var syncList: [iTunsPod] = []
	
	var syncBtn: Loady = Loady.init()
	
	var syncSwitch: DWSwitch = DWSwitch()
	
	var syncLB: UILabel = UILabel.init(text: "自动同步订阅".localized)
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.vm.delegate = self
       	self.setupUI()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.syncSwitch.dw_configPathLayer()
	}
	
	var collectionView : UICollectionView = {
		let layout = UICollectionViewFlowLayout.init()
		layout.itemSize = CGSize(width: 100, height: 100)
		layout.minimumLineSpacing = 12
		layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
		let collectionview = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
		let nib = UINib(nibName: String(describing: CloudSyncCollectionViewCell.self), bundle: nil)
		collectionview.contentInset = UIEdgeInsets.init(top: 16, left: 16, bottom: 0, right: 16)
		collectionview.register(nib, forCellWithReuseIdentifier: "cell")
		collectionview.backgroundColor = CommonColor.background.color
		collectionview.showsHorizontalScrollIndicator = false
		return collectionview
	}()

}

extension CloudSyncViewController: PodListViewModelDelegate {
	
	func didSyncSuccess(index: Int) {
		let progress =  Double(index)/Double(self.syncList.count) * 100
		self.syncBtn.fillTheButton(with: CGFloat(progress))
		self.syncBtn.setTitle("同步中".localized+"\(index)/\(self.syncList.count)", for: .normal)
		if progress >= 100 {
			ImpactManager.impact(UIImpactFeedbackGenerator.FeedbackStyle.heavy)
			self.syncBtn.setTitle("同步成功".localized, for: .normal)
			NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "kSyncSuccess"), object: nil)
			DispatchQueue.main.asyncAfter(deadline: .now()+2) {
				self.dismiss(animated: true, completion: nil)
			}
		}
	}
	
	func viewModelDidGetDataSuccess() {
		
	}
	
	func viewModelDidGetDataFailture(msg: String?) {
		
	}
	
	
}

// MARK: - actions
extension CloudSyncViewController {
	
	@objc func syncPods(){
		ImpactManager.impact()
		if self.syncBtn.loadingIsShowing() {
//			self.syncBtn.stopLoading()
			return
		}
		self.syncBtn.startLoading(loadingType: LoadingType(rawValue: self.syncBtn.animationType) ?? .none)
		var podidList = [String]()
		self.syncList.forEach { (pod) in
			if pod.podId.length() > 1{
				podidList.append(pod.podId)
			}
		}
		
		self.vm.syncSubscribelist(podidList: podidList)
	}
	
	@objc func changeAutoSync(){
		PreferenceCenter.shared.isAutoSync = self.syncSwitch.isOn
	}
	
}

// MARK: - UICollectionViewDelegate
extension CloudSyncViewController: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
	}
	
}

// MARK: - UICollectionViewDataSource
extension CloudSyncViewController: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.syncList.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		let pod = self.syncList[indexPath.row]
		let podCell = cell as! CloudSyncCollectionViewCell
		podCell.config(pod: pod)
	}
	
}

// MARK: - UI
extension CloudSyncViewController {
	
	func setupUI(){
		self.collectionView.delegate = self
		self.collectionView.dataSource = self
		self.syncBtn.animationType = 3
		self.syncBtn.backgroundFillColor = CommonColor.mainRed.color
		self.syncBtn.backgroundColor = .black
		self.syncBtn.setTitleColor(.white, for: .normal)
		self.syncBtn.setTitle("同步订阅".localized, for: .normal)
		self.syncBtn.titleLabel?.font = pfont(15)
		self.syncBtn.cornerRadius = 5
		self.syncBtn.addTarget(self, action: #selector(syncPods), for: .touchUpInside)
		self.syncLB.font = pfont(15)
		self.syncLB.textColor = CommonColor.content.color
		self.syncSwitch.addShadow(ofColor: CommonColor.content.color, radius: 5, offset: CGSize.init(width: 0, height: 0), opacity: 0.6)
		self.syncSwitch.addTarget(self, action: #selector(changeAutoSync), for: .valueChanged)
		self.view.addSubview(self.collectionView)
		self.view.addSubview(self.syncBtn)
		self.view.addSubview(self.syncLB)
		self.view.addSubview(self.syncSwitch)
		
		self.syncLB.snp.makeConstraints { (make) in
			make.top.equalTo(self.collectionView.snp.bottom).offset(24)
			make.left.equalTo(self.syncBtn)
		}
		
		self.syncSwitch.snp_makeConstraints { (make) in
			make.centerY.equalTo(self.syncLB)
			make.right.equalTo(self.syncBtn)
			make.size.equalTo(CGSize.init(width: 45, height: 25));
		}
		
		self.collectionView.snp.makeConstraints { (make) in
			make.left.width.equalToSuperview()
			make.top.equalToSuperview()
			make.height.equalTo(200)
		}
		
		self.syncBtn.snp.makeConstraints { (make) in
			make.top.equalTo(self.syncSwitch.snp.bottom).offset(24)
			make.centerX.equalToSuperview()
			make.height.equalTo(50)
			make.width.equalToSuperview().multipliedBy(0.6)
		}
		
		if PreferenceCenter.shared.isAutoSync {
			self.syncSwitch.toRight()
		}

	}
	
}

