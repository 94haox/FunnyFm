//
//  DiscoverListTableViewCell.swift
//  FunnyFm
//
//  Created by Duke on 2020/1/31.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit

class DiscoverListTableViewCell: UITableViewCell {
	
	var collectionView: UICollectionView!
	
	var items: [iTunsPod] = [iTunsPod]()
	
	var clickCloure: ((iTunsPod)->Void)?
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.setupUI()
	}
	
	func config(collection: PodcastCollection) {
		self.items = collection.items
		self.collectionView.reloadData()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension DiscoverListTableViewCell: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if self.clickCloure.isSome {
			self.clickCloure!(self.items[indexPath.row])
		}
	}
	
}

extension DiscoverListTableViewCell: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.items.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DiscoverPodcastViewCell
		cell.config(podcast: self.items[indexPath.row])
		return cell
	}
	
}



extension DiscoverListTableViewCell {
	
	func setupUI(){
		self.selectionStyle = .none
		let layout = UICollectionViewFlowLayout.init()
		layout.itemSize = CGSize.init(width: 80.auto(), height: 160.auto())
		layout.minimumLineSpacing = 12.auto()
		layout.scrollDirection = .horizontal
		self.collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
		self.collectionView.register(DiscoverPodcastViewCell.self, forCellWithReuseIdentifier: "cell")
		self.collectionView.backgroundColor = UIColor.clear
		self.collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 24.auto(), bottom: 0, right: 24.auto())
		self.collectionView.delegate = self
		self.collectionView.dataSource = self
		self.collectionView.showsHorizontalScrollIndicator = false
		self.contentView.addSubview(self.collectionView)
		self.collectionView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
	}
	
}
