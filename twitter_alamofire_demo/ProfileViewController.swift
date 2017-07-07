//
//  ProfileViewController.swift
//  twitter_alamofire_demo
//
//  Created by Michael Hamlett on 7/6/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
   
    @IBOutlet weak var segmentView: UIView!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    var tweets: [Tweet] = []
    let user = User.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        //tableView.estimatedSectionHeaderHeight = 40
        //self.automaticallyAdjustsScrollViewInsets = false
        tableView.tableHeaderView = header
        
        
        APIManager.shared.userTimeline(user: User.current!) { (tweets: [Tweet]?, error: Error?) in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
            }
            else if let error = error {
                print("Error getting Profile timeline: " + error.localizedDescription)
            }
        }
        
        if let user = user{
            if user.profileBackgroundURLString != "" {
                let profileBackgroundURL = URL(string: user.profileBackgroundURLString)!
                bannerImageView.af_setImage(withURL: profileBackgroundURL)
            }
            profileImageView.af_setImage(withURL: user.profileImageURL)
            nameLabel.text = user.name
            usernameLabel.text = "@\(user.screenName)"
            bioLabel.text = user.bio
            followingCountLabel.text = "\(user.followingCount)"
            followersCountLabel.text = "\(user.followersCount)"
        }
        
        
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = UIView()
//        view.backgroundColor = UIColor.white
//        let segmentedControl = UISegmentedControl(frame: CGRect(x: 10, y: 5, width: tableView.frame.width - 20, height: 30))
//        segmentedControl.insertSegment(withTitle: "Tweets", at: 0, animated: false)
//        segmentedControl.insertSegment(withTitle: "Media", at: 1, animated: false)
//        segmentedControl.insertSegment(withTitle: "Favorites", at: 2, animated: false)
//        view.addSubview(segmentedControl)
//        return view
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
        //allows us to get the indexpath.row for the replybutton
        cell.replyOutlet.tag = indexPath.row
        
        return cell
        
    }
    

   
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TweetDetailSegue" {
            let cell = sender as! UITableViewCell
            
            if let indexPath = tableView.indexPath(for: cell){
                let post = tweets[indexPath.row]
                let tweetDetailViewController = segue.destination as! TweetDetailViewController
                tweetDetailViewController.tweet = post
            }
        }
    }
    

}
