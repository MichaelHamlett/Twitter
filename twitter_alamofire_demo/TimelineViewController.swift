//
//  TimelineViewController.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ComposeViewControllerDelegate, UIScrollViewDelegate {
    
    var tweets: [Tweet] = []
    var isMoreDataLoading = false
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        loadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isMoreDataLoading {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging && APIManager.shared.homeTimelineCount < 101) {
                isMoreDataLoading = true
                APIManager.shared.homeTimelineCount += 5
                loadData()
                
            }
        }
    }
    
    func loadData() {
        APIManager.shared.getHomeTimeLine { (tweets, error) in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
                self.isMoreDataLoading = false
            } else if let error = error {
                print("Error getting home timeline: " + error.localizedDescription)
            }
        }
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        loadData()
        refreshControl.endRefreshing()
    }
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didTapLogout(_ sender: Any) {
        APIManager.shared.logout()
    }
    
    func did(post: Tweet) {
        print("Tweet posted")
    }
    
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TweetDetailSegue" {
            let cell = sender as! UITableViewCell
            
            if let indexPath = tableView.indexPath(for: cell){
                let post = tweets[indexPath.row]
                let tweetDetailViewController = segue.destination as! TweetDetailViewController
                tweetDetailViewController.tweet = post
            }
        }
        else if (segue.identifier == "ComposeViewSegue") {
            let vc = segue.destination as! ComposeViewController
            vc.delegate = self
        }
        else if (segue.identifier == "replySegue") {
            let button = sender as! UIButton
            
            //indexpath of button set in tableview cellForRowAt
            let indexPath = button.tag
            let post = tweets[indexPath]
            let vc = segue.destination as! ComposeViewController
            vc.replyTweet = post
            vc.replying = true
            vc.delegate = self
            
        }
    }
    
    
    
    
    
}
