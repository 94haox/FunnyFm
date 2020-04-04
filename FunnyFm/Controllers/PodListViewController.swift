//
//  PodListViewController.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/7.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit

class PodListViewController: BaseViewController , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    var vm = PodListViewModel.init()
	
	var syncBtn = UIButton.init(type: .custom)
    var segment = UISegmentedControl.init(items: ["已同步".localized,"未同步".localized])
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.titleLB.text = "我的订阅".localized
		self.setupUI()
		self.vm.delegate = self
		Hud.shared.show(style: .busy, on: self.view)
		NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: Notification.Name.init(rawValue: "kSyncSuccess"), object: nil)
    }
	
	@objc func changeSegment(){
		self.collectionView .reloadData()
	}
	
	@objc func toSyncSubscribe(){
		if self.vm.podlist.count < 1 {
			return
		}
		let syncVC = CloudSyncViewController.init()
		syncVC.syncList = self.vm.podlist
		self.presentAsStork(syncVC, height: 350)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.vm.getAllSubscribe()
	}
	
	@objc func refresh(){
		self.vm.getAllSubscribe()
	}
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: 139.auto(), height: 139.auto())
        layout.minimumInteritemSpacing = 18
        layout.minimumLineSpacing = 31;
        let collectionview = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionview.showsHorizontalScrollIndicator = false
        let nib = UINib(nibName: String(describing: PodListCollectionViewCell.self), bundle: nil)
        collectionview.register(nib, forCellWithReuseIdentifier: "cell")
        collectionview.backgroundColor = CommonColor.white.color
		collectionview.emptyDataSetSource = self;
		collectionview.showsVerticalScrollIndicator = false
		collectionview.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: toolbarH*2, right: 0)
        return collectionview
    }()

}


extension PodListViewController: PodListViewModelDelegate{
	func didSyncSuccess(index: Int) {
		
	}
	
	
    func viewModelDidGetDataSuccess() {
        collectionView.reloadData()
		Hud.shared.hide()
    }
    
    func viewModelDidGetDataFailture(msg: String?) {
		Hud.shared.hide()
        SwiftNotice.noticeOnStatusBar("请求失败", autoClear: true, autoClearTime: 2)
    }
    
}

// MARK: UICollectionViewDelegate

extension PodListViewController{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		var pod: iTunsPod? = nil
		
		if self.segment.selectedSegmentIndex != 0 || !UserCenter.shared.isLogin {
			pod = self.vm.podlist[indexPath.row]
		}else{
			pod = self.vm.syncList[indexPath.row]
		}
		
		if pod.isSome {
			let vc = PodDetailViewController.init(pod: pod!)
			self.navigationController?.pushViewController(vc)
		}
    }
    
}


// MARK: UICollectionViewDataSource

extension PodListViewController{
    
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
		if self.segment.selectedSegmentIndex == 0 && UserCenter.shared.isLogin{
			return self.vm.syncList.count
		}else{
			return self.vm.podlist.count
		}
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		var pod: iTunsPod
        if self.segment.selectedSegmentIndex == 0 && UserCenter.shared.isLogin{
			pod = self.vm.syncList[indexPath.row]
		}else{
			pod = self.vm.podlist[indexPath.row]
		}
        guard let cell = cell as? PodListCollectionViewCell else { return }
        cell.configCell(pod)
    }
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		if UserCenter.shared.isLogin {
			return UIEdgeInsets.init(top: 85, left: 32, bottom: 0, right: 32)
		}else{
			return UIEdgeInsets.init(top: 30, left: 32, bottom: 0, right: 32)
		}
	}
	
	
}

extension PodListViewController : DZNEmptyDataSetSource {
	
	func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
		return UIImage.init(named: "download-empty")
	}
	
	func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
		return NSAttributedString.init(string: "快去发掘有趣的播客吧~".localized, attributes: [NSAttributedString.Key.font: pfont(fontsize2)])
	}
	
}


// MARK: - UI
extension PodListViewController {
	
	func setupUI() {
		
		self.collectionView.delegate = self
		self.collectionView.dataSource = self
		self.view.addSubview(self.collectionView)
		
		self.collectionView.snp.makeConstraints { (make) in
			make.top.equalTo(self.titleLB.snp.bottom)
			make.left.width.bottom.equalToSuperview()
		}
		
		if UserCenter.shared.isLogin {
		
            self.view.addSubview(self.segment)
            self.segment.tintColor = R.color.mainRed()
            self.segment.selectedSegmentIndex = 0
            self.segment.addTarget(self, action: #selector(changeSegment), for: .valueChanged)
			
			self.syncBtn.setImage(UIImage.init(named: "cloud-sync"), for: .normal)
			self.syncBtn.isHidden = true
			
			self.syncBtn.addTarget(self, action: #selector(toSyncSubscribe), for: .touchUpInside)
			
			self.view.addSubview(self.syncBtn)
			
			self.syncBtn.snp.makeConstraints { (make) in
				make.right.equalToSuperview().offset(-16.adapt())
				make.centerY.equalTo(self.titleLB)
				make.size.equalTo(CGSize.init(width: 30, height: 30))
			}
			
			self.segment.snp.makeConstraints { (make) in
				make.top.equalTo(self.topBgView.snp.bottom).offset(10)
				make.size.equalTo(CGSize.init(width: 180, height: 40))
				make.centerX.equalToSuperview()
			}
		}
	}
}
