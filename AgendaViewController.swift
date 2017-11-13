//
//  AgendaViewController.swift
//  ToastMasters
//
//  Created by kbs on 6/16/16.
//  Copyright © 2016 kbs. All rights reserved.
//

import UIKit

class AgendaViewController: UIViewController
{

    
    @IBOutlet weak var tableViewAgenda: UITableView!
    
    
    let cellIdentifier = "CellIdentifier"
    
    var data: NSMutableData = NSMutableData()
    var arrAgenda: NSArray = NSArray()
    
    var dictAgendaResponse = [NSDictionary]()
    var myActivityIndicator = UIActivityIndicatorView()
    var arrName: NSMutableArray = NSMutableArray()
    var abc = Int()
    
     override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        // Do any additional setup after loading the view.
 
       var tabledata2 : NSArray? = nil
        tabledata2 = NSUserDefaults.standardUserDefaults().objectForKey("agenda1") as? NSArray
        
        print(tabledata2)
        
        if tabledata2 == nil || tabledata2!.count <= 0
        {
            self.automaticallyAdjustsScrollViewInsets = false
            let urlString = "http://niconesolutions.com/web/MeetingAgendas.php"
            // Your Normal URL String
            let url = NSURL(string: urlString)// Creating URL
            
            let request: NSURLRequest = NSURLRequest(URL: url!)
            let connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: false)!
            print(connection)
            connection.start()
            
            myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
            myActivityIndicator.center = view.center
            myActivityIndicator.startAnimating()
            view.addSubview(myActivityIndicator)
        }
            
        else
        {
            
            arrAgenda = tabledata2!

            //tableViewAgenda.reloadData()
            
        }

    }
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
            }
    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse!)
    {
        // Received a new request, clear out the data object
        self.data = NSMutableData()
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        // Append the received chunk of data to our data object
        self.data.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection)
    {
        print("connectionDidFinishLoading")
        
        var responseStr = NSString()
        responseStr = NSString(data:self.data, encoding:NSUTF8StringEncoding)!
        print(responseStr)
        
        if let data = responseStr.dataUsingEncoding(NSUTF8StringEncoding)
        {
            do
                
            {
                arrAgenda = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! [NSDictionary]
                
                NSUserDefaults.standardUserDefaults().setObject(arrAgenda, forKey: "agenda1")

                for index in arrAgenda
                {
                    
                    print( "Value of  index is \(index .valueForKey("person_name"))")
                    arrName.addObject(index .valueForKey("person_name")!)
                    
                    print( "Value of  index is \(index .valueForKey("image_path"))")

                }
                
                myActivityIndicator.stopAnimating()
                tableViewAgenda.reloadData()
                
            }
            catch let error as NSError
            {
                print(error)
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrAgenda.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableViewAgenda.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
 
            let lblName : UILabel? = cell.contentView.viewWithTag(5) as? UILabel
            lblName?.text = arrAgenda[indexPath.row].objectForKey("person_name") as? String
        
            let lblShowDetails : UILabel? = cell.contentView.viewWithTag(10) as? UILabel
            lblShowDetails?.text = arrAgenda[indexPath.row].objectForKey("speech_detail") as? String
            
            let lblStartTime : UILabel? = cell.contentView.viewWithTag(15) as? UILabel
            lblStartTime?.text = arrAgenda[indexPath.row].objectForKey("start_time") as? String
            
            let lblTotalTime : UILabel? = cell.contentView.viewWithTag(20) as? UILabel
            lblTotalTime?.text = arrAgenda[indexPath.row].objectForKey("total_time") as? String
            let imageViewMember : UIImageView? = cell.contentView.viewWithTag(25) as? UIImageView
            
            imageViewMember?.layer.borderWidth = 2.0
            imageViewMember?.layer.borderColor = UIColor(  red: 60/255,  green: 126/255, blue: 0/255, alpha: 1.0).CGColor
            imageViewMember?.layer.cornerRadius = ((imageViewMember?.frame.size.width))!/2.0
            imageViewMember?.layer.masksToBounds = true
            if let strImage = (arrAgenda[indexPath.row].objectForKey("image_path") as? String)
            {
                // ... your strImage is String  ...
                if let data = NSData(contentsOfURL: NSURL(string:strImage )!)
                {
                    (imageViewMember! as UIImageView).image = UIImage(data: data)
                }
          
      
    }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
        
    {
        return 100;
    }
    @IBAction func buttonBackToHome(sender: AnyObject)
    {
        let array2: NSMutableArray = NSMutableArray()
        
        NSUserDefaults.standardUserDefaults().setObject(array2, forKey: "agenda1")
        self.navigationController!.popToRootViewControllerAnimated(true)
        
    }
    @IBAction func buttonNews(sender: AnyObject)
    {
        let Taballmember = self.storyboard!.instantiateViewControllerWithIdentifier("news")
        self.navigationController!.pushViewController(Taballmember, animated: false)
    }

    @IBAction func buttonMeeting(sender: AnyObject)
    {
        let Taballmember = self.storyboard!.instantiateViewControllerWithIdentifier("meeting")
        self.navigationController!.pushViewController(Taballmember, animated: false)
    }
    @IBAction func buttonExecutives(sender: AnyObject)
    {
        let Taballmember = self.storyboard!.instantiateViewControllerWithIdentifier("executive")
        self.navigationController!.pushViewController(Taballmember, animated: false)
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
