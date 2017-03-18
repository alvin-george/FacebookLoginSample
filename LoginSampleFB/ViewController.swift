//
//  ViewController.swift
//  LoginSampleFB
//
//  Created by Pushpam Group on 18/03/17.
//  Copyright © 2017 Pushpam Group. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet var loginStatusLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var passwordLabel: UILabel!
    
    @IBOutlet var profilePicture: FBSDKProfilePictureView?
    @IBOutlet var loginButton: FBSDKLoginButton?
    
    var fbDetails : NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton?.delegate =  self
        
        verifyInitialAccessToFacebook()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    func verifyInitialAccessToFacebook(){
        if FBSDKAccessToken.current() != nil {
            FBSDKLoginManager().logOut()
            return
        }
        
        let loginManager:FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFacebookUserData()
                        loginManager.logOut()
                    }
                }
            }
        }
    }
    
    func getFacebookUserData(){
        if((FBSDKAccessToken.current()) != nil){
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.fbDetails = result as? NSDictionary
                    print(self.fbDetails!)
                    self.usernameLabel.text = self.fbDetails?.object(forKey: "name") as! String?
                    self.passwordLabel.text = self.fbDetails?.object(forKey: "email") as! String?
                    
                }else{
                    print(error?.localizedDescription ?? "Not found")
                }
            })
        }
    }
    
    //FBSDKLoginButtonDelegate
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        self.loginStatusLabel.text =  "logged out"
        
    }
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        
        self.loginStatusLabel.text =  "logged in"
        return true
    }
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        getFacebookUserData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

