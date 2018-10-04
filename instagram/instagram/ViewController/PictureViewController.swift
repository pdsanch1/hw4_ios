//
//  PictureViewController.swift
//  instagram
//
//  Created by Pedro Daniel Sanchez on 10/2/18.
//  Copyright © 2018 Pedro Daniel Sanchez. All rights reserved.
//

import UIKit
import Parse




class PictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    @IBOutlet weak var captionTextView: UITextView!
    
    @IBAction func onCancel(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeFeedNavController") as! UINavigationController
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func onShare(_ sender: Any) {
        
         Photo.postUserImage(image: photoImageView.image, withCaption: captionTextView.text, withCompletion: nil)
        
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeFeedNavController") as! UINavigationController
        self.present(nextViewController, animated: false, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        photoImageView.isUserInteractionEnabled = true
        photoImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true) {
            // after it is completed
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:  [UIImagePickerController.InfoKey : Any]) {
        // Get the image captured by the UIImagePickerController
        //print("************   I M A G E   P I C K ....")
        if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
        
        // Do something with the images (based on your use case)
            
            photoImageView.image = originalImage
            
        }
        // Dismiss UIImagePickerController to go back to your original view controller

        dismiss(animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
