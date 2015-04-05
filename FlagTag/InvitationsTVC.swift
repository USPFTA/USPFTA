//
//  InvitationsTVC.swift
//  FlagTag
//
//  Created by Mollie on 4/5/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit

class InvitationsTVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Invitations"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "createGame")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    
        User.currentUser().getInvitations(User.currentUser().id)
        
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if User.currentUser().invitations[0].isEmpty {
            // this fixes the bug where when the API call returns "<null>", the array has a length of 1
            return 0
        } else {
            return User.currentUser().invitations.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell

        let invitation = User.currentUser().invitations[indexPath.row] as [String:AnyObject]
        
        if let inviterID = invitation["inviter_id"] as? Int {
        
            cell.textLabel?.text = String(inviterID)
            
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        acceptInvitationAlert(User.currentUser().invitations[indexPath.row])
        
    }
    
    // MARK: Alerts
    func acceptInvitationAlert(invitation: [String:AnyObject]) {
        
        let alertController = UIAlertController(title: "New Game", message: "Would you like to accept?", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "No", style: .Cancel) { (action) in
            
            // Rails: cancel invitation
            User.currentUser().declineInvitation(User.currentUser().id, invitation: invitation)
            
        }
        
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Yes", style: .Default) { (action) in
            
            // Rails: accept invitation
            User.currentUser().acceptInvitation(User.currentUser().id, invitation: invitation)
            
            // TODO: pass data on to VC
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let vc = storyboard.instantiateViewControllerWithIdentifier("dropFlagVC") as DropFlagVC
            
            self.presentViewController(vc, animated: true, completion: nil)
            
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */
    
    func createGame() {
        UIApplication.sharedApplication().openURL(NSURL(string:"https://github.com/USPFTA/")!)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
