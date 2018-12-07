//
//  ChapterListViewController.swift
//  FunnyFm
//
//  Created by Duke on 2018/12/7.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit

class ChapterListViewController: UIViewController , ViewModelDelegate, UITableViewDelegate,UITableViewDataSource{

    var vm: ChapterListViewModel!
    
    var pod: Pod!
    
    var chapterTable: UITableView!
    
    init(_ pod: Pod) {
        super.init(nibName: nil, bundle: nil)
        self.pod = pod
        self.title = pod.name
        self.vm = ChapterListViewModel.init(pod.albumId)
        self.vm.delegate = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addConstrains()
        // Do any additional setup after loading the view.
    }
    
    lazy var tableview : UITableView = {
        let table = UITableView.init(frame: CGRect.zero, style: .plain)
        let nib = UINib(nibName: String(describing: HomeAlbumTableViewCell.self), bundle: nil)
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


extension ChapterListViewController{
    
    func viewModelDidGetDataSuccess() {
        self.tableview.reloadData()
    }
    
    func viewModelDidGetDataFailture(msg: String?) {
        
    }
    
}


// MARK: UITableViewDelegate

extension ChapterListViewController{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chapter = self.vm.chapterList[indexPath.row]
        FMToolBar.shared.configToolBar(chapter)
    }
}

extension ChapterListViewController{
    
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
        cell.configCell(chapter)
    }
    
}

extension ChapterListViewController {
    
    
    fileprivate func addConstrains() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.tableview)
        self.tableview.snp.makeConstraints { (make) in
            make.left.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(self.view.snp.topMargin)
        }
    }
    
}

