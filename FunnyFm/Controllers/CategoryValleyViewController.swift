//
//  CategoryValleyViewController.swift
//  FunnyFm
//
//  Created by 吴涛 on 2020/11/25.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit
import Swift_PageMenu

struct FFPagerOption: PageMenuOptions {

    var isInfinite: Bool = false

    var tabMenuPosition: TabMenuPosition = .top

    var menuItemSize: PageMenuItemSize {
        return .sizeToFit(minWidth: 80, height: 30)
    }

    var menuTitleColor: UIColor {
        return R.color.mainRed()!
    }

    var menuTitleSelectedColor: UIColor {
        return .white
    }

    var menuCursor: PageMenuCursor {
        return .roundRect(rectColor: R.color.mainRed()!, cornerRadius: 5, height: 24, borderWidth: nil, borderColor: nil)
    }

    var font: UIFont {
        return pfont(14)
    }

    var menuItemMargin: CGFloat {
        return 8
    }

    var tabMenuBackgroundColor: UIColor {
        return R.color.whiteBackground()!
    }

    var tabMenuContentInset: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
    }

    public init(isInfinite: Bool = false, tabMenuPosition: TabMenuPosition = .top) {
        self.isInfinite = isInfinite
        self.tabMenuPosition = tabMenuPosition
    }
}

class CategoryValleyViewController: PageMenuController {
    
    let vm : PodListViewModel = {
        return PodListViewModel()
    }()
    
    var index: Int = 0
    
    var changeBtn: UIButton = {
        $0.tintColor = R.color.mainRed()
        $0.setImage(UIImage(systemName: "arrow.right.arrow.left.circle"), for: .normal)
        return $0
    }(UIButton(type: .custom))
    
    var country = CountryCodeLibrary.shared.deviceCountry
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "播客分类".localized
        self.delegate = self
        self.dataSource = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.changeBtn)
        self.changeBtn.addTarget(self, action: #selector(changeCountry), for: .touchUpInside)
        let image = UIImage.init(systemName: "chevron.left.square.fill")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self.navigationController, action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem?.tintColor = R.color.mainRed()
        self.view.backgroundColor = R.color.background()
    }
    
    @objc func changeCountry() {
        let countryVC = SelectCountryViewController()
        countryVC.delegate = self
        self.navigationController?.pushViewController(countryVC)
    }

}

extension CategoryValleyViewController: SelectCountryViewControllerDelegate {
    
    func selectCountryViewController(_ viewController: SelectCountryViewController, didSelectCountry country: Country) {
        self.vm.countryCode = country.isoRegionCode
        self.vm.searchTopic(keyword: self.vm.topicIDs[index])
        viewController.navigationController?.popViewController()
    }
    
}

extension CategoryValleyViewController: PageMenuControllerDataSource {

    func viewControllers(forPageMenuController pageMenuController: PageMenuController) -> [UIViewController] {
        return self.vm.topicIDs.map { (id) -> TopicViewController in
            TopicViewController(topicId: id, vm: self.vm)
        }
    }

    func menuTitles(forPageMenuController pageMenuController: PageMenuController) -> [String] {
        return self.vm.topics
    }

    func defaultPageIndex(forPageMenuController pageMenuController: PageMenuController) -> Int {
        return 0
    }
}

extension CategoryValleyViewController: PageMenuControllerDelegate {

    func pageMenuController(_ pageMenuController: PageMenuController, didScrollToPageAtIndex index: Int, direction: PageMenuNavigationDirection) {
        self.index = index
    }

    func pageMenuController(_ pageMenuController: PageMenuController, willScrollToPageAtIndex index: Int, direction: PageMenuNavigationDirection) {
        
    }

    func pageMenuController(_ pageMenuController: PageMenuController, scrollingProgress progress: CGFloat, direction: PageMenuNavigationDirection) {
        
    }

    func pageMenuController(_ pageMenuController: PageMenuController, didSelectMenuItem index: Int, direction: PageMenuNavigationDirection) {
        self.index = index
    }
}
