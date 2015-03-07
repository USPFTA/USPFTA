

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var logInButton: CustomButton!
    @IBOutlet weak var signUpButton: CustomButton!
    @IBOutlet weak var displayLogInLink: UIButton!
    @IBOutlet weak var usernameLine: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet var logo: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logInButton.hidden = true
        
        
        
        
        
    }
    
    @IBAction func signUpUser(sender: AnyObject) {
        
        
        var fieldValues: [String] = [emailTextField.text, passwordTextField.text, usernameTextField.text]
        
        // check if all fields are filled in
        if find(fieldValues, "") != nil {
            
            // all fields are not filled in, present error
            var alertViewController = UIAlertController(title: "Sign Up Error", message: "Please fill in all fields.", preferredStyle: UIAlertControllerStyle.Alert)
            
            var defaultAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            
            alertViewController.addAction(defaultAction)
            
            presentViewController(alertViewController, animated: true, completion: nil)
            
        } else {
            
            // all fields are filled in, sign up user (DO WE NEED TO CHECK FOR EXISTING USER? / HOW DO WE HANDLE ERRORS?)
            println("Sign up btn pressed, getting user token...")
            
//            User.currentUser().getUserToken(fieldValues[2], andEmail: fieldValues[0], andPassword: fieldValues[1], andCompletion: { () -> () in
//                
//                // dismiss view controller when finished
//                self.dismissViewControllerAnimated(true, completion: nil)
//                
//            })
            
            
        }
        
    }
    
    var logInHidden: Bool = true
    @IBAction func displayLogIn(sender: AnyObject) {
        // hide the username textfield, hide sign up, unhide log in, move items up
        
        // toggle
        if logInHidden {
            // Show log in fields and button
            logInHidden = false
            
            usernameTextField.hidden = true
            usernameLine.hidden = true
            usernameLabel.hidden = true
            signUpButton.hidden = true
            logInButton.hidden = false
            
            displayLogInLink.setTitle("or, Sign Up", forState: .Normal)
            
        } else {
            // Show Sign up fields and button
            logInHidden = true
            
            usernameTextField.hidden = false
            usernameLine.hidden = false
            usernameLabel.hidden = false
            signUpButton.hidden = false
            logInButton.hidden = true
            
            displayLogInLink.setTitle("or, Log In", forState: .Normal)
            
        }
        
    }
    
    @IBAction func logInUser(sender: AnyObject) {
        // log in user
        
        
        //        User.currentUser().logInUser(emailTextField.text, andPassword: passwordTextField.text)
        
        
        
        var fieldValues: [String] = [emailTextField.text, passwordTextField.text]
        
        // check if all fields are filled in
        if find(fieldValues, "") != nil {
            
            // all fields are not filled in, present error
            var alertViewController = UIAlertController(title: "Log In Error", message: "Please fill in all fields.", preferredStyle: UIAlertControllerStyle.Alert)
            
            var defaultAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            
            alertViewController.addAction(defaultAction)
            
            presentViewController(alertViewController, animated: true, completion: nil)
            
        } else {
            
            // all fields are filled in, sign up user (DO WE NEED TO CHECK FOR EXISTING USER?)
            println("Login btn pressed, attempting to login user...")
            //            User.currentUser().logInUser(fieldValues[0], andPassword: fieldValues[1])
            
//            User.currentUser().logInUser(fieldValues[0], andPassword: fieldValues[1], andCompletion: { () -> () in
//                
//                // dismiss view controller when finished
//                self.dismissViewControllerAnimated(true, completion: nil)
//                
//            })
            
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
    
}