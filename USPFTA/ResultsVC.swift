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
        
        // TODO: add listener for new game
        
        // once new game is returned, display alert that will lead to DropFlagVC
        
        
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    
    
}