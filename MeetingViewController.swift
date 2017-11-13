//
//  MeetingViewController.swift
//  ToastMasters
//
//  Created by kbs on 6/16/16.
//  Copyright © 2016 kbs. All rights reserved.
//

import UIKit
import MapKit
import EventKit
class MeetingViewController: UIViewController ,CLLocationManagerDelegate,UIAlertViewDelegate
    
{
    var myActivityIndicator = UIActivityIndicatorView()
    var data: NSMutableData = NSMutableData()
    var arrNextMeet: NSArray = NSArray()
    var dictAgendaResponse = [NSDictionary]()
    var lat : NSString = NSString()
    var long : NSString = NSString()
    var dateStringStart : NSString = NSString()
    var locationString : NSString = NSString()
    var timingStringStart : NSString = NSString()
    var timingStringEnd : NSString = NSString()
    var dateStringEnd : NSString = NSString()
    
    @IBAction func buttonSaveMeetingDate(sender: AnyObject)
    {
        let eventStore : EKEventStore = EKEventStore()
        // 'EKEntityTypeReminder' or 'EKEntityTypeEvent'
        eventStore.requestAccessToEntityType(EKEntityType.Event, completion: {
            granted, error in
            if (granted) && (error == nil) {
                print("granted \(granted)")
                print("error  \(error)")
                
                let event:EKEvent = EKEvent(eventStore: eventStore)
                event.title = "Meeting At"
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                
                let dateFromStringStart = dateFormatter.dateFromString(self.dateStringStart as String)
                print(dateFromStringStart)
                
                let dateformatter1 = NSDateFormatter()
                dateformatter1.dateFormat = "h:mm a"
                let startTime = (dateformatter1.stringFromDate(dateFromStringStart!))
                print (startTime)
                
                let EndDate = NSCalendar.currentCalendar().dateByAddingUnit( .Hour, value: 1, toDate:dateFromStringStart!, options: [])
                print(EndDate)
                
                let dateformatter2 = NSDateFormatter()
                dateformatter2.dateFormat = "h:mm a"
                let EndTime = (dateformatter1.stringFromDate(EndDate!))
                print (EndTime)
                
                event.startDate = dateFromStringStart!
                event.endDate = EndDate!
                event.notes = "Timing is \(startTime) to \(EndTime)"
                event.location = self.locationString as String
                event.calendar = eventStore.defaultCalendarForNewEvents
                
                var saveToCalendarError: NSError?
                let success: Bool
                do
                {
                    //Swift2: use of unresolved identifier 'EKSpanThisEvent'
                    try eventStore.saveEvent(event, span:EKSpan.ThisEvent)
                    success = true
                    print("Saved Event")
                    
                    let alertController = UIAlertController(title: "Message", message: "Meeting date saved in Calender", preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default)
                        {
                            (action:UIAlertAction!) in
                            print("you have pressed OK button")
                    }
                    alertController.addAction(OKAction)
                    
                    self.presentViewController(alertController, animated: true, completion:nil)
                }
                    
                catch let error as NSError
                {
                    saveToCalendarError = error
                    success = false
                    print("Not Saved Event")
                    
                    let alertController2 = UIAlertController(title: "Message", message: "Meeting date not saved in Calender. You have selected wrong date", preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default)
                        {
                            (action:UIAlertAction!) in
                            print("you have pressed OK button")
                    }
                    alertController2.addAction(OKAction)
                    
                    self.presentViewController(alertController2, animated: true, completion:nil)
                    
                }
                    
                catch
                    
                {
                    fatalError()
                }
            }
        })
    }

    let locationManager = CLLocationManager()
    
    @IBOutlet weak var buttonSaveMeeting: UIButton!
    @IBOutlet weak var viewMap: MKMapView!
    
    let manager = CLLocationManager()
 
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.locationManager.requestAlwaysAuthorization()
        self.navigationController?.navigationBarHidden = true

        // Do any additional setup after loading the view.
        
        var tabledata3 : NSArray? = nil
        tabledata3 = NSUserDefaults.standardUserDefaults().objectForKey("meeting") as? NSArray
        
        print(tabledata3)
        
        if tabledata3 == nil || tabledata3!.count <= 0
        {
            let urlString = "http://niconesolutions.com/web/Meetings.php?id=1"
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
            for index in tabledata3!
            {
                print( "Value of  index is \(index .valueForKey("latitude"))")
                print( "Value of  index is \(index .valueForKey("longitude"))")
                print( "Value of  index is \(index .valueForKey("street_address1"))")
                print( "Value of  index is \(index .valueForKey("street_address2"))")
                print( "Value of  index is \(index .valueForKey("date"))")
                
                let lblStreet1 : UILabel? = self.view.viewWithTag(3) as? UILabel
                lblStreet1?.text = (index .valueForKey("street_address1")) as? String
                print(index.valueForKey("street_address1") as? String)
                
                let lblStreet2 : UILabel? = self.view.viewWithTag(6) as? UILabel
                lblStreet2?.text = (index .valueForKey("street_address2")) as? String
                print(index.valueForKey("street_address2") as? String)
                
                let lblTime : UILabel? = self.view.viewWithTag(12) as? UILabel
                timingStringStart = ((index.valueForKey("time")) as? String)!
                print(timingStringStart)
                let dateFormatterTime = NSDateFormatter()
                dateFormatterTime.dateFormat = "H:mm"
                let date24 = dateFormatterTime.dateFromString(timingStringStart as String)!
                print( date24)
                dateFormatterTime.dateFormat = "h:mm a"
                let date12 = dateFormatterTime.stringFromDate(date24)
                print(date12)
                lblTime?.text = date12
                
                
                let dateFormatterX = NSDateFormatter()
                dateFormatterX.dateFormat = "h:mm a"
                let dateX = dateFormatterX.dateFromString(date12)
                
                dateFormatterX.dateFormat = "HH:mm"
                let date24X = dateFormatterX.stringFromDate(dateX!)
                print(date24X)
                
                let lblDate : UILabel? = self.view.viewWithTag(9) as? UILabel
                var abcDate = NSString()
                abcDate = (index .valueForKey("date") as! String)
                print(abcDate)
                
                let strDate = abcDate
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                print ( dateFormatter.dateFromString( strDate as String ))
                
                let strDate1 = ( dateFormatter.dateFromString( strDate as String ))
                let dateFormatter1 = NSDateFormatter()
                dateFormatter1.dateFormat = "dd/MM/yyyy"
                print ( dateFormatter1.stringFromDate(strDate1!))
                lblDate?.text = ( dateFormatter1.stringFromDate(strDate1!))
                
                locationString = ( (lblStreet1?.text)! + (lblStreet2?.text)!)
                timingStringStart = " \(date24X)"
                dateStringStart = abcDate
                dateStringStart = (dateStringStart as String) + (timingStringStart as String) as String
                print(dateStringStart)
                
                lat =  (index .valueForKey("latitude")) as! String
                long = (index .valueForKey("longitude")) as! String
                
                print("Lat:" , lat )
                print("Long:" , long )
                
                let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(0.02 , 0.02)
                
                let myDoubleLat = Double(lat as String)
                let myDoubleLong = Double(long as String)
                print(myDoubleLat)
                let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: myDoubleLat!, longitude: myDoubleLong!)
                
                let theRegion:MKCoordinateRegion = MKCoordinateRegionMake(location, theSpan)
                
                self.viewMap.setRegion(theRegion, animated: true)
                
                let location1 = CLLocation(latitude: myDoubleLat!, longitude: myDoubleLong!)
                
                CLGeocoder().reverseGeocodeLocation(location1, completionHandler: {(placemarks, error) -> Void in
                    print(location)
                    
                    if error != nil {
                        print("Reverse geocoder failed with error" + error!.localizedDescription)

                            let information = MKPointAnnotation()
                            
                        let userLoc = NSUserDefaults.standardUserDefaults().objectForKey("Location") as! [String : NSNumber]
                        
                        //Get user location from that Dictionary
                        let userLat = userLoc["lat"]
                        let userLng = userLoc["lng"]
                        
                        information.coordinate.latitude = userLat as! CLLocationDegrees  //Convert NSNumber to CLLocationDegrees
                        information.coordinate.longitude = userLng as! CLLocationDegrees
                        
                        if ((NSUserDefaults.standardUserDefaults().objectForKey("Titles")) != nil) {
                            let userTitles = NSUserDefaults.standardUserDefaults().objectForKey("Titles") as! [String : NSString]
                            //Get user location from that Dictionary
                            let  Title = userTitles["LocTitle"]
                            let SubTitle = userTitles["LocSubTitle"]
                            information.coordinate = location
                            information.title = Title as? String
                            information.subtitle =  SubTitle as? String
                            self.viewMap.addAnnotation(information)
                        }
                        
                        
                   
                        }
                    
                    let information = MKPointAnnotation()
                    
                    let userLoc = NSUserDefaults.standardUserDefaults().objectForKey("Location") as! [String : NSNumber]
                    
                    //Get user location from that Dictionary
                    let userLat = userLoc["lat"]
                    let userLng = userLoc["lng"]
                    
                    information.coordinate.latitude = userLat as! CLLocationDegrees  //Convert NSNumber to CLLocationDegrees
                    information.coordinate.longitude = userLng as! CLLocationDegrees

                    if ((NSUserDefaults.standardUserDefaults().objectForKey("Titles")) != nil) {
                        let userTitles = NSUserDefaults.standardUserDefaults().objectForKey("Titles") as! [String : NSString]
                        //Get user location from that Dictionary
                        let  Title = userTitles["LocTitle"]
                        let SubTitle = userTitles["LocSubTitle"]
                        information.coordinate = location
                        information.title = Title as? String
                        information.subtitle =  SubTitle as? String
                        self.viewMap.addAnnotation(information)
                    }
                })
            }
            
        }

        
        
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
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
                arrNextMeet = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! [NSDictionary]
                
                NSUserDefaults.standardUserDefaults().setObject(arrNextMeet, forKey: "meeting")
                
                for index in arrNextMeet
                {
                    print( "Value of  index is \(index .valueForKey("latitude"))")
                    print( "Value of  index is \(index .valueForKey("longitude"))")
                    print( "Value of  index is \(index .valueForKey("street_address1"))")
                    print( "Value of  index is \(index .valueForKey("street_address2"))")
                    print( "Value of  index is \(index .valueForKey("date"))")
                    
                    let lblStreet1 : UILabel? = self.view.viewWithTag(3) as? UILabel
                    lblStreet1?.text = (index .valueForKey("street_address1")) as? String
                    print(index.valueForKey("street_address1") as? String)
                    
                    let lblStreet2 : UILabel? = self.view.viewWithTag(6) as? UILabel
                    lblStreet2?.text = (index .valueForKey("street_address2")) as? String
                    print(index.valueForKey("street_address2") as? String)
                    
                    let lblTime : UILabel? = self.view.viewWithTag(12) as? UILabel
                    timingStringStart = ((index.valueForKey("time")) as? String)!
                    print(timingStringStart)
                    let dateFormatterTime = NSDateFormatter()
                    dateFormatterTime.dateFormat = "H:mm"
                    let date24 = dateFormatterTime.dateFromString(timingStringStart as String)!
                    print( date24)
                    dateFormatterTime.dateFormat = "h:mm a"
                    let date12 = dateFormatterTime.stringFromDate(date24)
                    print(date12)
                    lblTime?.text = date12
                    
                    
                    let dateFormatterX = NSDateFormatter()
                    dateFormatterX.dateFormat = "h:mm a"
                    let dateX = dateFormatterX.dateFromString(date12)
                    
                    dateFormatterX.dateFormat = "HH:mm"
                    let date24X = dateFormatterX.stringFromDate(dateX!)
                    print(date24X)
                    
                    let lblDate : UILabel? = self.view.viewWithTag(9) as? UILabel
                    var abcDate = NSString()
                    abcDate = (index .valueForKey("date") as! String)
                    print(abcDate)
                    
                    let strDate = abcDate
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    print ( dateFormatter.dateFromString( strDate as String ))
                    
                    let strDate1 = ( dateFormatter.dateFromString( strDate as String ))
                    let dateFormatter1 = NSDateFormatter()
                    dateFormatter1.dateFormat = "dd/MM/yyyy"
                    print ( dateFormatter1.stringFromDate(strDate1!))
                    lblDate?.text = ( dateFormatter1.stringFromDate(strDate1!))
                    
                    locationString = ( (lblStreet1?.text)! + (lblStreet2?.text)!)
                    timingStringStart = " \(date24X)"
                    dateStringStart = abcDate
                    dateStringStart = (dateStringStart as String) + (timingStringStart as String) as String
                    print(dateStringStart)
                    
                    lat =  (index .valueForKey("latitude")) as! String
                    long = (index .valueForKey("longitude")) as! String
                    
                    print("Lat:" , lat )
                    print("Long:" , long )
                    
                    let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(0.02 , 0.02)
                    
                    let myDoubleLat = Double(lat as String)
                    let myDoubleLong = Double(long as String)
                    print(myDoubleLat)
                    
                    let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: myDoubleLat!, longitude: myDoubleLong!)
                    
                    let lat1 : NSNumber = NSNumber(double: location.latitude)
                    let lng1 : NSNumber = NSNumber(double: location.longitude)
                    
                    //Store it into Dictionary
                    let locationDict = ["lat": lat1, "lng": lng1]
                    
                    //Store that Dictionary into NSUserDefaults
                    NSUserDefaults.standardUserDefaults().setObject(locationDict, forKey: "Location")
                    
                    
                    let theRegion:MKCoordinateRegion = MKCoordinateRegionMake(location, theSpan)
                    
                    self.viewMap.setRegion(theRegion, animated: true)
                    
                    let location1 = CLLocation(latitude: myDoubleLat!, longitude: myDoubleLong!)
        
                    CLGeocoder().reverseGeocodeLocation(location1, completionHandler: {(placemarks, error) -> Void in
                    
                        print(location)
                        
                        if error != nil {
                            print("Reverse geocoder failed with error" + error!.localizedDescription)
                            return
                        }
                        
                        if placemarks!.count > 0
                        {
                            let pm = placemarks![0]
                            print(pm.locality)
                            print(pm.administrativeArea)
                            print(pm.country)
                            let information = MKPointAnnotation()
                            information.coordinate = location
                            information.title = pm.locality!
                            information.subtitle =  pm.country!
                            
                            let LocTitle : NSString = NSString(string: information.title!)
                            let LocSubTitle : NSString = NSString(string: information.subtitle!)
                            
                            //Store it into Dictionary
                            let locationDictTitles = ["LocTitle": LocTitle, "LocSubTitle": LocSubTitle]
                            
                            //Store that Dictionary into NSUserDefaults
                            NSUserDefaults.standardUserDefaults().setObject(locationDictTitles, forKey: "Titles")
                            
                            self.viewMap.addAnnotation(information)
                        }
                        else
                        {
                            print("Problem with the data received from geocoder")
                        }
                    })
                }
                 myActivityIndicator.stopAnimating()
            }
            catch let error as NSError
            {
                print(error)
            }
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Error while updating location " + error.localizedDescription)
    }
    @IBAction func buttonBackToHome(sender: AnyObject)
    {
        let arrayMeet: NSMutableArray = NSMutableArray()
        
        NSUserDefaults.standardUserDefaults().setObject(arrayMeet, forKey: "meeting")

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
    @IBAction func buttonExecutives(sender: AnyObject)
    {
        let Taballmember = self.storyboard!.instantiateViewControllerWithIdentifier("executive")
        self.navigationController!.pushViewController(Taballmember, animated: false)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
