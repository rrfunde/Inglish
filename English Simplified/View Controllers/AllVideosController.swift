//
//  TableViewController.swift
//  English Simplified
//
//  Created by Funde, Rohit on 1/8/17.
//  Copyright © 2017 Funde, Rohit. All rights reserved.
//

import UIKit
import YouTubeFloatingPlayer

class AllVideosController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        VideoDataManager.getDataFromServer(from: 0, to: 20,completion: {
            self.doTableRefresh()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let x = VideoDataManager.videoDetails.count
        return x
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as! VideoCell
        
        let videoImageUrl = VideoDataManager.videoDetails[indexPath.row].imageUrl

        let videoDuration = VideoDataManager.videoDetails[indexPath.row].duration
        cell.videoTitle.text = VideoDataManager.videoDetails[indexPath.row].title
        cell.videoImage.downloadAndSetImage(link: videoImageUrl)
        cell.videoDuration.text = videoDuration
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let videoID = VideoDataManager.videoDetails[indexPath.row].videoId
        
        YTFPlayer.initYTF(videoID: videoID)
        YTFPlayer.showYTFView(viewController: self)
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
