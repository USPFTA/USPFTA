import UIKit

class ResultsVC: UIViewController, UITableViewDataSource, UITableViewDelegate,  APIControllerProtocol {
    
    let kCellIdentifier: String = "SearchResultCell"
    
    var api = APIController()
    
    @IBOutlet var resultsTableView : UITableView?
    
    var resultsData = []
    
    var timer:NSTimer? = nil;
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
//        startTimer()
        
        self.api.delegate = self
        
        
        // FIXME: add search from Rails
        api.obtainGameResults("")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        // FIXME: change this (and below) to a completion
        User.currentUser().getInvitations(User.currentUser().id)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        // FIXME: change this (and above) to a completion
        
        // FIXME: [invitations: <null>] still has a count > 0
        // once new game is returned, display alert that will lead to DropFlagVC
        if User.currentUser().invitations.count > 0 {
            
            displayNewGameAlert()
            
        }
        
    }
    
//    func startTimer() {
//        
//        timer = NSTimer.scheduledTimerWithTimeInterval(15,
//            target: self,
//            selector: "onTick:",
//            userInfo: nil,
//            repeats: false)
//        
//    }
//
//    func onTick(timer:NSTimer) {
//        
//        User.currentUser().getInvitations(User.currentUser().id)
//        if User.currentUser().invitations.count > 0 {
//            displayNewGameAlert()
//        }
//        
//    }
    
    func didReceiveAPIResults(results: NSDictionary) {
        // FIXME: change "results["results"]"
        var resultsArr: NSArray = results["results"] as NSArray
        dispatch_async(dispatch_get_main_queue(), {
            self.resultsData = resultsArr
            self.resultsTableView!.reloadData()
        })
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
        
        // FIXME: rename "rowData"
//        cell.textLabel.text = rowData[""] as? String
        
        return cell
    }
    
    // MARK: Alerts
    func displayNewGameAlert() {
        
        let alertController = UIAlertController(title: "New Game", message: "Would you like to accept?", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "No", style: .Cancel) { (action) in

            // Rails: cancel invitation
            User.currentUser().declineInvitation(User.currentUser().id, invitations: User.currentUser().invitations)

        }

        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Yes", style: .Default) { (action) in
            
//            // Rails: accept invitation
//            User.currentUser().acceptInvitation(User.currentUser().id, invitations: User.currentUser().invitations)
            
            // TODO: pass data on to VC
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let vc = storyboard.instantiateViewControllerWithIdentifier("dropFlagVC") as DropFlagVC
            
            self.presentViewController(vc, animated: true, completion: nil)
            
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    
    
}