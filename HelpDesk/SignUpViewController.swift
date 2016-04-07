//
//  SignUpViewController.swift
//  HelpDesk
//
//  Created by Michael Madans on 3/31/16.
//  Copyright © 2016 TeamHelpDesk. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate,  UINavigationControllerDelegate {

    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var confirmPassField: UITextField!
    @IBOutlet weak var profilePic: UIImageView!
    
    let vc = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        // Do any additional setup after loading the view.
        
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
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
    
    @IBAction func onSelect(sender: AnyObject) {
        self.presentViewController(vc, animated: true, completion: nil)
    }

    @IBAction func onSubmit(sender: AnyObject) {
        if(passField.text == confirmPassField.text){
            let newUser = PFUser()
            newUser.username = userField.text
            newUser.password = passField.text
            newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                if success {
                    let profUpload = self.getPFFileFromImage(self.profilePic.image)
                    newUser.addObject(profUpload!, forKey: "profPicture")
                    newUser.saveInBackground()
                } else {
                    print(error?.localizedDescription)
                    if error?.code == 202{
                        print("Username is Taken")
                    }
                }
            }
            let nextScreen = storyboard!.instantiateViewControllerWithIdentifier("login") as? LoginViewController
            self.presentViewController(nextScreen!, animated: true, completion: nil)
        } else {
            print("passwords did not match")
        }
        
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
