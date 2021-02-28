//
//  UploadView.swift
//  omm-meme-ios-app
//
//  Created by Fabian Kropfhamer on 27.01.21.
//

import SwiftUI

enum Pages {
    case upload
    case create
    case show
}

struct UploadView: View {
    
    @State private var page = Pages.upload
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var isImagePickerDisplay = false
    @ObservedObject var model: UploadViewModel = UploadViewModel()
    @State private var topText: String = ""
    @State private var bottomText: String = ""
    @State private var name: String = ""
    @State private var url: String = ""
    @State private var data: Data?
    
    private func onUploadResponse(optionalJson: NSDictionary?) -> Void {
        if let json = optionalJson {
            print()
            if case let data as NSDictionary = json["data"] {
                if case let url as String = data["url"] {
                    self.url = url
                    let url = URL(string: url)
                    self.data = try? Data(contentsOf: url!)
                    self.page = Pages.create
                }
                
            }
        } else {
            print("something went wrong")
        }
    }
    
    private func onCreateResponse(optionalJson: NSDictionary?) -> Void {
        if let json = optionalJson {
            print()
            if case let data as NSDictionary = json["data"] {
                print(data)
                if case let url as String = data["url"] {
                    self.url = url
                    let url = URL(string: url)
                    self.data = try? Data(contentsOf: url!)
                    self.page = Pages.show
                }
                
            }
            
        } else {
            print("something went wrong")
        }
    }
    
    private func createAnother() -> Void {
        self.data = nil
        self.selectedImage = nil
        self.page = Pages.upload
    }
    
    var body: some View {
        NavigationView {
            switch self.page {
            case .upload:
            VStack {
                
                if selectedImage != nil {
                    Image(uiImage: selectedImage!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        //.clipShape(Circle())
                        .frame(width: 300, height: 300)
                } else {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        //.clipShape(Circle())
                        .frame(width: 300, height: 300)
                }
                
                Button("Camera") {
                    self.sourceType = .camera
                    self.isImagePickerDisplay.toggle()
                }.padding()
                
                Button("photo") {
                    self.sourceType = .photoLibrary
                    self.isImagePickerDisplay.toggle()
                }.padding()
                
                if selectedImage != nil {
                    Button(action: {ApiClient.upload(image: self.selectedImage!, completion: self.onUploadResponse(optionalJson:))}) {
                        Text("Upload")
                    }
                }
            }
            case .create:
                VStack {
                    TextField("Enter name for meme", text: $name)
                    TextField("Enter top text", text: $topText)
                    if self.data != nil {
                        Image(uiImage: UIImage(data: self.data!)!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            //.clipShape(Circle())
                            .frame(width: 300, height: 300)
                    }
                    TextField("Enter bottom text", text: $bottomText)
                    Button(action: {ApiClient.create(url: self.url, topText: self.topText, bottomText: self.bottomText, name: self.name, completion: self.onCreateResponse(optionalJson:))} ) {
                        Text("create")
                        //action: {ApiClient.create(url: $url, topText: $topText, bottomText: $bottomText, name: $name, completion: self.onCreateResponse(optionalJson:))}
                    }
                }
            case .show:
                VStack {
                    if self.data != nil {
                        Image(uiImage: UIImage(data: self.data!)!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            //.clipShape(Circle())
                            .frame(width: 300, height: 300)
                    }
                    Button(action: {self.createAnother()}) {
                        Text("Create another")
                    }
                }
            }
        }
            .navigationBarTitle("Demo")
            .sheet(isPresented: self.$isImagePickerDisplay) {
                ImagePickerView(selectedImage: self.$selectedImage, sourceType: self.sourceType)
            }
            
    }
}

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        UploadView()
    }
}
