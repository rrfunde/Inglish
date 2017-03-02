//
//  TableViewController.swift
//  English Simplified
//
//  Created by Funde, Rohit on 1/8/17.
//  Copyright © 2017 Funde, Rohit. All rights reserved.
//

import UIKit
import MobilePlayer

class AllVideosController: UITableViewController {
    
    var videos: [VideoDetail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if !(UserDefaults.standard.string(forKey: "firstOpen") != nil) {
        VideoDataManager.getDataFromServer(from: 0, to: 20,completion: {
            if let videosData = VideoDataController.retriveVideos() {
                UserDefaults.standard.set(true, forKey: "firstOpen")
                self.videos = videosData
                self.doTableRefresh()
            }
        })
        } else if let videosData = VideoDataController.retriveVideos() {
                videos = videosData
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
        
        let videoUrl = APIConstants.YOUTUBE_BASE_URL + videos[indexPath.row].videoId
        let videoTitle = videos[indexPath.row].title
        let playerVC = MobilePlayerViewController(contentURL: URL(string: videoUrl)!)
        playerVC.title = videoTitle
        playerVC.activityItems = [videoUrl] 
        
        present(playerVC, animated: true, completion: {})
    }
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let favourite = UITableViewRowAction(style:.normal,title: "Favourite"){
             action, index in
             print("favorite button tapped")
        }
        favourite.backgroundColor = UIColor.green
        
        let delete = UITableViewRowAction(style: .normal,title: "Delete"){
            action, index in
            print("favorite button tapped")
        }
        delete.backgroundColor = UIColor.red

        let watched = UITableViewRowAction(style: .normal,title: "Watched"){
            action, index in
            print("favorite button tapped")
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
