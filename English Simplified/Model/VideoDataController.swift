//
//  VideoDataManager.swift
//  English Simplified
//
//  Created by Funde, Rohit on 2/18/17.
//  Copyright © 2017 Funde, Rohit. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class VideoDataController: NSObject {

//    MARK: static members
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let managedContext = appDelegate.persistentContainer.viewContext

    static func retriveVideos() -> [VideoDetail]? {

        var videos = [VideoDetail]()
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: GeneralConstants.Database.ENTITY_NAME)
        do {
            let videosData = try managedContext.fetch(fetchRequest)
            videosData.forEach { video in
                guard let title = video.value(forKey: "title") as? String,
                let id = video.value(forKey: "id") as? String,
                let duration = video.value(forKey: "duration") as? String,
                let imageUrl = video.value(forKey: "imageUrl") as? String,
                let isWatched = video.value(forKey: "isWatched") as? Bool,
                let isFavourite = video.value(forKey: "isFavourite") as? Bool else {
                        return
                }
                let objectID = video.objectID as NSManagedObjectID
                videos.append(VideoDetail(id: id, title: title, imageUrl: imageUrl, duration: duration, isWatched: isWatched, isFavourite: isFavourite, managedObjectID: objectID))
            }
        } catch let error as NSError {
            appDelegate.logger.error("failed to retrieve video data")
            appDelegate.logger.error(error)
        }
        return videos
    }
    
    static func storeVideos(videos: [VideoDetail], completion: () -> () = {}) {

        if let entity = NSEntityDescription.entity(forEntityName: GeneralConstants.Database.ENTITY_NAME, in: managedContext) {

            videos.forEach { video in
                let videoManagedObject = NSManagedObject(entity: entity,
                                                     insertInto: managedContext)
                videoManagedObject.setValue(video.title, forKey: "title")
                videoManagedObject.setValue(video.id, forKey: "id")
                videoManagedObject.setValue(video.duration, forKey: "duration")
                videoManagedObject.setValue(video.imageUrl, forKey: "imageUrl")
                videoManagedObject.setValue(video.isFavourite, forKey: "isFavourite")
                videoManagedObject.setValue(video.isWatched, forKey: "isWatched")
                do {
                    try managedContext.save()
                    completion()
                } catch let error as NSError {
                    VideoDataManager.logger.error("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }
    
    static func setVideoFavourite(id: NSManagedObjectID) {
            let videoData = managedContext.object(with: id)
            videoData.setValue(true, forKey: "isFavourite")
        }
    
    static func setVideoWatched(id: NSManagedObjectID) {
        let videoData = managedContext.object(with: id)
        videoData.setValue(true, forKey: "isWatched")
    }
    
    static func deleteVideo(id: NSManagedObjectID) {
        let videoData = managedContext.object(with: id)
        managedContext.delete(videoData)
    }
}
