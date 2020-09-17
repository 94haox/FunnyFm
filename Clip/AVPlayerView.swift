//
//  AVPlayerView.swift
//  Clip
//
//  Created by 吴涛 on 2020/8/26.
//  Copyright © 2020 Duke. All rights reserved.
//

import Foundation
import SwiftUI
import AVFoundation
import AVKit
import StoreKit

//struct AVPlayerView: UIViewRepresentable {
//
//    typealias UIViewType = UIView
//
//    @Binding var videoURL: URL?
//
//    @Binding var height: CGFloat?
//
//    @Binding var width: CGFloat?
//
//    private var player: AVPlayer {
//        return AVPlayer(url: videoURL!)
//    }
//
//    private var view: UIView {
//        UIView.init(frame: CGRect.init(x: 0, y: 0, width: width!, height: height!))
//    }
//
//    func makeUIView(context: Context) -> UIView {
//        self.view
//    }
//
//    func updateUIView(_ uiView: UIView, context: Context) {
//        let avplayerlayer = AVPlayerLayer.init(player: self.player)
//        avplayerlayer.videoGravity = .resizeAspect
//        avplayerlayer.frame = self.view.bounds
//        self.view.layer.addSublayer(avplayerlayer)
//        self.player.play()
//    }
//}

struct AVPlayerView: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = AVPlayerViewController

    @Binding var videoURL: URL?
    @Binding var height: CGFloat?
    @Binding var width: CGFloat?

    private var player: AVPlayer {
        return AVPlayer(url: videoURL!)
    }

    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
//        playerController.modalPresentationStyle = .overCurrentContext
        playerController.showsPlaybackControls = false
        playerController.videoGravity = .resizeAspect
        playerController.view.frame = CGRect.init(x: 0, y: 0, width: width!, height: height!)
        playerController.view.backgroundColor = .clear
        playerController.player = player
        playerController.player?.play()
    }

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        return AVPlayerViewController()
    }
}


struct SKOverlayViewSingle: UIViewRepresentable {

    typealias UIViewType = UIView
    
    func present() {
        let overlay = SKOverlay(configuration: SKOverlay.AppClipConfiguration(position: .bottom))
        for scene in UIApplication.shared.connectedScenes {
            if scene is UIWindowScene {
                overlay.present(in: scene as! UIWindowScene)
            }
        }
    }
    
    func makeUIView(context: Context) -> UIView {
        return UIView()
    }
    

    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}


struct SKOverlayView: UIViewControllerRepresentable {
    
    private var productVC: SKStoreProductViewController = SKStoreProductViewController()
    
    static func dismantleUIViewController(_ uiViewController: SKStoreProductViewController, coordinator: ()) {
        uiViewController.dismiss(animated: true, completion: nil)
    }
    
    func makeUIViewController(context: Context) -> SKStoreProductViewController {
        productVC.modalPresentationStyle = .overFullScreen
        productVC.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier: "1447922692"]) { (_, error) in
            
        }
        return productVC
    }
    
    func updateUIViewController(_ uiViewController: SKStoreProductViewController, context: Context) {
        
    }
    
    typealias UIViewControllerType = SKStoreProductViewController
    
    
    
}

