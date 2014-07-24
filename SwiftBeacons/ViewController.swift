//
//  ViewController.swift
//  SwiftBeacons
//
//  Created by OIrving on 7/21/14.
//  Copyright (c) 2014 ThoughtWorks. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate, UITableViewDelegate,UITableViewDataSource {
    
    var beaconTable:UITableView = UITableView(frame: UIScreen.mainScreen().bounds, style: UITableViewStyle.Grouped)
    let locationManager:CLLocationManager = CLLocationManager()
    var myBeaconRegion:CLBeaconRegion = CLBeaconRegion()
    var beacons = [];
    var beaconIndex:Int = 0;
    var currentBeaconMinor:NSNumber = 0;
    var isDisplayingData:Bool = false;
    
    override func loadView() {
        
        beaconTable.autoresizingMask = UIViewAutoresizing.FlexibleWidth|UIViewAutoresizing.FlexibleWidth
        beaconTable.delegate = self;
        beaconTable.dataSource = self;

        beaconTable.reloadData()
        
        locationManager.delegate = self;
        
        var uuid:NSUUID = NSUUID(UUIDString: "8AEFB031-6C32-486F-825B-E26FA193487D")
        
        
        myBeaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: uuid.UUIDString)
        
        if (!CLLocationManager.isMonitoringAvailableForClass(CLBeaconRegion.classForCoder())) {
            var alert:UIAlertView = UIAlertView(title: "Monitoring not available", message: "", delegate: nil, cancelButtonTitle: "Ok")
            
            alert.show()
            return
        }
        
        locationManager.startMonitoringForRegion(myBeaconRegion)
        self.view = beaconTable;

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.beaconTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "hawkICell")
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        locationManager.startRangingBeaconsInRegion(myBeaconRegion)

        isDisplayingData = false;
        currentBeaconMinor = 0;


        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func tableView(tableView:UITableView!, numberOfRowsInSection section:Int)->Int
    {
        
        return self.beacons.count
    }
    
    func tableView(tableView:UITableView!, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
    {
        
        return 51
    }
    
    
    
    func numberOfSectionsInTableView(tableView:UITableView!)->Int
    {
        return 1
    }
    
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell
    {
        var  cell = tableView.dequeueReusableCellWithIdentifier("hawkICell", forIndexPath: indexPath) as UITableViewCell
        
        var beacon = self.beacons.objectAtIndex(indexPath.row) as CLBeacon
        
        cell.textLabel.text = "Beacon \(beacon.minor) - \(beacon.accuracy)"
        
        
        return cell
    }
    
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_manager: CLLocationManager!, didRangeBeacons beacons:NSArray!, inRegion region: CLBeaconRegion!) {
        self.beacons = beacons
        self.beaconIndex = 0;
        for beacon : AnyObject in self.beacons
        {
            
            
            if(beacon.accuracy > 2  || beacon.accuracy < 0){
                if (self.isDisplayingData==true && beacon.minor == self.currentBeaconMinor)
                {
                    self.currentBeaconMinor = 0;
                    self.isDisplayingData = false;
                }
                self.beaconIndex++;
            }
            else
            {
                if(beacon.minor != self.currentBeaconMinor && self.isDisplayingData==false)
                {
                    self.currentBeaconMinor = beacon.minor;
                    
                    self.isDisplayingData = true;
                    self.performSegueWithIdentifier("beaconInfo", sender: self)
                }
                
            }
        }
        
        self.beaconTable.reloadData()
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    


    
//    - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//    {
//    if ([segue.identifier isEqualToString:@"beaconInfo"]) {
//    BeaconViewController *controller = segue.destinationViewController;
//    controller.beacon = [self.beacons objectAtIndex:self.beaconIndex];
//    }
//    
//    // Pass the selected object to the new view controller.
//    }
    

}

