//
//  CustomLogInViewController.swift
//  Colby Ice Cream
//
//  Created by Daniel Vogel on 4/28/15.
//  Copyright (c) 2015 Daniel Vogel. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4

class CustomLogInViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var LoginTitle: UILabel!
    
    
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0,150,150)) as UIActivityIndicatorView
    
    let colorGen = ColorGenerator()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.LoginTitle.setValue(UIFont(name: "Raleway-Light", size:30), forKey: "font")
        
        let sexyLayer:CAGradientLayer
        sexyLayer = colorGen.gradientGenerator("#5FA9FF", hexBottom: "#C29EFF")
        sexyLayer.frame = view.frame
        
        self.view.layer.insertSublayer(sexyLayer, atIndex: 0)
        
        self.actInd.center = self.view.center
        
        self.actInd.hidesWhenStopped = true
        
        self.actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        view.addSubview(self.actInd)
        
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            println("Not logged in")
        }
        else {
            println("Logged in!")
        }
        
        var loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.center = self.view.center
        loginButton.delegate = self
        self.view.addSubview(loginButton)
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if ((PFUser.currentUser()?.username) != nil) {
            self.performSegueWithIdentifier("loggedIn", sender: nil)
        }
        
        
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
    
    //Mark -- Actions
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        var username = self.usernameField.text.lowercaseString
        var password = self.passwordField.text
        
        if (count(username.utf16) < 4 || count(password.utf16) < 5) {
            var alert = UIAlertView(title: "Invalid", message: "Please enter valid username and password", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
        else {
            
            self.actInd.startAnimating()
            
            var permissions:NSArray = ["user_about_me"]
            
            PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions as [AnyObject], block: { (user: PFUser?, error: NSError?) -> Void in
                
                self.actInd.stopAnimating()
                
                if ((user) != nil){
                    var alert = UIAlertView(title: "Success", message: "Logged in", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                    self.performSegueWithIdentifier("loggedIn", sender: nil)
                } else if (user!.isNew) {
                    var alert = UIAlertView(title: "Success", message: "First log in!", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                    self.performSegueWithIdentifier("loggedIn", sender: nil)
                }
                else {
                    var alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                }
            
                
            })
            
        }
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("User logged out")
    }
    
    @IBAction func SignupAction(sender: AnyObject) {
        
        self.performSegueWithIdentifier("signUp", sender: self)
        
    }
    
    

}
