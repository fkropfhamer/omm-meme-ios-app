//
//  ApiClient.swift
//  omm-meme-ios-app
//
//  Created by Fabian Kropfhamer on 27.01.21.
//

import Foundation
import UIKit
import Alamofire

class ApiClient {
    public static func upload(image: UIImage) {
        let imageData = image.jpegData(compressionQuality: 1.0)
        
        AF.upload(
            multipartFormData: { multipartFormData in multipartFormData.append(imageData!, withName: "template", fileName: "image-from-iphone.jpeg", mimeType: "image/jpg")}, to: "http://localhost:8000/api/v1/template",
            method: .post
        ) .responseJSON { res in
            print(res)
        }
    }
}
