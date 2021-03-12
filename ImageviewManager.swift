//
//  ImageviewManager.swift
//  tempi
//
//  Created by Rankit on 12/01/21.
//  Copyright © 2021 Rankit. All rights reserved.
//


////to use it in class(cell for row method)
//Assign ImageviewManager class to imageview in cell xib
//let imgUrl = URL(string: stringFromServer!)!
// cell.imgvw.loadImage(fromURL: imgurl, placeHolderImage: "tempImage.png")
//For client project use SDWebImage library

import Foundation
import UIKit

class ImageviewManager: UIImageView
{

    private let imageCache = NSCache<AnyObject, UIImage>()

    func loadImage(fromURL imageURL: URL, placeHolderImage: String)
    {
        //Pre deifne image
        self.image = UIImage(named: placeHolderImage)

        //If already found
        if let cachedImage = self.imageCache.object(forKey: imageURL as AnyObject)
        {
            debugPrint("image loaded url =\(imageURL)")
            self.image = cachedImage
            return
        }

        //Downloading background thread
        DispatchQueue.global().async {
            
            if let imageData = try? Data(contentsOf: imageURL)
            {
                debugPrint("image downloaded!")
                if let image = UIImage(data: imageData)
                {
                    DispatchQueue.main.async { //updating on main thread
                        self.imageCache.setObject(image, forKey: imageURL as AnyObject)
                        self.image = image
                    }
                }
            }
        }
    }
}
