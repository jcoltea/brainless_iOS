//
//  LoginViewController.swift
//  Brainless
//
//  Created by Julian Coltea on 5/2/15.
//  Copyright (c) 2015 JulianColtea. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var theEmailField: UITextField!
    @IBOutlet weak var thePasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        let myUserEmail = theEmailField.text;
        let myUserPassword = thePasswordField.text;
        
        
        let myUrl = NSURL(string: "http://67.175.161.233:8888/login");
        let request = NSMutableURLRequest(URL: myUrl!);
        request.HTTPMethod = "POST";
        let postString = "username=\(myUserEmail)&password=\(myUserPassword)";
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            (data, response, error) in
            
            if (error != nil)
            {
                println("error=\(error)");
                return;
            }

            let statusCode = response as! NSHTTPURLResponse;

            if (statusCode.statusCode == 200)
            {
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLoggedIn");
                self.dismissViewControllerAnimated(true, completion: nil);
            }
            else if (statusCode.statusCode == 401)
            {
                self.displayAsyncAlertMessage("Email or password do not match");
            }
        }
        
        task.resume();
    }

    func displayAsyncAlertMessage(aMessage: String)
    {
        dispatch_async(dispatch_get_main_queue(), {
            var myAlert = UIAlertController(title: "Alert", message: aMessage, preferredStyle: UIAlertControllerStyle.Alert);

            let myOkAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil);

            myAlert.addAction(myOkAction);

            self.presentViewController(myAlert, animated: true, completion: nil);
        })
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
