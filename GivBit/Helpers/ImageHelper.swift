//
//  ImageHelper.swift
//  GivBit
//
//  Created by Tallal Javed on 5/16/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//
//  Provides utility functions for imageviews and images in general.. for the whole applicaiton.
//

import UIKit
import ChameleonFramework
import AVFoundation

class ImageHelper: NSObject {
    
    // dont make a seperate instance use this instead
    static var sharedInstance = ImageHelper()
    var player: AVPlayer?

    
    // This will add given text to the image in the center. Can also add a grey background to the text
    func generateImageWithCenteredText(textAtCenter text: String, inImage image: UIImage, addBackground: Bool) -> UIImage{
        
        // Setup the font specific variables
        let textColor = UIColor.white
        let textFont = UIFont(name: "Helvetica Bold", size: image.size.height/2)!
        
        // getting the center of the image to draw upon
        let pointToDrawOn: CGPoint = CGPoint(x: image.size.width/2 - text.width(withConstrainedHeight: textFont.pointSize, font: textFont)/2, y: image.size.height/2 - textFont.pointSize/2)
        
        // Setup the image context using the passed image
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        // Setup the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSAttributedStringKey.font: textFont,
            NSAttributedStringKey.foregroundColor: textColor,
            ]
        
        // Put the image into a rectangle as large as the original image
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        
        // Create a point within the space that is as bit as the image
        let rect = CGRect(x: pointToDrawOn.x, y: pointToDrawOn.y, width: image.size.width, height: image.size.height)
        //let rect = CGRect(x: pointToDrawOn.x, y: pointToDrawOn.y, width: image.size.width, height: image.size.height)
        
        // Draw the text into an image
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        // Create a new image out of the images we have created
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        //Pass the image back up to the caller
        return newImage!
    }
    
    
    func playBackgoundVideo(aView: UIView, videoName : String) {
        if let filePath = Bundle.main.path(forResource: videoName, ofType:"mp4") {
            let filePathUrl = NSURL.fileURL(withPath: filePath)
            player = AVPlayer(url: filePathUrl)
            //player.muted = mute;
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: .main) { _ in
                self.player?.seek(to: kCMTimeZero)
                self.player?.play()
            }
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = aView.bounds
            playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: nil) { (_) in
                self.player?.seek(to: kCMTimeZero)
                self.player?.play()
            }
            aView.layer.insertSublayer(playerLayer, at: 0)
            
            print("gonna try to play video:"+videoName)
            player?.play()
        }
    }
    
}

// MARK: - Extension
public extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

