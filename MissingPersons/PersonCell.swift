//
//  PersonCell.swift
//  MissingPersons
//
//  Created by Mohammad Hemani on 3/5/17.
//  Copyright © 2017 Mohammad Hemani. All rights reserved.
//

import UIKit

class PersonCell: UICollectionViewCell {
    
    @IBOutlet weak var personImage: UIImageView!
    
    
    func configureCell(imgURL: String) {
        
        if let url = URL(string: imgURL) {
            downloadImage(url: url)
        }
    }
    
    func downloadImage (url: URL) {
        
        getDataFromURL(url: url) { (data, response, error) in
            
            DispatchQueue.main.async { () -> Void in
                guard let data = data , error == nil else { return }
                self.personImage.image = UIImage(data: data)
            }
        }
        
    }
    
    func getDataFromURL(url: URL, completion: @escaping ((_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void)) {
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            completion(data, response, error)
            
        }.resume()
        
    }
}
