//
//  ComposeViewController.swift
//  twitter_alamofire_demo
//
//  Created by Michael Hamlett on 7/5/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

protocol ComposeViewControllerDelegate {
    func did(post: Tweet)
}

class ComposeViewController: UIViewController, UITextViewDelegate {
    
    var replying = false
    var replyTweet: Tweet?
    
    var delegate : ComposeViewControllerDelegate?
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var keyboardToolbar: UIToolbar!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var characterLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        textView.delegate = self
        
        textView.text = "What's happening?"
        textView.textColor = UIColor.lightGray
        self.textView.becomeFirstResponder()
        
        let user = User.current
        let url = user?.profileImageURL
        profileImageView.af_setImage(withURL: url!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "What's happening?"
            textView.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func tweetButtonPressed(_ sender: Any) {
        if replying {
            APIManager.shared.replyToTweet(replyingTo: replyTweet!, with: textView.text, completion: { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print("Error composing Tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    self.delegate?.did(post: tweet)
                    print("Compose Tweet Success!")
                }
            })
            replying = false
        }
         else {
            APIManager.shared.composeTweet(with: textView.text) { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print("Error composing Tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    self.delegate?.did(post: tweet)
                    print("Compose Tweet Success!")
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    */
    
    

}
