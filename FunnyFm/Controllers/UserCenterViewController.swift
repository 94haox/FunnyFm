//
//  UserCenterViewController.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/11.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit


class UserCenterViewController: BaseViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dw_addSubviews()
    }
    
    func dw_addSubviews(){
        
        self.view.addSubview(self.titleLB)
        self.view.addSubview(self.collectionView)
        self.titleLB.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.topMargin).offset(30)
            make.left.equalToSuperview().offset(30)
        }
        
        self.collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLB.snp.bottom).offset(50)
            make.left.width.bottom.equalToSuperview()
        }
        
        self.view.backgroundColor = CommonColor.cellbackgroud.color

    }
    
    lazy var titleLB: UILabel = {
        let lb = UILabel.init(text: "未登录")
        lb.font = p_bfont(32)
        lb.textColor = CommonColor.subtitle.color
        return lb
    }()
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: 146, height: 168)
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 30, bottom: 0, right: 30)
        let collectionview = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        let nib = UINib(nibName: String(describing: UserCenterCollectionViewCell.self), bundle: nil)
        let headernib = UINib(nibName: String(describing: UserCenterCollectionViewCell.self), bundle: nil)
        collectionview.register(nib, forCellWithReuseIdentifier: "cell")
        collectionview.backgroundColor = CommonColor.cellbackgroud.color
        collectionview.delegate = self
        collectionview.dataSource = self
        return collectionview
    }()
    
    var datasource: Array<[String:String]> = [["title":"收听记录","subtitle":"","imageName":"lishijilu"],
                                           ["title":"我的收藏","subtitle":"","imageName":"mark"],
                                           ["title":"我的下载","subtitle":"","imageName":"download"],
                                           ["title":"我的订阅","subtitle":"","imageName":"handbag"],
                                           ["title":"设置","subtitle":"","imageName":"setting"],
                                           ]
}


extension UserCenterViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserCenterCollectionViewCell
        cell.configCell(self.datasource[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 4 {
            let setvc = SettingViewController()
            self.navigationController?.pushViewController(setvc)
        }
        
        if indexPath.row == 0 {
            let historyVc = HistoryListViewController()
            self.navigationController?.pushViewController(historyVc)
        }
    }
}
