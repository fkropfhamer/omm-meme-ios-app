//
//  ApiClient.swift
//  omm-meme-ios-app
//
//  Created by Fabian Kropfhamer on 27.01.21.
//

import Foundation
import UIKit

class ApiClient {
    public static func upload(image: UIImage) {
        print("upload")
        
        let urlPath = "http://localhost:8000/api/v1/template"
            guard let endpoint = URL(string: urlPath) else {
                    print("Error creating endpoint")
                    return
            }
        var request = URLRequest(url: endpoint)
        
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        //request.setValue("application/json", forHTTPHeaderField: "Accept")
        let mimeType = "image/png"
        
        let params: [String : String] = [
            "user_id" :"234",
            "session_id" :"H7BbJv7B9"
        ]
        
        var body = Data()
        let boundaryPrefix = " — \(boundary)\r\n"
        
        /*for (key, value) in params {
            body.append(Data(boundaryPrefix.utf8))
            body.append(Data("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8))
            body.append(Data("\(value)\r\n".utf8))
        }*/
        
       // let imageData = image.jpegData(compressionQuality: 0.5)
        let imageData = image.pngData()
        let filename = "image1.png"
        
        body.append(Data(boundaryPrefix.utf8))
        body.append(Data("Content-Disposition: form-data; name=\"template\"; filename=\"\(filename)\"\r\n".utf8))
        body.append(Data("Content-Type: \(mimeType)\r\n\r\n".utf8))
        body.append(imageData!)
        body.append(Data("\r\n".utf8))
        body.append(Data(" — ".appending(boundary.appending(" — ")).utf8))
        
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print(jsonString)
                }
                do {
                    //let res = try JSONDecoder().decode(Api.self, from: data)
                    
                    //print(res);
                    //print(res.status)
                } catch let error {
                    print(error)
                }
            }
            if let response = response {
                print(response)
            }
            
            if let error = error {
                print(error)
            }
        }.resume()
    }
    
    static func getBase64Image(image: UIImage, complete: @escaping (String?) -> ()) {
            DispatchQueue.main.async {
                let imageData = image.pngData()
                let base64Image = imageData?.base64EncodedString(options: .lineLength64Characters)
                complete(base64Image)
            }
        }
    
    public static func uploadImageToImgur(image: UIImage) {
        ApiClient.getBase64Image(image: image) { base64Image in
                let boundary = "Boundary-\(UUID().uuidString)"

                var request = URLRequest(url: URL(string: "http://localhost:8000/api/v1/template")!)
                
                request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.addValue("base64", forHTTPHeaderField: "Content-Transfer-Encoding")

                request.httpMethod = "POST"
                
                let mimeType = "image/png"
            
                var body = ""
                body += "--\(boundary)\r\n"
                body += "Content-Disposition:form-data; name=\"template\"; filename=\"test.png\""
                body += "\r\nContent-Type: \(mimeType)"
                body += "\r\nContent-Transfer-Encoding: base64"
                body += "\r\n\r\n\(base64Image ?? "")\r\n"
                body += "--\(boundary)--\r\n"
                let postData = body.data(using: .utf8)

                request.httpBody = postData
                
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let data = data {
                        if let jsonString = String(data: data, encoding: .utf8) {
                            print(jsonString)
                        }
                        do {
                            //let res = try JSONDecoder().decode(Api.self, from: data)
                            
                            //print(res);
                            //print(res.status)
                        } catch let error {
                            print(error)
                        }
                    }
                    if let response = response {
                        print(response)
                    }
                    
                    if let error = error {
                        print(error)
                    }
                }.resume()

                // ...
            }
        }
}
