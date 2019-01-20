//
//  EpisodeDetailViewController.swift
//  FunnyFm
//
//  Created by Duke on 2019/1/15.
//  Copyright © 2019 Duke. All rights reserved.
//

import UIKit

class EpisodeDetailViewController: BaseViewController {

    
    @IBOutlet weak var dateLB: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var desLB: UILabel!
    @IBOutlet weak var podLB: UILabel!
    @IBOutlet weak var titleLB: UILabel!
    var episode: Episode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.desLB.text = self.episode.intro;
        self.podLB.text = self.episode.pod_name
        self.titleLB.text = self.episode.title
        self.duration.text = String(self.episode.duration)
        self.dateLB.text = self.episode.formatted_created_at
        self.containerView.snp.updateConstraints { (make) in
            make.bottom.equalTo(self.desLB).offset(30)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController()
    }
    
}
