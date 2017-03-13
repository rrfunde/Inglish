//
//  TableViewController.swift
//  English Simplified
//
//  Created by Funde, Rohit on 1/8/17.
//  Copyright © 2017 Funde, Rohit. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import CWStatusBarNotification
import YouTubeFloatingPlayer
import SDWebImage

/**
 The purpose of the `VideosController` is to show english learning videos and allows them to set them favourite, Watched and user can delete the videos
 */
class VideosController: UITableViewController {
    
    // MARK: Constants
    
    class Constants {
    
        static let HEIGHT_FOR_VIDEO_CELL = CGFloat(208)
    }

    //  MARK: public Members
    
    var allVideos = [VideoDetail]()
    var favouriteVideos = [VideoDetail]()
    var watchedVideos = [VideoDetail]()
  
    //  MARK: private Members
    
    private var videos = [VideoDetail]()
    private var indicator = NVActivityIndicatorView(frame: CGRect(x: 0,y: 0,width: 40,height: 40), type: NVActivityIndicatorType.lineScale, color: UIColor.blue, padding: 0)
    private var bannerHandler = CWStatusBarNotification()

    //  MARK: Actions
    
    @IBAction func videoFilterChanged(_ sender: Any) {
        if let segmentControl = sender as? UISegmentedControl {
            let index = segmentControl.selectedSegmentIndex
            switch Int16(index) {
            case 0:
                videos = allVideos
            case 1:
                self.favouriteVideos = allVideos.filter {
                    ($0 as VideoDetail).isFavourite == true
                }
                videos = favouriteVideos
            case 2:
                self.watchedVideos = allVideos.filter {
                    ($0 as VideoDetail).isWatched == true
                }
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
        
        tableView.register(UINib(nibName: "VideoCell", bundle: Bundle.main), forCellReuseIdentifier: "videoCell")
        
        tableView.tableFooterView = UIView()
        configureBannerView()
        indicator.center = self.tableView.center
        self.view.addSubview(indicator)
        indicator.startAnimating()
        
        if (UserDefaults.standard.string(forKey: "firstOpen") == nil) {
            VideoDataManager.getDataFromServer(from: 0, to: 20,completion: {
                self.categarizedVideos()
                UserDefaults.standard.set(true, forKey: "firstOpen")
            })
        } else {
            categarizedVideos()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.HEIGHT_FOR_VIDEO_CELL
    }

    // MARK: - TableView Data Source

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
        cell.videoImage.sd_setShowActivityIndicatorView(true)
        cell.videoImage.sd_setIndicatorStyle(.gray)
        cell.videoImage.sd_setImage(with: URL(string: videoImageUrl))
        cell.videoDuration.text = videoDuration
        
//        cell.videoImage.addShadowEffect()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        YTFPlayer.initYTF(with: tableView, tableCellNibName: "VideoCell", tableCellReuseIdentifier: "videoCell", videoID: videos[indexPath.row].id)
        YTFPlayer.showYTFView(viewController: self)
    }
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let favourite = UITableViewRowAction(style:.normal,title: "Favourite"){
             action, index in
             let id = self.videos[index.row].managedObjectID
            self.allVideos.filter({ $0.managedObjectID == id}).first?.isFavourite = true
             VideoDataController.setVideoFavourite(id: id)
            self.bannerHandler.display(with: NSAttributedString(string: "added to favourite"), forDuration: 1)
             self.tableView.setEditing(false, animated: true)
        }
        favourite.backgroundColor = UIColor.green
        
        let delete = UITableViewRowAction(style: .normal,title: "Delete"){
            action, index in
            self.tableView.setEditing(false, animated: true)
            let id = self.videos[index.row].managedObjectID
            VideoDataController.deleteVideo(id: id)
            self.categarizedVideos()
            self.tableView.deleteRows(at: [index], with: .fade)
            self.bannerHandler.display(with: NSAttributedString(string: "deleted"), forDuration: 1)
        }
        delete.backgroundColor = UIColor.red

        let watched = UITableViewRowAction(style: .normal,title: "Watched"){
            action, index in
            let id = self.videos[index.row].managedObjectID
            self.allVideos.filter({$0.managedObjectID == id}).first?.isWatched = true
            VideoDataController.setVideoWatched(id: id)
            self.bannerHandler.display(with: NSAttributedString(string: "added to Watched"), forDuration: 1)
            self.tableView.setEditing(false, animated: true)
        }
        watched.backgroundColor = UIColor.gray

        return [delete,favourite,watched]
    }
    
    func doTableRefresh()
    {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.indicator.stopAnimating()
            return
        }
    }
    
    // this function creates 3 sets of videos ALL, Favourite and Watched and refresh table
    func categarizedVideos() {
        if let videosData = VideoDataController.retriveVideos() {
            VideoDataManager.logger.debug("retrived video data from local database")
            allVideos = videosData
            self.favouriteVideos = videosData.filter {
                ($0 as VideoDetail).isFavourite == true
            }
            self.watchedVideos = videosData.filter {
                ($0 as VideoDetail).isWatched == true
            }
            self.videos = allVideos
            self.doTableRefresh()
        }
    }
    
    func configureBannerView() {
        self.bannerHandler.notificationLabelBackgroundColor = UIColor.green
        self.bannerHandler.notificationLabelTextColor = UIColor.black
        self.bannerHandler.notificationAnimationInStyle = .top

//        self.bannerHandler.notificationLabelFont = UIFont(name: self.bannerHandler.notificationLabelFont.familyName, size: 20)
//        self.bannerHandler.notificationStyle = .navigationBarNotification
    }
}
