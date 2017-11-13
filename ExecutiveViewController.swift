//
//  ExecutiveViewController.swift
//  ToastMasters
//
//  Created by kbs on 6/16/16.
//  Copyright © 2016 kbs. All rights reserved.
//

import UIKit

class ExecutiveViewController: UIViewController , UITableViewDelegate, UITableViewDataSource
{
    
    let cellIdentifier = "CellIdentifier2"
    var data: NSMutableData = NSMutableData()
    var arrExecMember: NSArray = NSArray()
    var dictAgendaResponse = [NSDictionary]()
    var myActivityIndicator = UIActivityIndicatorView()
    var justOnce:Bool = true
 
    @IBOutlet weak var tableViewExecMember: UITableView!
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.navigationController?.navigationBarHidden = true

        var tabledata4 : NSArray? = nil
        tabledata4 = NSUserDefaults.standardUserDefaults().objectForKey("executive") as? NSArray
        
        print(tabledata4)
        
        if tabledata4 == nil || tabledata4!.count <= 0
        {
            let urlString = "http://niconesolutions.com/web/ExecutiveMembers.php"
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
            
            arrExecMember = tabledata4!
            
            //tableViewAgenda.reloadData()
            
        }
    }
    
    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
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
                
                arrExecMember = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! [NSDictionary]
                
                 NSUserDefaults.standardUserDefaults().setObject(arrExecMember, forKey: "executive")
                print(arrExecMember)
                for index in arrExecMember
                {
                    
                    print( "Value of  index is \(index .valueForKey("member_name"))")
                    print( "Value of  index is \(index .valueForKey("member_designation"))")
                    print( "Value of  index is \(index .valueForKey("image_path"))")
                }
                tableViewExecMember.reloadData()
                myActivityIndicator.stopAnimating()
                
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
        return arrExecMember.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        let lblMemberName : UILabel? = cell.contentView.viewWithTag(2) as? UILabel
        lblMemberName?.text = arrExecMember[indexPath.row].objectForKey("member_name") as? String
        
        
        let lblMemberDesignation : UILabel? = cell.contentView.viewWithTag(4) as? UILabel
        lblMemberDesignation?.text = arrExecMember[indexPath.row].objectForKey("member_designation") as? String
        lblMemberDesignation?.textColor = UIColor(  red: 214/255,  green: 147/255, blue: 23/255, alpha: 1.0)
        
        let imageViewExecMember : UIImageView? = cell.contentView.viewWithTag(10) as? UIImageView
        imageViewExecMember?.layer.borderWidth = 2.0
        imageViewExecMember?.layer.borderColor = UIColor(  red: 0/255,  green: 100/255, blue: 170/255, alpha: 1.0).CGColor
        imageViewExecMember?.layer.cornerRadius = ((imageViewExecMember?.frame.size.width))!/2.0
        imageViewExecMember?.layer.masksToBounds = true
        if let strImage = (arrExecMember[indexPath.row].objectForKey("image_path") as? String)
        {
            // ... your strImage is String  ...
            if let data = NSData(contentsOfURL: NSURL(string:strImage )!)
            {
                print(data)
              
                (imageViewExecMember! as UIImageView).image = UIImage(data: data)
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
        let arrayExec: NSMutableArray = NSMutableArray()
        
        NSUserDefaults.standardUserDefaults().setObject(arrayExec, forKey: "executive")
        
        self.navigationController!.popToRootViewControllerAnimated(true)
    }
    @IBAction func buttonNews(sender: AnyObject)
    {
        let Taballmember = self.storyboard!.instantiateViewControllerWithIdentifier("news")
        self.navigationController!.pushViewController(Taballmember, animated: false)
    }
    
    @IBAction func buttonAgenda(sender: AnyObject)
    {
        let Taballmember = self.storyboard!.instantiateViewControllerWithIdentifier("agenda")
        self.navigationController!.pushViewController(Taballmember, animated: false)
    }
    @IBAction func buttonMeeting(sender: AnyObject)
    {
        let Taballmember = self.storyboard!.instantiateViewControllerWithIdentifier("meeting")
        self.navigationController!.pushViewController(Taballmember, animated: false)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
