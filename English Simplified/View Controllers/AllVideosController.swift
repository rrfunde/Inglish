//
//  TableViewController.swift
//  English Simplified
//
//  Created by Funde, Rohit on 1/8/17.
//  Copyright © 2017 Funde, Rohit. All rights reserved.
//

import UIKit
import MobilePlayer

enum videoType: Int16 {
    case All = 0
    case Favourite
    case Watched
}
class AllVideosController: UITableViewController {

//  MARK: Members
    var allVideos = [VideoDetail]()
    var favouriteVideos = [VideoDetail]()
    var watchedVideos = [VideoDetail]()
    var filterVideoBy = videoType.All.rawValue
    var videos = [VideoDetail]()
//  MARK: Actions
    @IBAction func videoFilterChanged(_ sender: Any) {
        if let segmentControl = sender as? UISegmentedControl {
            let index = segmentControl.selectedSegmentIndex
            switch Int16(index) {
            case 0:
                videos = allVideos
            case 1:
                videos = favouriteVideos
            case 2:
                videos = watchedVideos
            default:
                ()
            }
            self.doTableRefresh()
        }
    }
    
//  MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if !(UserDefaults.standard.string(forKey: "firstOpen") != nil) {
        VideoDataManager.getDataFromServer(from: 0, to: 20,completion: {
            if let videosData = VideoDataController.retriveVideos() {
                UserDefaults.standard.set(true, forKey: "firstOpen")
                self.allVideos = videosData
                self.favouriteVideos = videosData.filter {
                    ($0 as VideoDetail).type == videoType.Favourite.rawValue
                }
                self.watchedVideos = videosData.filter {
                    ($0 as VideoDetail).type == videoType.Watched.rawValue
                }
                self.videos = self.allVideos
                
                self.doTableRefresh()
            }
        })
        } else if let videosData = VideoDataController.retriveVideos() {
                allVideos = videosData
                self.favouriteVideos = videosData.filter {
                ($0 as VideoDetail).type == videoType.Favourite.rawValue
            }
                self.watchedVideos = videosData.filter {
                ($0 as VideoDetail).type == videoType.Watched.rawValue
            }
            self.videos = allVideos
                self.doTableRefresh()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as! VideoCell
        
        let videoImageUrl = videos[indexPath.row].imageUrl

        let videoDuration = videos[indexPath.row].duration
//        cell.videoTitle.text = VideoDataManager.videoDetails[indexPath.row].title
        cell.videoImage.downloadAndSetImage(link: videoImageUrl)
        cell.videoDuration.text = videoDuration
        
//        cell.videoImage.addShadowEffect()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let videoUrl = APIConstants.YOUTUBE_BASE_URL + videos[indexPath.row].id
        let videoTitle = videos[indexPath.row].title
        let playerVC = MobilePlayerViewController(contentURL: URL(string: videoUrl)!)
        playerVC.title = videoTitle
        playerVC.activityItems = [videoUrl] 
        
        present(playerVC, animated: true, completion: {})
    }
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let favourite = UITableViewRowAction(style:.normal,title: "Favourite"){
             action, index in
             self.videos[index.row].type = 1
             VideoDataController.storeVideos(videos: [self.videos[index.row]])
        }
        favourite.backgroundColor = UIColor.green
        
        let delete = UITableViewRowAction(style: .normal,title: "Delete"){
            action, index in
            print("favorite button tapped")
        }
        delete.backgroundColor = UIColor.red

        let watched = UITableViewRowAction(style: .normal,title: "Watched"){
            action, index in
            self.videos[index.row].type = 1
            VideoDataController.storeVideos(videos: [self.videos[index.row]])
        }
        watched.backgroundColor = UIColor.gray

        return [delete,favourite,watched]
    }
    
    func doTableRefresh()
    {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            return
        }
    }

}
