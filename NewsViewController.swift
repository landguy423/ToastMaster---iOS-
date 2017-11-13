//
//  NewsViewController.swift
//  ToastMasters
//
//  Created by kbs on 6/16/16.
//  Copyright © 2016 kbs. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {
    
   
    @IBOutlet weak var buttonPrevious: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    
    @IBOutlet weak var labelNews: UILabel!
    
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    var data: NSMutableData = NSMutableData()
    var arrNews: NSArray = NSArray()
    var arrNotice : NSMutableArray = NSMutableArray()
    var dictAgendaResponse = [NSDictionary]()
    var abc = Int()
    var b = Int()
    var myActivityIndicator = UIActivityIndicatorView()
    var arrTitle: NSMutableArray = NSMutableArray()
    var arrDate: NSMutableArray = NSMutableArray()
    var arrTime: NSMutableArray = NSMutableArray()
    var dateString : NSString = NSString()
    var TimeString : NSString = NSString()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        // Do any additional setup after loading the view.
        
        var tabledata : NSArray? = nil
         tabledata = NSUserDefaults.standardUserDefaults().objectForKey("newsData") as? NSArray

        print(tabledata)

        if tabledata == nil || tabledata!.count <= 0
        {
            let urlString = "http://niconesolutions.com/web/News.php"
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
            for index in tabledata!
            {
                
                print( "Value of  index is \(index .valueForKey("news_description"))")
                
                arrNotice.addObject(index .valueForKey("news_description")!)
                print(arrNotice)
                labelNews.text = tabledata!.valueForKey("news_description").objectAtIndex(0) as? String
                
                arrTitle.addObject(index .valueForKey("news_title")!)
                print(arrNotice)
                lblTitle.text = tabledata!.valueForKey("news_title").objectAtIndex(0) as? String
                
                dateString = (index .valueForKey("start_date")) as! NSString
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                let dateFromStringStart = dateFormatter.dateFromString(self.dateString as String)
                print(dateFromStringStart)
                
                if dateFromStringStart != nil
                {
                    
                    let dateformatter1 = NSDateFormatter()
                    dateformatter1.dateFormat = "dd/MM/yyyy"
                    
                    let startDate = (dateformatter1.stringFromDate(dateFromStringStart!))
                    print (startDate )
                    arrDate.addObject(startDate)
                    print(arrDate)
                    labelDate.text = arrDate.objectAtIndex(0) as? String
                    
                }
                    
                else
                    
                {
                    let date = NSDate()
                    let dateformatter1 = NSDateFormatter()
                    dateformatter1.dateFormat = "dd/MM/yyyy"
                    let startDate = (dateformatter1.stringFromDate(date))
                    print (startDate )
                    arrDate.addObject(startDate)
                    print(arrDate)
                    labelDate.text = arrDate.objectAtIndex(0) as? String
                    
                }
                
                TimeString = (index .valueForKey("start_tine")) as! NSString
                print(TimeString)
                
                let dateformatter1 = NSDateFormatter()
                dateformatter1.dateStyle = NSDateFormatterStyle.MediumStyle
                dateformatter1.dateFormat = "HH:mm:ss"
                let date = dateformatter1.dateFromString(self.TimeString as String)
                print(date)
                
                let dateformatter2 = NSDateFormatter()
                dateformatter2.dateFormat = "hh:mm a"
                print(dateformatter2.stringFromDate(date!))
                arrTime.addObject(dateformatter2.stringFromDate(date!))
                labelTime.text = arrTime.objectAtIndex(0) as? String
                print(arrTime)
                
                abc=0
            }
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
                arrNews = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! [NSDictionary]
                
                NSUserDefaults.standardUserDefaults().setObject(arrNews, forKey: "newsData")
                
                for index in arrNews
                {
                    
                    print( "Value of  index is \(index .valueForKey("news_description"))")
                    
                    arrNotice.addObject(index .valueForKey("news_description")!)
                    print(arrNotice)
                    labelNews.text = arrNews.valueForKey("news_description").objectAtIndex(0) as? String
                    
                    arrTitle.addObject(index .valueForKey("news_title")!)
                    print(arrNotice)
                    lblTitle.text = arrNews.valueForKey("news_title").objectAtIndex(0) as? String
                    
                    dateString = (index .valueForKey("start_date")) as! NSString

                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    
                    let dateFromStringStart = dateFormatter.dateFromString(self.dateString as String)
                    print(dateFromStringStart)
                    
                    if dateFromStringStart != nil
                    {

                        let dateformatter1 = NSDateFormatter()
                        dateformatter1.dateFormat = "dd/MM/yyyy"
                        
                        let startDate = (dateformatter1.stringFromDate(dateFromStringStart!))
                        print (startDate )
                        arrDate.addObject(startDate)
                        print(arrDate)
                        labelDate.text = arrDate.objectAtIndex(0) as? String

                    }
                    
                    else
                    
                    {
                        let date = NSDate()
                        let dateformatter1 = NSDateFormatter()
                        dateformatter1.dateFormat = "dd/MM/yyyy"
                        let startDate = (dateformatter1.stringFromDate(date))
                        print (startDate )
                        arrDate.addObject(startDate)
                        print(arrDate)
                        labelDate.text = arrDate.objectAtIndex(0) as? String
                    
                    }

                    TimeString = (index .valueForKey("start_tine")) as! NSString
                    print(TimeString)
            
                    let dateformatter1 = NSDateFormatter()
                    dateformatter1.dateStyle = NSDateFormatterStyle.MediumStyle
                    dateformatter1.dateFormat = "HH:mm:ss"
                    let date = dateformatter1.dateFromString(self.TimeString as String)
                    print(date)
                
                    let dateformatter2 = NSDateFormatter()
                    dateformatter2.dateFormat = "hh:mm a"
                    print(dateformatter2.stringFromDate(date!))
                    arrTime.addObject(dateformatter2.stringFromDate(date!))
                    labelTime.text = arrTime.objectAtIndex(0) as? String
                    print(arrTime)
                    
                    abc=0
                }
                
                myActivityIndicator.stopAnimating()
                
            }
            catch let error as NSError
            {
                print(error)
            }
        }
    }
    
    @IBAction func buttonBack(sender: AnyObject)
    {
        
        if abc > 0
        {
            abc--
            print(abc)
            labelNews.text = arrNotice.objectAtIndex(abc) as? String
            print(labelNews.text)
            
            lblTitle.text = arrTitle.objectAtIndex(abc) as? String
            print(labelNews.text)
            
            
            labelDate.text = (arrDate.objectAtIndex(abc) as? String)!
            print(labelDate.text)
            
            labelTime.text = arrTime.objectAtIndex(abc) as? String
            print(labelTime.text)
            buttonNext.enabled = true
        }
            
        else
            
        {
            
            print("No more elements to display.")
            buttonPrevious.enabled = false
            
        }
    }
    
    @IBAction func buttonNext(sender: AnyObject)
        
    {
        
        if abc < arrNotice.count-1
        {
            abc++
            print(abc)
            labelNews.text = arrNotice.objectAtIndex(abc) as? String
            print(labelNews.text)
            
            lblTitle.text = arrTitle.objectAtIndex(abc) as? String
            print(labelNews.text)
            
            labelDate.text = arrDate.objectAtIndex(abc) as? String
            print(labelDate.text)
            
            labelTime.text = arrTime.objectAtIndex(abc) as? String
            print(labelTime.text)
            buttonPrevious.enabled = true
        }
            
        else
        {
            
            print("No more elements to display.")
            
            buttonNext.enabled = false
        }
    }

    @IBAction func buttonBackToHome(sender: AnyObject)
    {
        
       let array: NSMutableArray = NSMutableArray()
        
     NSUserDefaults.standardUserDefaults().setObject(array, forKey: "newsData")

        self.navigationController!.popToRootViewControllerAnimated(true)
        
        
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
    @IBAction func buttonExecutive(sender: AnyObject)
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
