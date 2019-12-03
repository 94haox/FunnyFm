//
//  NoteListViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/12/2.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class NoteListViewController: UIViewController {
	
	@IBOutlet weak var titleLB: UILabel!
	var viewModel: NoteViewModel = NoteViewModel()
	var episode: Episode?
	var noteListView: UICollectionView!
	var loadingView: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
		self.setupUI()
		self.viewModel.getNotes(episode: self.episode!) { [weak self]() in
			self?.loadingView.removeFromSuperview()
			self?.noteListView.reloadData()
		}
    }

}

extension NoteListViewController: UICollectionViewDelegate{
	
}

extension NoteListViewController: UICollectionViewDataSource{
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.viewModel.notelist.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! NoteCollectionViewCell
		cell.config(note: self.viewModel.notelist[indexPath.row])
		return cell
	}
}


extension NoteListViewController {
	
	func setupUI(){
		
		let layout = UICollectionViewFlowLayout.init()
		layout.minimumInteritemSpacing = 20
		layout.scrollDirection = .horizontal
		layout.itemSize = CGSize.init(width: 150.auto(), height: 130.auto())
		self.noteListView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
		self.noteListView.register(UINib.init(nibName: "NoteCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "cell")
		self.noteListView.delegate = self
		self.noteListView.dataSource = self;
		self.noteListView.backgroundColor = .white
		self.noteListView.showsHorizontalScrollIndicator = false
		self.noteListView.contentInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
		
		self.view.addSubview(self.noteListView)
		self.noteListView.snp.makeConstraints { (make) in
			make.left.width.equalToSuperview()
			make.height.equalTo(160.auto())
			make.top.equalTo(self.titleLB.snp.bottom).offset(24.auto())
		}
		
		self.loadingView = UIActivityIndicatorView.init(style: .gray)
		self.view.addSubview(self.loadingView)
		self.loadingView.snp.makeConstraints { (make) in
			make.center.equalTo(self.noteListView)
		}
		self.loadingView.startAnimating()
	}
	
	
	
}
