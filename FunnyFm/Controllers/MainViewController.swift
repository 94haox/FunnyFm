//
//  ViewController.swift
//  FunnyFm
//
//  Created by Duke on 2018/11/8.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import SnapKit
import SPStorkController

class MainViewController:  BaseViewController,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource{
    
    var vm = MainViewModel.init()
    
    fileprivate var cellsIsOpen = [Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vm.delegate = self
        self.vm.getAllPods()
        self.vm.getHomeChapters()
        self.view.backgroundColor = .white
        UIApplication.shared.keyWindow?.addSubview(FMToolBar.shared)
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		FMToolBar.shared.explain()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		FMToolBar.shared.shrink()
	}
	
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: 65, height: 65)
        layout.headerReferenceSize = CGSize(width: 95, height: 65)
        layout.scrollDirection = .horizontal
        let collectionview = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 80), collectionViewLayout: layout)
        collectionview.showsHorizontalScrollIndicator = false
        let nib = UINib(nibName: String(describing: HomePodCollectionViewCell.self), bundle: nil)
        let headernib = UINib(nibName: String(describing: HomePodListHeader.self), bundle: nil)
        collectionview.register(nib, forCellWithReuseIdentifier: "cell")
        collectionview.register(HomePodListHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionview.backgroundColor = .white
        collectionview.delegate = self
        collectionview.dataSource = self
        return collectionview
    }()
    
    lazy var tableview : UITableView = {
        let table = UITableView.init(frame: CGRect.zero, style: .plain)
        let nib = UINib(nibName: String(describing: HomeAlbumTableViewCell.self), bundle: nil)
        table.sectionHeaderHeight = 36
        table.register(nib, forCellReuseIdentifier: "tablecell")
        table.separatorStyle = .none
        table.rowHeight = 131
        table.delegate = self
        table.dataSource = self
        table.showsVerticalScrollIndicator = false
        table.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 120, right: 0)
        table.tableHeaderView = self.collectionView;
        return table
    }()
    
    lazy var searchBar : FMTextField = {
        let tf = FMTextField.init(frame: CGRect.zero)
        tf.cornerRadius = 15;
        tf.tintColor = CommonColor.mainRed.color
        tf.backgroundColor = CommonColor.cellbackgroud.color
        tf.placeholder = "search"
        tf.returnKeyType = .done
        tf.font = pfont(fontsize4)
        tf.textColor = CommonColor.title.color
        tf.delegate = tf
        tf.setValue(p_bfont(12), forKeyPath: "_placeholderLabel.font")
        tf.setValue(CommonColor.content.color, forKeyPath: "_placeholderLabel.textColor")
        return tf
    }()
    
    lazy var searchBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setBackgroundImage(UIImage.init(named: "search"), for: .normal)
        btn.addTarget(self, action: #selector(toSearch), for:.touchUpInside)
        return btn
    }()
    
    lazy var profileBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setBackgroundImage(UIImage.init(named: "profile"), for: .normal)
        btn.addTarget(self, action: #selector(toUserCenter), for:.touchUpInside)
        return btn
    }()
}


extension MainViewController{
    @objc func toUserCenter() {
        let usercenterVC = UserCenterViewController()
        self.navigationController?.pushViewController(usercenterVC)
    }
    
    @objc func toSearch() {
        let login = LoginViewController()
        self.present(login, animated: true, completion: nil)
    }
}


extension MainViewController : ViewModelDelegate {
    func viewModelDidGetDataSuccess() {
        collectionView.reloadData()
        tableview.reloadData()
		self.addConstrains()
		self.addFooter()
        if self.vm.chapterList.count > 0  && !FMToolBar.shared.isPlaying{
            FMToolBar.shared.configToolBarAtHome(self.vm.chapterList.first!)
        }
    }
    
    func viewModelDidGetDataFailture(msg: String?) {
        SwiftNotice.noticeOnStatusBar("请求失败", autoClear: true, autoClearTime: 2)
    }
    
}

// MARK: UICollectionViewDelegate

extension MainViewController{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pod = self.vm.podlist[indexPath.row]
        let vc = EpisodeListViewController.init(pod)
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? HomeAlbumTableViewCell else { return }
        let chapter = self.vm.chapterList[indexPath.row]
        cell.configHomeCell(chapter)
    }
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let label = UILabel.init(text: "最近更新")
		label.textColor = UIColor.init(hex: "e0e2e6")
		label.textAlignment = .center
		label.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 36);
		label.font = p_bfont(14)
		label.backgroundColor = .white
		return label
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
            header.tapClosure = {
                let podlistvc = PodListViewController()
                self.navigationController?.pushViewController(podlistvc)
                
            }
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
	
	func addFooter(){
		let label = UILabel.init(text: "- only last 15 -")
		label.textColor = UIColor.init(hex: "e0e2e6")
		label.textAlignment = .center
		label.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 36);
		label.font = h_bfont(14)
		label.backgroundColor = .white
		self.tableview.tableFooterView = label
	}
    
    
    fileprivate func addConstrains() {
        self.view.addSubview(self.profileBtn)
        self.view.addSubview(self.searchBtn)
        self.view.addSubview(self.searchBar)
        self.view.addSubview(self.tableview)
        
        self.profileBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 35, height: 35))
            make.left.equalToSuperview().offset(32)
            make.centerY.equalTo(self.searchBar)
        }
        
        self.searchBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 40, height: 40))
            make.right.equalToSuperview().offset(-32)
            make.centerY.equalTo(self.searchBar)
        }
        
        self.searchBar.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.left.equalTo(self.profileBtn.snp.right).offset(32)
            make.right.equalTo(self.searchBtn.snp.left).offset(-16)
            make.top.equalTo(self.view.snp.topMargin)
        }
                
        self.tableview.snp.makeConstraints { (make) in
            make.left.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(self.searchBar.snp.bottom).offset(32)
        }
    }
    
}


