//
//  YTDPlayerControls.swift
//  YTDraggablePlayer
//
//  Created by Ana Paula on 5/31/16.
//  Copyright © 2016 Ana Paula. All rights reserved.
//

import UIKit
import AVFoundation.AVPlayer
import youtube_ios_player_helper

extension YTFViewController {
    
    @IBAction func playTouched(sender: AnyObject) {
        
        videoView.playerState()
        
        if (videoView.playerState() == YTPlayerState.playing) {
            play.setImage(UIImage(named: "pause"), for: UIControlState.normal)
            videoView.pauseVideo()
        } else {
            play.setImage(UIImage(named: "play"), for: UIControlState.normal)
            videoView.playVideo()
        }
    }
    
    @IBAction func fullScreenTouched(sender: AnyObject) {
        if (!isFullscreen) {
            setPlayerToFullscreen()
        } else {
            setPlayerToNormalScreen()
        }
    }
    
    @IBAction func touchDragInsideSlider(sender: AnyObject) {
        dragginSlider = true
    }
    
    
    @IBAction func valueChangedSlider(sender: AnyObject) {
        
        
        
        print("CURRENT", videoView.currentTime())
        print("SLIDE", slider.value)
    }
    
    @IBAction func touchUpInsideSlider(sender: AnyObject) {
        dragginSlider = false
    }
}
