//
//  HomeViewController.swift
//  ToastMasters
//
//  Created by kbs on 6/16/16.
//  Copyright © 2016 kbs. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    var index  : Int = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBarHidden = true
        
    }

    @IBAction func buttonNews(sender: AnyObject)
    
    {
 
        let arrayNewsFeed: NSMutableArray = NSMutableArray()
        
        NSUserDefaults.standardUserDefaults().setObject(arrayNewsFeed, forKey: "newsData")
        
        let arrayAgenda: NSMutableArray = NSMutableArray()
        
        NSUserDefaults.standardUserDefaults().setObject(arrayAgenda, forKey: "agenda1")
        
        let arrayMeetings: NSMutableArray = NSMutableArray()
        
        NSUserDefaults.standardUserDefaults().setObject(arrayMeetings, forKey: "meeting")
        
        let arrayExecutive: NSMutableArray = NSMutableArray()
        
        NSUserDefaults.standardUserDefaults().setObject(arrayExecutive, forKey: "executive")
    }
    
    @IBAction func buttonAgenda(sender: AnyObject)
    
    {
 
        let arrayAgenda: NSMutableArray = NSMutableArray()
        
        NSUserDefaults.standardUserDefaults().setObject(arrayAgenda, forKey: "agenda1")
        
        let arrayNewsFeed: NSMutableArray = NSMutableArray()
        
        NSUserDefaults.standardUserDefaults().setObject(arrayNewsFeed, forKey: "newsData")
        let arrayMeetings: NSMutableArray = NSMutableArray()
        
        NSUserDefaults.standardUserDefaults().setObject(arrayMeetings, forKey: "meeting")
        
        let arrayExecutive: NSMutableArray = NSMutableArray()
        
        NSUserDefaults.standardUserDefaults().setObject(arrayExecutive, forKey: "executive")
        
         
        
    }
    @IBAction func buttonMeeting(sender: AnyObject)
    {
        
        
        let arrayMeetings: NSMutableArray = NSMutableArray()
        
        NSUserDefaults.standardUserDefaults().setObject(arrayMeetings, forKey: "meeting")
        
        
        let arrayAgenda: NSMutableArray = NSMutableArray()
        
        NSUserDefaults.standardUserDefaults().setObject(arrayAgenda, forKey: "agenda1")
        
        let arrayNewsFeed: NSMutableArray = NSMutableArray()
        
        NSUserDefaults.standardUserDefaults().setObject(arrayNewsFeed, forKey: "newsData")
        
        let arrayExecutive: NSMutableArray = NSMutableArray()
        
        NSUserDefaults.standardUserDefaults().setObject(arrayExecutive, forKey: "executive")
        
    }
    @IBAction func buttonExecutives(sender: AnyObject)
    {
         
        let arrayExecutive: NSMutableArray = NSMutableArray()
        
        NSUserDefaults.standardUserDefaults().setObject(arrayExecutive, forKey: "executive")
        
        
        let arrayMeetings: NSMutableArray = NSMutableArray()
        
        NSUserDefaults.standardUserDefaults().setObject(arrayMeetings, forKey: "meeting")
        
        
        let arrayAgenda: NSMutableArray = NSMutableArray()
        
        NSUserDefaults.standardUserDefaults().setObject(arrayAgenda, forKey: "agenda1")
        
        let arrayNewsFeed: NSMutableArray = NSMutableArray()
        
        NSUserDefaults.standardUserDefaults().setObject(arrayNewsFeed, forKey: "newsData")

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
