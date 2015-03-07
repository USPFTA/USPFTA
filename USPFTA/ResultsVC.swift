import UIKit

class ResultsVC: UIViewController, UITableViewDataSource, UITableViewDelegate,  APIControllerProtocol {
    
    let kCellIdentifier: String = "SearchResultCell"
    
    var api = APIController()
    
    @IBOutlet var resultsTableView : UITableView?
    
    var resultsData = []
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.api.delegate = self
        
        
        // FIXME: add search from Rails
        api.obtainGameResults("")
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)

        // TODO: add listener for new game
        // TODO: make listener listen repeatedly
        
        User.currentUser().getInvitations(User.currentUser().id)

//        // once new game is returned, display alert that will lead to DropFlagVC
//        displayNewGameAlert()
    }
    
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

        }

        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Yes", style: .Default) { (action) in
            
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