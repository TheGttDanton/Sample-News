//
//  ImageDownloader.swift
//  Sample News
//
//  Created by Emtiyaj Ali on 28/07/19.
//  Copyright © 2019 Emtiyaj Ali. All rights reserved.
//

import Foundation
import UIKit

class ImageDownloader {
    static let handler = ImageDownloader()
    private let cache = NSCache<NSString, AnyObject>()
    private var operationQueue = OperationQueue()
    
    
    func addTask(imageUrlString : String , completionHandler : @escaping (UIImage? , String) -> ()) {
        guard let imageUrl = URL(string: imageUrlString) else {
            return
        }
        
        if let image = cache.object(forKey: imageUrlString as NSString)  {
            completionHandler(image as? UIImage, imageUrlString)
            return
        }
        
        let operation =  operationQueue.operations.filter({ (operation) -> Bool in
            let imageOperation = operation as! ImageOperation
            if imageOperation.imageUrl == imageUrl {
                return true
            }
            return false
        }).first as? ImageOperation
        
        if operation == nil {
            let imageOperation = ImageOperation(imageUrl: imageUrl)
            imageOperation.downloadHandler = { (image, imageUrlString) in
                self.cache.setObject(image as! UIImage, forKey: imageUrlString as! NSString)
                completionHandler(image, imageUrlString)
            }
            operationQueue.addOperation(imageOperation)
        }
    }
    
}
