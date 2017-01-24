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
        self.videoId = videoId
        self.title = title
        self.imageUrl = imageUrl
        self.duration = duration
    }
}
