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

    override func viewDidLoad() {
        super.viewDidLoad()
		self.setupUI()
		self.viewModel.getNotes(episode: self.episode!) { () in
			self.noteListView.reloadData()
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
		layout.itemSize = CGSize.init(width: 150, height: 130)
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
			make.bottom.equalToSuperview().offset(-15)
			make.top.equalTo(self.titleLB.snp.bottom).offset(24)
		}
	}
	
	
	
}
