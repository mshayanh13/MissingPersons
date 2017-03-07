//
//  ViewController.swift
//  MissingPersons
//
//  Created by Mohammad Hemani on 3/4/17.
//  Copyright © 2017 Mohammad Hemani. All rights reserved.
//

import UIKit
import ProjectOxfordFace

let baseURL = "http://localhost:6069/img/"

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var photosButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    
    var selectedPerson: Person?
    var hasSelectedImage: Bool = false
    
    let imagePicker = UIImagePickerController()
    
    let missingPeople = [
        Person(personImageURL: "person1.jpg"),
        Person(personImageURL: "person2.jpg"),
        Person(personImageURL: "person3.jpg"),
        Person(personImageURL: "person4.jpg"),
        Person(personImageURL: "person5.jpg"),
        Person(personImageURL: "person6.png")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        imagePicker.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.loadCameraOrPhotos(gesture:)))
        tap.numberOfTapsRequired = 1
        selectedImage.addGestureRecognizer(tap)
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(title: "Select Person", message: "Please select a person to check and an image from your album", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func checkForMatch(_ sender: UIButton) {
        
        if selectedPerson == nil || !hasSelectedImage {
            
            showErrorAlert()
            
        } else {
            
            if let myImage = selectedImage.image, let imageData = UIImageJPEGRepresentation(myImage, 0.8) {
                
                FaceService.instance.client?.detect(with: imageData, returnFaceId: true, returnFaceLandmarks: false, returnFaceAttributes: nil, completionBlock: { (faces: [MPOFace]?, error: Error?) in
                    
                    if error == nil {
                        
                        var faceID: String?
                        for face in faces! {
                            
                            faceID = face.faceId
                            break
                        }
                        
                        if faceID != nil {
                            
                            FaceService.instance.client?.verify(withFirstFaceId: self.selectedPerson!.faceID, faceId2: faceID, completionBlock: { (result: MPOVerifyResult?, error: Error?) in
                                
                                
                                if error == nil {
                                    
                                    if let results = result, let confidence = results.confidence {
                                        
                                        if (results.isIdentical || Double(results.confidence) > 0.5) {
                                        
                                            let alert = UIAlertController(title: "Person matches", message: "Person matches with \(confidence)%", preferredStyle: .alert)
                                            let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                            alert.addAction(ok)
                                            self.present(alert, animated: true, completion: nil)
                                        } else {
                                            let alert = UIAlertController(title: "Person does not match", message: "Person matches with \(confidence)%", preferredStyle: .alert)
                                            let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                            alert.addAction(ok)
                                            self.present(alert, animated: true, completion: nil)
                                        }
                                        
                                    }
                                    
                                    /*print("\
                                        (result!.confidence)")
                                    print("\(result!.isIdentical)") */
                                } else {
                                    
                                    
                                    
                                }
                                
                            })
                            
                        }
                        
                    }
                    
                })
                
            }
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return missingPeople.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonCell", for: indexPath) as! PersonCell
        
        let person = missingPeople[indexPath.row]
        cell.configureCell(person: person)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        self.selectedPerson = missingPeople[indexPath.row]
        let cell = collectionView.cellForItem(at: indexPath)  as! PersonCell
        //deque(withReuseIdentifier: "PersonCell", for: indexPath) as! PersonCell
        //cell.configureCell(person: selectedPerson!)
        cell.setSelected()
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            selectedImage.image = pickedImage
            hasSelectedImage = true
            photosButton.isHidden = true
            cameraButton.isHidden = true
            
        }
        dismiss(animated: true, completion: nil)
    }

    func loadPicker(option: String) {
        
        imagePicker.allowsEditing = true
        
        if option == "Photos" {
            
            imagePicker.sourceType = .photoLibrary
            
        } else if option == "Camera" {
            
            imagePicker.sourceType = .camera
            
        }
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func loadCameraOrPhotos(gesture: UITapGestureRecognizer) {
        
        photosButton.isHidden = false
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraButton.isHidden = false
        }
    }
    
    @IBAction func photoSourceChosen(sender: UIButton) {
        
        if sender.tag == 0 {
            loadPicker(option: "Photos")
        } else {
            loadPicker(option: "Camera")
        }
        
    }
    
}

