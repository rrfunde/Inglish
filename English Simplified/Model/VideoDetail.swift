//
//  VideoDetails.swift
//  English Simplified
//
//  Created by Funde, Rohit on 1/22/17.
//  Copyright © 2017 Funde, Rohit. All rights reserved.
//

import Foundation

class VideoDetail {
    var videoId: String
    var title: String
    var imageUrl: String
    var duration: String
    
    init(videoId: String, title: String, imageUrl: String, duration: String) {
        var seconds: String
        var minutes: String
        
        self.videoId = videoId
        self.title = title
        self.imageUrl = imageUrl

        var time = duration.characters.split(separator: ":").map(String.init)
        seconds = time[1].characters.count > 1 ? time[1] : "0" + time[1]
        minutes = time[0].characters.count > 1 ? time[0] : "0" + time[0]
        self.duration = minutes + ":"
        self.duration.append(seconds)
    }
}
