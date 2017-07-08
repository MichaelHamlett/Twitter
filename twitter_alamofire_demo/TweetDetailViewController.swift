//
//  TweetDetailViewController.swift
//  twitter_alamofire_demo
//
//  Created by Michael Hamlett on 7/5/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class TweetDetailViewController: UIViewController, ComposeViewControllerDelegate {
    @IBOutlet weak var profileImageView: UIImageView!
   
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    @IBOutlet weak var profileButtonOutlet: UIButton!
   
    @IBOutlet weak var rtOutlet: UIButton!
    @IBOutlet weak var favOutlet: UIButton!
    
    
    var tweet: Tweet?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let tweet = tweet {
            let tweetContent = tweet.text
            let username = "@\(tweet.user.screenName)"
            let name = tweet.user.name
            let date = tweet.createdAtString 
            let retweetCount = String(tweet.retweetCount)
            let favoriteCount = String(tweet.favoriteCount)
            let profileImageURL = tweet.user.profileImageURL
            profileImageView.af_setImage(withURL: profileImageURL)
            tweetLabel.text = tweetContent
            screenNameLabel.text = username
            nameLabel.text = name
            dateLabel.text = date
            retweetCountLabel.text = retweetCount
            favoriteCountLabel.text = favoriteCount
        }
        
        
       
        
        
    }


        // Do any additional setup after loading the view.

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func replyButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func retweetButtonPressed(_ sender: Any) {
        if !rtOutlet.isSelected{
            rtOutlet.isSelected = true
            tweet!.retweeted = true
            tweet!.retweetCount += 1
            //Posting information to twitter servers
            APIManager.shared.retweetRequest(tweet!) { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else {
                    print("Successfully retweeted the following Tweet: \n\(tweet?.text ?? "")")
                }
            }
        } else{
            rtOutlet.isSelected = false
            tweet!.retweeted = false
            tweet!.retweetCount -= 1
            APIManager.shared.unRetweetRequest(tweet!) { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else {
                    print("Successfully UNretweeted the following Tweet: \n\(tweet?.text ?? "")")
                }
            }
        }
        retweetCountLabel.text = String(tweet!.retweetCount)
        
    }
    
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        if !favOutlet.isSelected {
            favOutlet.isSelected = true
            tweet!.favorited = true
            tweet!.favoriteCount += 1
            APIManager.shared.favRequest(tweet!) { (tweet: Tweet!, error: Error?) in
                if let error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else {
                    print("Successfully favorited the following Tweet: \n\(tweet!.text )")
                }
            }
        } else {
            favOutlet.isSelected = false
            tweet!.favorited = false
            tweet!.favoriteCount -= 1
            APIManager.shared.unFavRequest(tweet!) { (tweet: Tweet!, error: Error?) in
                if let error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else {
                    print("Successfully UNfavorited the following Tweet: \n\(tweet!.text )")
                }
            }
        }
        favoriteCountLabel.text = String(tweet!.favoriteCount)
        
    }
    
    @IBAction func messageButtonPressed(_ sender: Any) {
        
    }
    
    func did(post: Tweet) {
        print("Replied to tweet")
    }

  
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "replySegue") {
            let vc = segue.destination as! ComposeViewController
            vc.replying = true
            vc.replyTweet = tweet
            vc.delegate = self
        }
        else if (segue.identifier == "otherUser") {
            
            let post = tweet
            let user = post?.user
            let vc = segue.destination as! OtherUserViewController
            vc.user = user
        }
    }
   

}
