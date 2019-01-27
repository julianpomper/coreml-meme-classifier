//
//  ViewController.swift
//  CoreML
//
//  Created by Julian Pomper on 05.06.18.
//  Copyright © 2018 Julian Pomper. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var resultLabel: UILabel!
    //dsd
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            
            guard let ciImage = CIImage(image: image) else {fatalError("Convert Erre")}
            detect(image: ciImage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage) {
        if let model = try? VNCoreMLModel(for: MemeModel().model) {
            
            let request = VNCoreMLRequest(model: model) { (request, error) in
                guard let results = request.results as? [VNClassificationObservation] else {fatalError("result error")}
            print(results)
                if let firstResult = results.first {
           
                        self.resultLabel.text = "\(firstResult.identifier) (\((Int(firstResult.confidence*100)))%)"
                }
            }
            
            let handler = VNImageRequestHandler(ciImage: image, options: [:])
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
        
    }
}

