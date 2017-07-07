//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage
import DateToolsSwift

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var rtOutlet: UIButton!
    @IBOutlet weak var favOutlet: UIButton!
    @IBOutlet weak var replyOutlet: UIButton!
    
    
    
    @IBAction func retweetPressed(_ sender: Any) {
        if !rtOutlet.isSelected{
            rtOutlet.isSelected = true
            tweet.retweeted = true
            tweet.retweetCount += 1
             //Posting information to twitter servers
            APIManager.shared.retweetRequest(tweet) { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else {
                    print("Successfully retweeted the following Tweet: \n\(tweet?.text ?? "")")
                }
            }
        } else{
            rtOutlet.isSelected = false
            tweet.retweeted = false
            tweet.retweetCount -= 1
            APIManager.shared.unRetweetRequest(tweet) { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else {
                    print("Successfully UNretweeted the following Tweet: \n\(tweet?.text ?? "")")
                }
            }
        }
        retweetCountLabel.text = String(tweet.retweetCount)
    }
    
    
    
    @IBAction func favPressed(_ sender: Any) {
        if !favOutlet.isSelected {
            favOutlet.isSelected = true
            tweet.favorited = true
            tweet.favoriteCount += 1
            APIManager.shared.favRequest(tweet) { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else {
                    print("Successfully favorited the following Tweet: \n\(tweet?.text ?? "")")
                }
            }
        } else {
            favOutlet.isSelected = false
            tweet.favorited = false
            tweet.favoriteCount -= 1
            APIManager.shared.unFavRequest(tweet) { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else {
                    print("Successfully UNfavorited the following Tweet: \n\(tweet?.text ?? "")")
                }
            }
        }
        favoriteCountLabel.text = String(tweet.favoriteCount)
       
       
        
    }
    
    
    var tweet: Tweet! {
        didSet {
            tweetTextLabel.text = tweet.text
            nameLabel.text = tweet.user.name
            usernameLabel.text = "@\(tweet.user.screenName)"
            dateLabel.text = tweet.createdAtString
            retweetCountLabel.text = String(tweet.retweetCount)
            favoriteCountLabel.text = String(tweet.favoriteCount)
            profileImageView.af_setImage(withURL: tweet.user.profileImageURL)
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
