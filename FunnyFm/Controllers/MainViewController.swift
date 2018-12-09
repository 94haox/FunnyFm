//
//  ViewController.swift
//  FunnyFm
//
//  Created by Duke on 2018/11/8.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import SnapKit

class MainViewController:  BaseViewController,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource{
    
    var vm = MainViewModel()
    fileprivate var cellsIsOpen = [Bool]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vm.delegate = self
        self.view.backgroundColor = .white
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
		self.configureNavBar()
        self.addConstrains()
        self.vm.getAllPods()
        UIApplication.shared.keyWindow?.addSubview(FMToolBar.shared)
    }
	
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: 65, height: 65)
        layout.headerReferenceSize = CGSize(width: 95, height: 65)
        layout.scrollDirection = .horizontal
        let collectionview = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionview.showsHorizontalScrollIndicator = false
        let nib = UINib(nibName: String(describing: HomePodCollectionViewCell.self), bundle: nil)
        let headernib = UINib(nibName: String(describing: HomePodListHeader.self), bundle: nil)
        collectionview.register(nib, forCellWithReuseIdentifier: "cell")
        collectionview.register(HomePodListHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionview.backgroundColor = .white
        return collectionview
    }()
    
    lazy var tableview : UITableView = {
        let table = UITableView.init(frame: CGRect.zero, style: .plain)
        let nib = UINib(nibName: String(describing: HomeAlbumTableViewCell.self), bundle: nil)
        table.sectionHeaderHeight = 18
        table.register(nib, forCellReuseIdentifier: "tablecell")
        table.separatorStyle = .none
        table.rowHeight = 131
        table.delegate = self
        table.dataSource = self
        table.showsVerticalScrollIndicator = false
        table.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 120, right: 0)
        return table
    }()
}


extension MainViewController : ViewModelDelegate {
    func viewModelDidGetDataSuccess() {
        collectionView.reloadData()
        tableview.reloadData()
        
        if self.vm.chapterList.count > 0 {
            FMToolBar.shared.configToolBarAtHome(self.vm.chapterList.first!)
        }
    }
    
    func viewModelDidGetDataFailture(msg: String?) {
        
    }
    
}

// MARK: UICollectionViewDelegate

extension MainViewController{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pod = self.vm.podlist[indexPath.row]
        let vc = ChapterListViewController.init(pod)
        self.navigationController?.pushViewController(vc)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chapter = self.vm.chapterList[indexPath.row]
        FMToolBar.shared.configToolBarAtHome(chapter)
    }
}

extension MainViewController{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.chapterList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel.init(text: "最近更新")
        label.textColor = UIColor.init(hex: "e0e2e6")
        label.textAlignment = .center
        label.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 18);
        label.font = p_bfont(14)
        label.backgroundColor = .white
        return label
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? HomeAlbumTableViewCell else { return }
        let chapter = self.vm.chapterList[indexPath.row]
        cell.configHomeCell(chapter)
    }

}


// MARK: UICollectionViewDataSource

extension MainViewController{
    
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return self.vm.podlist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var header = HomePodListHeader()
        if kind == UICollectionView.elementKindSectionHeader {
            header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath as IndexPath) as! HomePodListHeader;
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? HomePodCollectionViewCell else { return }
        let index = indexPath.row % self.vm.podlist.count
        let pod = self.vm.podlist[index]
        cell.configCell(pod)
    }
}

extension MainViewController {
    
    
    fileprivate func addConstrains() {
        
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.tableview)
        
        self.collectionView.snp.makeConstraints { (make) in
            make.left.width.equalToSuperview()
            make.height.equalTo(80)
            make.top.equalTo(self.view.snp.topMargin)
        }
        
        self.tableview.snp.makeConstraints { (make) in
            make.left.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(self.collectionView.snp.bottom).offset(18)
        }
    }
    
    fileprivate func configureNavBar() {
        navigationItem.leftBarButtonItem?.image = navigationItem.leftBarButtonItem?.image!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
		self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}


