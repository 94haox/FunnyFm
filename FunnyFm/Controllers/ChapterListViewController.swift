//
//  ChapterListViewController.swift
//  FunnyFm
//
//  Created by wt on 2020/3/19.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit

class ChapterListViewController: UIViewController {
    
    var chapters: [Chapter]!
    
    var chapterListView: UICollectionView!
    
    var titleLB: UILabel = UILabel.init(text: "Chapters")
    
    var skipClourse: ((CMTime) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !VipManager.shared.isVip {
            self.alert("此功能仅向 Pro 用户开放",cancelHandler: { action in
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    func skipAction(time: CMTime) {
        self.dismiss(animated: true) {
            if self.skipClourse.isSome {
                self.skipClourse!(time)
            }
        }
    }
    
    func setupUI() {
        self.view.backgroundColor = CommonColor.white.color
        self.titleLB.font = p_bfont(18.auto())
        self.titleLB.textColor = R.color.titleColor()
        self.view.addSubview(self.titleLB)
        self.titleLB.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(18.auto())
            make.top.equalToSuperview().offset(18.auto())
        }
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: self.view.width-36.auto(), height: 80.auto())
        self.chapterListView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        self.chapterListView.dataSource = self
        self.chapterListView.backgroundColor = CommonColor.white.color
        self.chapterListView.register(UINib.init(nibName: "ChapterCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "cell")
        self.view.addSubview(self.chapterListView)
        self.chapterListView.snp.makeConstraints { (make) in
            make.left.width.bottom.equalToSuperview()
            make.top.equalTo(self.titleLB.snp_bottom).offset(32.auto())
        }
    }

}

extension ChapterListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.chapters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ChapterCollectionViewCell
        cell.config(chapter: self.chapters[indexPath.row], index: indexPath.row+1)
        cell.skipClourse = { [weak self] time in
            self?.skipAction(time: time)
        }
        return cell;
    }
}

extension ChapterListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let chapter = self.chapters[indexPath.row]
        self.skipAction(time: chapter.time)
    }
    
}
