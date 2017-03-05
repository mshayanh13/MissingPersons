//
//  FaceService.swift
//  MissingPersons
//
//  Created by Mohammad Hemani on 3/5/17.
//  Copyright © 2017 Mohammad Hemani. All rights reserved.
//

import Foundation
import ProjectOxfordFace

class FaceService {
    
    static let instance = FaceService()
    
    let client = MPOFaceServiceClient(subscriptionKey: "3745f977cfb24e9ea92af403fd3959ff")
}
