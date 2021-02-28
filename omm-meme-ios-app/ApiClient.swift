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
    public static func upload(image: UIImage, completion: @escaping (NSDictionary?) -> Void) {
        let imageData = image.jpegData(compressionQuality: 1.0)
        
        AF.upload(
            multipartFormData: { multipartFormData in multipartFormData.append(imageData!, withName: "template", fileName: "image-from-iphone.jpeg", mimeType: "image/jpg")}, to: "http://localhost:8000/api/v1/template",
            method: .post
        ) .responseJSON { response in
            switch response.result {
                    case .success(let value):
                        print("Alamo value: \(value)")
                        print(type(of: value));
                        completion(value as? NSDictionary)
                        break
                    case .failure(let error):
                        print("Alamo error: \(error)")
                        break
                    }
        }
    }
    
    public static func create(url: String, topText: String, bottomText: String, name: String, completion: @escaping (NSDictionary?) -> Void) {
        let params = [
            "url": url,
            "top": topText,
            "bottom": bottomText,
            "name": name
        ]
        print(params)
        
        AF.request("http://localhost:8000/api/v1/meme/simple", method: .post, parameters: params, encoding: JSONEncoding.default) .responseJSON { response in
            switch response.result {
                    case .success(let value):
                        print("Alamo value: \(value)")
                        completion(value as? NSDictionary)
                        break
                    case .failure(let error):
                        print("Alamo error: \(error)")
                        break
                    }
        }
    }
}
