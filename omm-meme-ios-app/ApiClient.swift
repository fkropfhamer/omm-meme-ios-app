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
        let imageData = image.pngData()
        
        AF.upload(
            multipartFormData: { multipartFormData in multipartFormData.append(imageData!, withName: "template", fileName: "file.png", mimeType: "image/png")}, to: "http://localhost:8000/api/v1/template",
            method: .post
        ) .responseJSON { res in
            print(res)
        }
    }
}
