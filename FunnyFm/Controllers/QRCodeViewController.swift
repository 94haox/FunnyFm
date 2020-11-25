//
//  QRCodeViewController.swift
//  FunnyFm
//
//  Created by 吴涛 on 2020/10/17.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit
import EFQRCode

class QRCodeViewController: BaseViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var subtitleLB: UILabel!
    @IBOutlet weak var noteLB: UILabel!
    @IBOutlet weak var wallImageView: UIImageView!
    @IBOutlet weak var qrCodeImage: UIImageView!
    @IBOutlet weak var shareBtn: RoundedButton!
    @IBOutlet weak var contentLB: UILabel!
    private let qrBoundingBox = BoundingBoxView()
    var podcast: iTunsPod?
    var episode: Episode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "分享"
        view.addSubview(qrBoundingBox)
        contentLB.numberOfLines = 0
        config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.qrBoundingBox.borderColor = R.color.mainRed()!
            self.qrBoundingBox.backgroundOpacity = 0
            let frame = CGRect(x: self.qrCodeImage.frame.minX - 10, y: self.qrCodeImage.frame.minY - 10, width:  self.qrCodeImage.frame.width + 20, height:  self.qrCodeImage.frame.height + 20)
            self.qrBoundingBox.frame = frame
            self.qrBoundingBox.perform(transition: .fadeIn, duration: 0.1)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @IBAction func shareAction(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: "http://funnyfm.top/#/podcast/\(podcast!.podId)")!)
//        let textToShare = self.titleLB.text!
//        let imageToShare = qrCodeImage.image
//        let items = [textToShare,imageToShare!] as [Any]
//        let activityVC = VisualActivityViewController(activityItems: items, applicationActivities: nil)
//        self.present(activityVC, animated: true, completion: nil)
    }
    
    func config() {
        if let episode = self.episode {
            let podcast = DatabaseManager.getPodcast(feedUrl: episode.podcastUrl)
            self.imageView.loadImage(url: episode.coverUrl)
            self.titleLB.text = episode.title
            self.subtitleLB.text = "播客: \(podcast!.trackName)"
            self.noteLB.text = "更新日期: \(episode.pubDate)"
            self.contentLB.text = episode.intro
        }
        
        if let podcast = self.podcast {
            let episodes = DatabaseManager.allEpisodes(pod: podcast)
            self.imageView.loadImage(url: podcast.artworkUrl600)
            self.titleLB.text = podcast.trackName
            self.subtitleLB.text = "共有: \(episodes.count) 集"
            if let episode = episodes.first {
                self.noteLB.text = "最新更新: \(episode.pubDate)"
            }else{
                self.noteLB.text = "最新更新: \(podcast.releaseDate)"
            }
            self.wallImageView.isHidden = !podcast.isNeedVpn
            self.contentLB.text = podcast.podDes
        }
        
        if let string = generalQRCodeData() {
            if let image = EFQRCode.generate(
                content: string,
                watermark: imageView.image!.cgImage
            ){
                qrCodeImage.image = UIImage(cgImage: image)
            }
        }
    }
    
    func generalQRCodeData() -> String? {
        var dic = [String: String]()
        dic["from"] = "funnyfm"
        if let episode = self.episode {
            dic["type"] = "episode"
            dic["title"] = episode.title
            dic["trackUrl"] = episode.trackUrl
            dic["podcast"] = episode.podcastUrl
        }
        
        if let podcast = self.podcast {
            dic["type"] = "podcast"
            dic["title"] = podcast.trackName
            dic["feedUrl"] = podcast.feedUrl
            dic["artwork"] = podcast.artworkUrl600
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions(rawValue: 0))
            let string = String(data: data, encoding: .utf8)
            return string
        }catch {
            return nil
        }
    }

}
