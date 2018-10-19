//
//  HomeViewController.swift
//  GroupProject
//
//  Created by SiuChun Kung on 10/17/18.
//  Copyright © 2018 SiuChun Kung. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    var posts: [PFObject] = []
    var refreshControl:UIRefreshControl!
    var alertController = UIAlertController()
    
    @IBOutlet weak var captionField: UITextView!
    @IBOutlet weak var uploadImage: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        fetchPost()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        cell.instagramPost = posts[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func fetchPost(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let query = Post.query()
        query?.order(byDescending: "createdAt")
        query?.includeKey("author")
        query?.limit = 20
        
        query?.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else if let posts = posts {
                self.posts = posts
                
            }
            self.tableView.reloadData()
        }
        self.refreshControl.endRefreshing()
        MBProgressHUD.hide(for: self.view, animated: true)
    }

    @objc func refreshControlAction(_ refreshControl: UIRefreshControl){
        fetchPost()
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        //Parse has a limit of 10MB for uploading photos so you'll want to the code snippet below to resize the image before uploading to Parse.
        uploadImage.image = info[UIImagePickerControllerEditedImage] as! UIImage?
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOutInBackground(block: { (error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Successful loggout")
                self.performSegue(withIdentifier: "logoutSegue", sender: nil)
                
            }
        })
    }
    
    @IBAction func selectImage(_ sender: Any) {
        //Instantiate a UIImagePickerController
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            vc.sourceType = .photoLibrary
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func onUpload(_ sender: Any) {
        Post.postUserImage(image: uploadImage.image, withCaption: captionField.text, withCompletion:
            {
                (success: Bool, error: Error?) -> Void in
                DispatchQueue.main.async
                    {
                        if (success) {
                            self.alertController = UIAlertController(title: "Success", message: "Image Successfully Uploaded", preferredStyle: .alert)
                            let cancelAction = UIAlertAction(title: "Ok", style: .cancel) { (action) in
                                // handle cancel response here. Doing nothing will dismiss the view.
                            }
                            let image = UIImage(named: "image_placeholder")
                            self.uploadImage.image = image
                            self.captionField.text = "write something..."
                            self.alertController.addAction(cancelAction)
                            DispatchQueue.global().async(execute: {
                                DispatchQueue.main.sync{
                                    self.present(self.alertController, animated: true, completion: nil)
                                    
                                }
                            })
                     
                }
                        else {
                            // There was a problem, check error.description
                            self.alertController = UIAlertController(title: "Error", message: "\(error?.localizedDescription)", preferredStyle: .alert)
                            let cancelAction = UIAlertAction(title: "Ok", style: .cancel) { (action) in
                                // handle cancel response here. Doing nothing will dismiss the view.
                            }
                            self.alertController.addAction(cancelAction)
                            DispatchQueue.global().async(execute: {
                                DispatchQueue.main.sync{
                                    self.present(self.alertController, animated: true, completion: nil)
                                    
                                }
                            })
                        }
                        
                }
        })
    }
    
    
    @IBAction func toChatRoom(_ sender: Any) {
        self.performSegue(withIdentifier: "chatroomSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let cell = sender as? UITableViewCell {
        if let indexPath = tableView.indexPath(for: cell){
            let post = posts[indexPath.row]
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.post = post
            }
        } else if segue.identifier == "chatroomSegue"{
            if let cell = sender as? UITableViewCell {
            if let indexPath = tableView.indexPath(for: cell){
                let post = posts[indexPath.row]
                let detailViewController = segue.destination as! ChatRoomViewController
                detailViewController.post = post
                }
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
