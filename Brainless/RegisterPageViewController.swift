//
//  RegisterPageViewController.swift
//  Brainless
//
//  Created by Julian Coltea on 5/2/15.
//  Copyright (c) 2015 JulianColtea. All rights reserved.
//

import UIKit

class RegisterPageViewController: UIViewController {

    @IBOutlet weak var userEmailText: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButtonTapped(sender: AnyObject) {
        let myUserEmail = userEmailText.text;
        let myUserPassword = userPasswordTextField.text;
        let myRepeatPasswordTextField = repeatPasswordTextField.text;
        
        //Check for empty fields
        if (myUserEmail.isEmpty || myUserPassword.isEmpty || myRepeatPasswordTextField.isEmpty)
        {
            //Display alert message
            displayMyAlertMessage("All fields are required");
            return;
        }
        //Make sure both passwords match
        if (myUserPassword != myRepeatPasswordTextField)
        {
            //Display alert message
            displayMyAlertMessage("Passwords do not match");
            return;
        }
        
        let myUrl = NSURL(string: "http://67.175.161.233:8888/register");
        let request = NSMutableURLRequest(URL: myUrl!);
        request.HTTPMethod = "POST";
        let postString = "username=\(myUserEmail)&password=\(myUserPassword)";
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            
            if (error != nil)
            {
                println("error=\(error)");
                    return;
            }
            
            let statusCode = response as! NSHTTPURLResponse;

            if (statusCode.statusCode == 200)
            {
                self.displayAsyncAlertMessageDismissViewController("Registration successful!");
            }
            else if (statusCode.statusCode == 401)
            {
                self.displayAsyncAlertMessage("There was an issue registering, please try again");
            }
            else if (statusCode.statusCode == 500)
            {
                self.displayAsyncAlertMessage("Username already exists, please try again");
            }
        }
        
        task.resume();
    }

    func displayAsyncAlertMessageDismissViewController(aMessage: String)
    {
        dispatch_async(dispatch_get_main_queue(), {
            var myAlert = UIAlertController(title: "Alert", message: aMessage, preferredStyle: UIAlertControllerStyle.Alert);

            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) {
                action in self.dismissViewControllerAnimated(true, completion: nil);
            }

            myAlert.addAction(okAction);
            self.presentViewController(myAlert, animated: true, completion: nil)
        })
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


    func displayMyAlertMessage(userMessage:String)
    {
        var myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert);
        
        let myOkAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil);
        
        myAlert.addAction(myOkAction);
        
        self.presentViewController(myAlert, animated: true, completion: nil);
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
