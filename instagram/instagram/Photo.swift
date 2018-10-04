//
//  Photo.swift
//  instagram
//
//  Created by Pedro Daniel Sanchez on 10/2/18.
//  Copyright © 2018 Pedro Daniel Sanchez. All rights reserved.
//

import Foundation
import Parse

class Photo: PFObject, PFSubclassing {
    @NSManaged var media : PFFile
    @NSManaged var author: PFUser
    @NSManaged var caption: String
    @NSManaged var likesCount: Int
    @NSManaged var commentsCount: Int
    
    /* Needed to implement PFSubclassing interface */
    class func parseClassName() -> String {
        return "Photo"
    }
    
    class func postUserImage(image: UIImage?, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?) {
        // use subclass approach
        let photo = Photo()
        
        // Add relevant fields to the object
        
        photo.media = getPFFileFromImage(image: image)! // PFFile column type
        photo.author = PFUser.current()! // Pointer column type that points to PFUser
        photo.caption = caption! // Input by user
        photo.likesCount = 0
        photo.commentsCount = 0
        
        // Save object (following function will save the object in Parse asynchronously)
        photo.saveInBackground(block: completion)
    }
    
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        if let image = image {     // not nil
            //if let imageData = image.pngData() {      // not nil
            if let imageData = image.jpegData(compressionQuality: 50) {      // not nil
                return PFFile(name: "image.png", data: imageData)
            }
            
//            if let imageData = UIImagePNGRepresentation(image) {
//
//                return PFFile(name: "image.png", data: imageData)
//            }

        }
        print("******* <<<<<<< Unsopported bitmap format >>>>>>>>")
        return nil
    }
    
}

extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
