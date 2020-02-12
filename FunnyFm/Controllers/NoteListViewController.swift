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
			if (self?.viewModel.notelist.count)! < 1 {
				self?.noteListView.emptyDataSetSource = self;
			}
			self?.noteListView.reloadData()
		}
    }

}

extension NoteListViewController: UICollectionViewDelegate{
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let detailVC = NoteDetailViewController.init()
		detailVC.note = self.viewModel.notelist[indexPath.row]
		detailVC.deleteCallback = { (noteId) in
			var tempIndex = 1000000
			for (index, note) in self.viewModel.notelist.enumerated() {
				if note.noteId == noteId {
					tempIndex = index
				}
			}
			if tempIndex < 1000000 {
				self.viewModel.notelist.remove(at: tempIndex)
				collectionView.reloadData()
			}
		}
		self.present(detailVC, animated: true, completion: nil)
	}
	
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

extension NoteListViewController: DZNEmptyDataSetSource{
	func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
		return NSAttributedString.init(string: "单集还没有笔记哦~", attributes: [NSAttributedString.Key.font : pfont(12)])
	}
	
	func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
		return UIImage.init(named: "empty")
	}
}

extension NoteListViewController {
	
	func setupUI(){
        self.view.backgroundColor = CommonColor.white.color
		let layout = UICollectionViewFlowLayout.init()
		layout.minimumInteritemSpacing = 20
		layout.scrollDirection = .horizontal
		layout.itemSize = CGSize.init(width: 150.auto(), height: 130.auto())
		self.noteListView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
		self.noteListView.register(UINib.init(nibName: "NoteCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "cell")
		self.noteListView.delegate = self
		self.noteListView.dataSource = self;
		self.noteListView.backgroundColor = CommonColor.white.color
		self.noteListView.showsHorizontalScrollIndicator = false
		self.noteListView.contentInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
		self.noteListView.clipsToBounds = false;
		
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
