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
    
    let vc = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
    
        let user = PFUser.currentUser() as! PFObject
        if let picFile = user["profPicture"] as? PFFile {
            picFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    self.profilePic.image = UIImage(data:imageData!)
                }
                else {
                    print("Error Fetching Profile Pic")
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
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        profilePic.image = originalImage
        dismissViewControllerAnimated(true, completion: nil)
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

    @IBAction func onSave(sender: AnyObject) {
        let user = PFUser.currentUser()! as PFObject
        let profUpload = self.getPFFileFromImage(self.profilePic.image)
        user.addObject(profUpload!, forKey: "profPicture")
        user.saveInBackground()
        
        
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
