//
//  Person.swift
//  MissingPersons
//
//  Created by Mohammad Hemani on 3/5/17.
//  Copyright © 2017 Mohammad Hemani. All rights reserved.
//

import UIKit
import ProjectOxfordFace

class Person {
    
    var faceID: String?
    var personImage: UIImage?
    var personImageURL: String?
    
    init(personImageURL: String) {
        self.personImageURL = personImageURL
    }
    
    func downloadFaceID() {
        
        if let img = personImage, let imgData = UIImageJPEGRepresentation(img, 0.8) {
            
            FaceService.instance.client?.detect(with: imgData, returnFaceId: true, returnFaceLandmarks: false, returnFaceAttributes: nil, completionBlock: { (faces: [MPOFace]?, error: Error?) in
                
                if error == nil {
                    
                    var faceID: String?
                    for face in faces! {
                        faceID = face.faceId
                        print("Face ID: \(faceID)")
                        break
                    }
                    
                    self.faceID = faceID
                    
                }
                
            })
            
        }
        
    }
}
