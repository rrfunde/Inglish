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


    static func retriveVideos() -> [VideoDetail]? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        var videos = [VideoDetail]()
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: GeneralConstants.Database.ENTITY_NAME)
        do {
            let videosData = try managedContext.fetch(fetchRequest)
            videosData.forEach { video in
                guard let title = video.value(forKey: "title") as? String,
                let id = video.value(forKey: "id") as? String,
                let duration = video.value(forKey: "duration") as? String,
                    let imageUrl = video.value(forKey: "imageUrl") as? String else {
                        return
                }
                videos.append(VideoDetail(videoId: id, title: title, imageUrl: imageUrl, duration: duration))
            }
        } catch let error as NSError {
            appDelegate.logger.error(error)
        }
        return videos
    }
    
    static func storeVideos(videos: [VideoDetail]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: GeneralConstants.Database.ENTITY_NAME, in: managedContext)!

        videos.forEach { video in
            let videoManagedObject = NSManagedObject(entity: entity,
                                                     insertInto: managedContext)
            videoManagedObject.setValue(video.title, forKey: "title")
            videoManagedObject.setValue(video.videoId, forKey: "id")
            videoManagedObject.setValue(video.duration, forKey: "duration")
            videoManagedObject.setValue(video.imageUrl, forKey: "imageUrl")
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        
    }
}
