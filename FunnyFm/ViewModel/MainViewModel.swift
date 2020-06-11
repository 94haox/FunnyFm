//
//  MainViewModel.swift
//  FunnyFm
//
//  Created by Duke on 2018/11/9.
//  Copyright © 2018 Duke. All rights reserved.
//

import UIKit


protocol MainViewModelDelegate: ViewModelDelegate {
	func viewModelDidGetChapterlistSuccess()
	func viewModelDidGetAdlistSuccess()
	func toPodcastDetail(podcast: iTunsPod)
	func toEpisodeDetail(episode: Episode)
}

struct MainSection: Hashable {
	
	var date: String
	
	
	func hash(into hasher: inout Hasher) {
	   hasher.combine(date)
	}

}

class MainViewModel: NSObject {	
	
	var dataSource: UITableViewDiffableDataSource<MainSection, Episode>!
	
    weak var delegate : MainViewModelDelegate?
	
	var episodeList = [[Episode]]()
	
	func getAd(vc: UIViewController){
//		let options = GADMultipleAdsAdLoaderOptions()
//		options.numberOfAds = 5
//		let adLoader = GADAdLoader(adUnitID: "ca-app-pub-9733320345962237/5831665620",
//							   rootViewController: vc,
//							   adTypes: [.unifiedNative],
//							   options: [options])
//		adLoader.delegate = self
//		adLoader.load(GADRequest())
	}
    
    func refresh() {
        FeedManager.shared.getAllPods()
    }
	
	func refreshWithNoNetwork(){
//		self.podlist = DatabaseManager.allItunsPod()
//		self.episodeList = self.sortEpisodeToGroup(DatabaseManager.allEpisodes())
	}
    
	func getDatasource(tableView: UITableView) {
		self.dataSource = UITableViewDiffableDataSource(tableView: tableView) { (tableView, indexPath, episode) -> UITableViewCell? in
//			let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EpisodeCardTableViewCell
			let cell = tableView.dequeueReusableCell(withIdentifier: "normal", for: indexPath) as! HomeAlbumTableViewCell
			cell.configHomeCell(episode)
			cell.tapLogoClosure = { [weak self] in
				guard let pod = DatabaseManager.getPodcast(feedUrl: episode.podcastUrl) else {
					return
				}
				self?.delegate?.toPodcastDetail(podcast: pod)
			}
			cell.tapClosure = {
				self.delegate?.toEpisodeDetail(episode: episode)
			}

            return cell
        }
		self.dataSource.defaultRowAnimation = .none
		tableView.dataSource = self.dataSource
		let list = FeedManager.shared.sortEpisodeToGroup(DatabaseManager.allEpisodes())
		self.updateData(list)
	}
	
	func updateData(_ list: [[Episode]]) {
		self.episodeList = list
		var snapshot = NSDiffableDataSourceSnapshot<MainSection, Episode>()
		for episodes in list {
			let episode = episodes.first!
			let section = MainSection(date: episode.pubDate)
			snapshot.appendSections([section])
			snapshot.appendItems(episodes, toSection: section)
		}
		self.dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
	
}



