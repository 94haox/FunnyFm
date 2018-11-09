//
//  ViewController.swift
//  FunnyFm
//
//  Created by Duke on 2018/11/8.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import expanding_collection

class MainViewController:  ExpandingViewController{
    var vm = MainViewModel()
    fileprivate var cellsIsOpen = [Bool]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vm.delegate = self
        self.view.backgroundColor = CommonColor.background.color
        itemSize = CGSize(width: 256, height: 460)
        registerCell()
//        fillCellIsOpenArray()
        addGesture(to: collectionView!)
        configureNavBar()
        self.vm.getAllPods()
    }
}

extension MainViewController {
    
    fileprivate func registerCell() {
        let nib = UINib(nibName: String(describing: PodListCollectionViewCell.self), bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: "cell")
    }
    
    fileprivate func fillCellIsOpenArray() {
        cellsIsOpen = Array(repeating: false, count: self.vm.podlist.count)
    }
    
    fileprivate func getViewController(_ index: Int) -> ExpandingTableViewController {
        let pod = self.vm.podlist[index]
        let listvc = ChapterListViewController.init(albumId: pod.albumId)
        return listvc
    }
    
    fileprivate func configureNavBar() {
        navigationItem.leftBarButtonItem?.image = navigationItem.leftBarButtonItem?.image!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    }
}

extension MainViewController : ViewModelDelegate {
    func viewModelDidGetDataSuccess() {
        fillCellIsOpenArray()
        collectionView?.reloadData()
    }
    
    func viewModelDidGetDataFailture(msg: String?) {
        
    }
    
}

/// MARK: Gesture
extension MainViewController {
    
    fileprivate func addGesture(to view: UIView) {
        let upGesture = Init(UISwipeGestureRecognizer(target: self, action: #selector(MainViewController.swipeHandler(_:)))) {
            $0.direction = .up
        }
        
        let downGesture = Init(UISwipeGestureRecognizer(target: self, action: #selector(MainViewController.swipeHandler(_:)))) {
            $0.direction = .down
        }
        view.addGestureRecognizer(upGesture)
        view.addGestureRecognizer(downGesture)
    }
    
    @objc func swipeHandler(_ sender: UISwipeGestureRecognizer) {
        let indexPath = IndexPath(row: currentIndex, section: 0)
        guard let cell = collectionView?.cellForItem(at: indexPath) as? PodListCollectionViewCell else { return }
        // double swipe Up transition
        if cell.isOpened == true && sender.direction == .up {
            pushToViewController(getViewController(indexPath.row))
            
            if let rightButton = navigationItem.rightBarButtonItem as? AnimatingBarButton {
                rightButton.animationSelected(true)
            }
        }
        
        let open = sender.direction == .up ? true : false
        cell.cellIsOpen(open)
        cellsIsOpen[indexPath.row] = cell.isOpened
    }
}

// MARK: UIScrollViewDelegate

extension MainViewController {
    
//    func scrollViewDidScroll(_: UIScrollView) {
//        pageLabel.text = "\(currentIndex + 1)/\(items.count)"
//    }
}

// MARK: UICollectionViewDataSource

extension MainViewController {
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        guard let cell = cell as? PodListCollectionViewCell else { return }
        let index = indexPath.row % self.vm.podlist.count
        let pod = self.vm.podlist[index]
        cell.configCell(pod: pod)
        cell.cellIsOpen(cellsIsOpen[index], animated: false)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PodListCollectionViewCell
            , currentIndex == indexPath.row else { return }
        
        if cell.isOpened == false {
            cell.cellIsOpen(true)
        } else {
            pushToViewController(getViewController(indexPath.row))
            
            if let rightButton = navigationItem.rightBarButtonItem as? AnimatingBarButton {
                rightButton.animationSelected(true)
            }
        }
    }
}

// MARK: UICollectionViewDataSource

extension MainViewController{
    
    override func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return self.vm.podlist.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
}


