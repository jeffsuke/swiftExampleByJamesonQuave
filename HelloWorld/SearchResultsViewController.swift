//
//  ViewController.swift
//  HelloWorld
//
//  Created by Yusuke Kawanabe on 1/7/15.
//  Copyright (c) 2015 Yusuke Kawanabe. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {

    @IBOutlet weak var appsTableView: UITableView!
    
    var albums = [Album]()
    var api: APIController?
    var imageCache = [String: UIImage]()
    
    let kCellIdentifier = "SearchResultCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        api = APIController(delegate: self)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        api!.searchItunesFor("Beatles")
        println("Hello World")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
        
        let album = albums[indexPath.row]
        
        cell.textLabel?.text = album.title
        cell.imageView?.image = UIImage (named: "Blank52");
        
        let formattedPrice: NSString = album.price
        
        let urlString = album.thumbnailImageURL
        
        var image = self.imageCache[urlString]
        
        if (image == nil) {
            var imageURL: NSURL! = NSURL(string: urlString)!
            
            let request: NSURLRequest = NSURLRequest(URL: imageURL)
            
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                if error == nil {
                    image = UIImage(data: data)
                    
                    self.imageCache[urlString] = image
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        (cell.imageView?.image = image)!
                        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimation.None)
                    })
                }
                else {
                    println("Error:\(error.localizedDescription)")
                }
            })
        }
        else {
            cell.imageView?.image = image
        }
        
        cell.detailTextLabel?.text = formattedPrice
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        var rowData = albums[indexPath.row] as NSDictionary
//        
//        var name = rowData["trackName"] as String
//        var formattedPrice = rowData["formattedPrice"] as String
//        
//        var alert = UIAlertView()
//        alert.title = name
//        alert.message = formattedPrice
//        alert.addButtonWithTitle("OK")
//        alert.show()
    }
    
    
    func didReceiveAPIResults(results: NSDictionary) {
        var resultsArr = results["results"] as NSArray
        dispatch_async(dispatch_get_main_queue(), {
            self.albums = Album.albumsWithJSON(resultsArr)
            self.appsTableView!.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
        })
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var detailViewController: DetailViewController = segue.destinationViewController as DetailViewController
        var albumIndex = appsTableView!.indexPathForSelectedRow()!.row
        var selectedAlbum = self.albums[albumIndex]
        detailViewController.album = selectedAlbum
    }
}

