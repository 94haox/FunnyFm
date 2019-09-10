//
//  PodListViewController.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/7.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit

class PodListViewController: BaseViewController , UICollectionViewDelegate, UICollectionViewDataSource, ViewModelDelegate{

    var vm = PodListViewModel.init()
    override func viewDidLoad() {
        super.viewDidLoad()
		self.titleLB.text = "我的订阅".localized
        self.vm.delegate = self
        self.vm.getAllPods()
		self.vm.getAllSubscribe()
        self.view.backgroundColor = .white
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
		self.view.backgroundColor = CommonColor.background.color
        self.view.addSubview(self.collectionView)
		
        self.collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLB.snp.bottom)
            make.left.width.bottom.equalToSuperview()
        }
		
    }
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: (kScreenWidth-32*3)/2, height: (kScreenWidth-32*3)/2.0)
        layout.minimumInteritemSpacing = 18
        layout.minimumLineSpacing = 31;
        layout.sectionInset = UIEdgeInsets.init(top: 30, left: 32, bottom: 0, right: 32)
        
        let collectionview = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionview.showsHorizontalScrollIndicator = false
        let nib = UINib(nibName: String(describing: PodListCollectionViewCell.self), bundle: nil)
        collectionview.register(nib, forCellWithReuseIdentifier: "cell")
        collectionview.backgroundColor = CommonColor.background.color
		collectionview.emptyDataSetSource = self;
        return collectionview
    }()

}


extension PodListViewController {
	
    func viewModelDidGetDataSuccess() {
        collectionView.reloadData()
    }
    
    func viewModelDidGetDataFailture(msg: String?) {
        SwiftNotice.noticeOnStatusBar("请求失败", autoClear: true, autoClearTime: 2)
    }
    
}

// MARK: UICollectionViewDelegate

extension PodListViewController{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let pod = self.vm.podlist[indexPath.row]
		let vc = PodDetailViewController.init(pod: pod)
		self.navigationController?.pushViewController(vc)
    }
    
}


// MARK: UICollectionViewDataSource

extension PodListViewController{
    
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return self.vm.podlist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? PodListCollectionViewCell else { return }
        let index = indexPath.row % self.vm.podlist.count
        let pod = self.vm.podlist[index]
        cell.configCell(pod)
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
