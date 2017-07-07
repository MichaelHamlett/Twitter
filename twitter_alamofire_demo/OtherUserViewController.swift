//
//  OtherUserViewController.swift
//  twitter_alamofire_demo
//
//  Created by Michael Hamlett on 7/7/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class OtherUserViewController: UIViewController,UITableViewDataSource, UITableViewDelegate{

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
    var user : User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        //tableView.tableHeaderView = header
        
        APIManager.shared.userTimeline(user: user!) { (tweets: [Tweet]?, error: Error?) in
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
        //allows us to get the indexpath.row for the replybutton
        cell.replyOutlet.tag = indexPath.row
        cell.profileButtonOutlet.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
