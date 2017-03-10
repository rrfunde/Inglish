//
//  VideoDetails.swift
//  English Simplified
//
//  Created by Funde, Rohit on 1/22/17.
//  Copyright © 2017 Funde, Rohit. All rights reserved.
//

import Foundation
import CoreData

class VideoDetail {
    
//     MARK: members
    var id: String
    var title: String
    var imageUrl: String
    var duration: String
    var isWatched: Bool
    var isFavourite: Bool
    var managedObjectID: NSManagedObjectID
    
//    MARK: Attributes
    init(id: String, title: String, imageUrl: String, duration: String, isWatched: Bool = false, isFavourite: Bool = false, managedObjectID: NSManagedObjectID = NSManagedObjectID()) {
        var seconds: String
        var minutes: String
        
        self.id = id
        self.title = title
        self.imageUrl = imageUrl
        self.isWatched = isWatched
        self.isFavourite = isFavourite
        self.managedObjectID = managedObjectID
        
        var time = duration.characters.split(separator: ":").map(String.init)
        seconds = time[1].characters.count > 1 ? time[1] : "0" + time[1]
        minutes = time[0].characters.count > 1 ? time[0] : "0" + time[0]
        self.duration = minutes + ":"
        self.duration.append(seconds)
    }
}
