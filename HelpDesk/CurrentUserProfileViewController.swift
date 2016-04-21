//
//  CurrentUserProfileViewController.swift
//  HelpDesk
//
//  Created by Zach Glick on 4/6/16.
//  Copyright © 2016 TeamHelpDesk. All rights reserved.
//

import UIKit
import Parse

class CurrentUserProfileViewController: UIViewController, UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    let vc = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        profilePic.layer.borderWidth = 1
        profilePic.layer.borderColor = UIColor.blueColor().CGColor
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true

        
        
        let user = HelpDeskUser.sharedInstance.user
        
        nameLabel.text = HelpDeskUser.sharedInstance.username
        let picObject = user!["profPicture"] as? [PFFile]
        
        if picObject != nil{
            //print("found pic object")
            if let picFile = picObject?[0] {
                picFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                    if (error == nil) {
                        self.profilePic.image = UIImage(data:imageData!)
                    }
                    else {
                        print("Error Fetching Profile Pic")
                    }
                }
            }
        }
            
        else{
            print("No Profile Picture Found")
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let originalImage = info[UIImagePickerControllerEditedImage] as! UIImage
        self.profilePic.image = originalImage
        dismissViewControllerAnimated(true, completion: nil)
        let profUpload = self.getPFFileFromImage(self.profilePic.image)
        var profileArray = [PFFile]()
        profileArray.append(profUpload!)
        PFUser.currentUser()!["profPicture"] = profileArray
        PFUser.currentUser()?.saveInBackgroundWithBlock({ (result : Bool, error : NSError?) in
            if !result {
                print ("DID NOT SAVE PIC: \(error!.description)")
            }
        })
    }
    
    func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                print("made PFFile")
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
    
    
    @IBAction func onSelect(sender: AnyObject) {
        
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    

    @IBAction func onLogout(sender: AnyObject) {
        HelpDeskUser.sharedInstance.logout()
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