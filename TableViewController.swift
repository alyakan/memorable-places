//
//  TableViewController.swift
//  Memorable Places
//
//  Created by Aly Yakan on 8/16/16.
//  Copyright © 2016 Aly Yakan. All rights reserved.
//

import UIKit
import CoreLocation

var activePlace = -1

var locationSelected: CLLocation = CLLocation(latitude: CLLocationDegrees(0), longitude: CLLocationDegrees(0))
var locSelectedDesc: String = ""

class TableViewController: UITableViewController {

    @IBOutlet var favoritesTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if places.count == 1 {
            places.removeAll()
            places.append(["name": "Taj Mahal", "lat": "27.175277", "lon": "78.042128"])
        }
        
        if NSUserDefaults.standardUserDefaults().objectForKey("places") != nil {
            places = NSUserDefaults.standardUserDefaults().objectForKey("places")! as! [Dictionary<String, String>]
        }
        
    }
    
    func navigateToNextView() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("mapViewController") as! ViewController
        self.presentViewController(nextViewController, animated:true, completion:nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")

        cell.textLabel?.text = places[indexPath.row]["name"]
        
        return cell
    }
    
    override func viewWillAppear(animated: Bool) {
        favoritesTable.reloadData()
    }

    
     // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
         // Return false if you do not want the specified item to be editable.
        return true
    }
 

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            places.removeAtIndex(indexPath.row)
            
            favoritesTable.reloadData()
            
            NSUserDefaults.standardUserDefaults().setObject(places, forKey: "places")
            
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        activePlace = indexPath.row
        self.performSegueWithIdentifier("mapSegue", sender: self)
        
        return indexPath
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        _ = segue.destinationViewController as! ViewController
        
        if segue.identifier == "newPlace" {
            activePlace = -1
        }
    }
    
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
