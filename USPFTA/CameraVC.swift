//
//  NewSeatVC.swift
//  Sit Fit
//
//  Created by Mollie on 2/3/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit

class CameraVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // TODO: var seats: [PFObject]?
    
    @IBOutlet weak var flagNameField: UITextField!
    @IBOutlet weak var flagImageView: UIImageView!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        flagNameField.delegate = self
        
    }
    
    
    
    @IBAction func takePhoto(sender: AnyObject) {
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        var image = info[UIImagePickerControllerOriginalImage] as UIImage
        self.flagImageView.image = image
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    @IBAction func cancelFlag(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func resizeImage(image: UIImage, withSize size: CGSize) -> UIImage {
        
        // make square
        
        //        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        UIGraphicsBeginImageContext(size)
        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
        
    }
    
    @IBAction func saveFlag(sender: AnyObject) {
        
        // FIXME: add from Rails
//        var newFlag = PFObject(className: "Flag")
//        newFlag["name"] = flagNameField.text
//        newFlag["player"] = PFUser.currentUser()
        
        let image = resizeImage(flagImageView.image!, withSize: CGSizeMake(540.0, 540.0))
        
        // FIXME: Send file to Rails
        // turn UIImage into PFFile and add to newSeat
//        let imageFile = PFFile(name: "flag.png", data: UIImagePNGRepresentation(image))
//        newFlag["image"] = imageFile
        
        //        if let venue = FeedData.mainData().selectedVenue {
        //
        //            newFlag["venue"] = venue
        //
        //        }
        
//        newFlag.saveInBackground()
//        
//        FeedData.mainData().feedItems.append(newFlag)
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}