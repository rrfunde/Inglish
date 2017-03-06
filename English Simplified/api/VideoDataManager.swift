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
    static let utilityQueue = DispatchQueue.global(qos: .utility)
    static let AlamofireManager = Alamofire.SessionManager.default
    /// Fetch videos data from server
    static func getDataFromServer(from: Int, to: Int, completion: @escaping () -> () = {}) {
        
        let parameters = "?from=" + String(from) + "&to=" + String(to)
        AlamofireManager.request(APIConstants.VIDEO_DATA_API + parameters).responseJSON(queue: utilityQueue) {
            response in
            logger.info(response.request)  // original URL request
            logger.info(response.response) // HTTP URL response
            logger.info(response.data)     // server data
            logger.info(response.result)   // result of response serialization
            logger.info(response.request)
            
            switch response.result {
                case .success:
                    logger.debug(response.result)
                    if let videoJSON = response.result.value {
                        if let videoData = videoJSON as? [[String: String]] {
                        //                    var lastVideo = 0
                            for video in videoData {
                                let videoId = video["videoId"]! as String
                                let title = video["title"]! as String
                                let imageUrl = video["imageUrl"]! as String
                                let durationString = video["duration"]! as String                           // duration is in the format of 00M11 where 00 -> seconds and 11 -> minutes
                                let duration = durationString.replacingOccurrences(of: "M", with: ":")
                                let videoDetail = VideoDetail(id: videoId, title: title, imageUrl: imageUrl, duration: duration)
                                videoDetails.append(videoDetail)
                            }
                            VideoDataController.storeVideos(videos: videoDetails)
                        }
                    }
                case .failure(let error):
                    if error._code == NSURLErrorTimedOut {
                        logger.error(ErrorCodes.TIMEOUT_ERROR)
                    } else {
                        logger.error(error)
                    }
                }
            defer {
                completion()
            }
        }
    }
}
