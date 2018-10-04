//
//  HomeFeedViewController.swift
//  instagram
//
//  Created by Pedro Daniel Sanchez on 10/2/18.
//  Copyright © 2018 Pedro Daniel Sanchez. All rights reserved.
//

import UIKit
import Parse

class HomeFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, DisplayInfoAction {
    
    var photos: [String] = []
    
    let limitSize = 20
    
    var loadedPagesCount = 1
    
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var photoTableView: UITableView!
    
    
    @IBOutlet weak var usernameLabel: UILabel!
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        photoTableView.dataSource = self
        photoTableView.delegate = self
        usernameLabel.text = "Username: \(PFUser.current()!.username!)"
        
        // Initialize a UIRefreshControl
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControl.Event.valueChanged)
        photoTableView.insertSubview(refreshControl, at: 0)

        
        
        queryPhotos()
    }
    
    @IBAction func onLogoutAction(_ sender: Any) {
        PFUser.logOutInBackground { (error: Error?) in
            // PFUser.current() will now be nil
        }
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(loginViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func onGetPictureAction(_ sender: Any) {
        self.performSegue(withIdentifier: "pictureSegue", sender: nil)

    }
    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        queryPhotos()
    }

    
    func displayInfo(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = photoTableView.dequeueReusableCell(withIdentifier: "FeedViewCell", for: indexPath) as! FeedViewCell
        
        cell.displayInfoDelegate = self
        
        let query = PFQuery(className: "Photo")
            query.getObjectInBackground(withId: "\(self.photos[indexPath.row])") {
            (photo: PFObject?, error: Error?) -> Void in
            if error == nil && photo != nil {
                cell.descriptionImageView.text = photo?.value(forKey: "caption") as? String
                cell.likes = photo?.value(forKey: "likesCount") as? Int
                cell.dateCreated = photo?.value(forKey: "createdAt") as? Date
                
                let postPicture = photo?.value(forKey: "media")! as! PFFile
                postPicture.getDataInBackground(block: {
                    (imageData: Data!, error: Error!) -> Void in
                    if (error == nil) {
                        cell.photoImageView.image = UIImage(data:imageData)
                        //print("****** W A I T I N G    !  !  !")
                    }
                })
            } else {
                print(error.debugDescription)
                print("Error in photoTableView: \(error!)")
            }
        }
        
        
        return cell
    }

    // query for posts
    func queryPhotos() {
        // parse query
        let query = PFQuery(className:"Photo")
        query.addDescendingOrder("createdAt")
        query.limit = limitSize
        query.findObjectsInBackground { (items: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                if let items = items {
                    var photos: [String] = []
                    for photo in items {
                        photos.append(photo.value(forKey: "objectId") as! String)
                    }
                    self.photos = photos
                    self.photoTableView.reloadData()
                   self.refreshControl.endRefreshing()
                }
            } else {
                // Log details of the failure
                print("Error in queryPhotos: \(error!)")
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
