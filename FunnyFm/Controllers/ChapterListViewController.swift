//
//  ChapterListViewController.swift
//  FunnyFm
//
//  Created by Duke on 2018/11/9.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit
import expanding_collection


class ChapterListViewController: ExpandingTableViewController {
    
    fileprivate var scrollOffsetY: CGFloat = 0
    
    init(albumId:Int) {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
//        let image1 = Asset.backgroundImage.image
//        tableView.backgroundView = UIImageView(image: image1)
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        // Do any additional setup after loading the view.
    }

}


// MARK: Helpers

extension ChapterListViewController {
    
    fileprivate func configureNavBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
//        navigationItem.leftBarButtonItem?.image = navigationItem.leftBarButtonItem?.image!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//        navigationItem.rightBarButtonItem?.image = navigationItem.rightBarButtonItem?.image!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    }
}

// MARK: Actions

extension ChapterListViewController {
    
    @IBAction func backButtonHandler(_: AnyObject) {
        // buttonAnimation
        let viewControllers: [MainViewController?] = navigationController?.viewControllers.map { $0 as? MainViewController } ?? []
        
        for viewController in viewControllers {
            if let rightButton = viewController?.navigationItem.rightBarButtonItem as? AnimatingBarButton {
                rightButton.animationSelected(false)
            }
        }
        popTransitionAnimation()
    }
}

// MARK: UIScrollViewDelegate

extension ChapterListViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -25 , let navigationController = navigationController {
            // buttonAnimation
            for case let viewController as MainViewController in navigationController.viewControllers {
                if case let rightButton as AnimatingBarButton = viewController.navigationItem.rightBarButtonItem {
                    rightButton.animationSelected(false)
                }
            }
            popTransitionAnimation()
        }
        scrollOffsetY = scrollView.contentOffset.y
    }
}
