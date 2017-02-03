//
//  VideoDataManager.swift
//  Inglish
//
//  Created by Funde, Rohit on 1/22/17.
//  Copyright © 2017 Funde, Rohit. All rights reserved.
//

import Foundation
import Alamofire

class VideoDataManager {
    
    static var videoDetails = [VideoDetail]()                                                   // Store video Details
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let logger = appDelegate.logger
    
    static func getDataFromServer(from: Int, to: Int, completion: @escaping () -> () = {}) {
        let parameters = "?from=" + String(from) + "&to=" + String(to)
        Alamofire.request(Constants.VIDEO_DATA_API + parameters).responseJSON {
            response in
            logger.info(response.request)  // original URL request
            logger.info(response.response) // HTTP URL response
            logger.info(response.data)     // server data
            logger.info(response.result)   // result of response serialization
            logger.info(response.request)
            
            if let videoJSON = response.result.value {
                if let videoData = videoJSON as? [[String: String]] {
//                    var lastVideo = 0
                    for video in videoData {
                        let videoId = video["videoId"]! as String
                        let title = video["title"]! as String
                        let imageUrl = video["imageUrl"]! as String
                        let durationString = video["duration"]! as String
                        let duration = durationString.replacingOccurrences(of: "M", with: ":")
                        let videoDetail = VideoDetail(videoId: videoId, title: title, imageUrl: imageUrl, duration: duration)
                        videoDetails.append(videoDetail)
                    }
                }
            }
            completion()
        }
    }
}
