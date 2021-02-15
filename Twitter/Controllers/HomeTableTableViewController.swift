//
//  HomeTableTableViewController.swift
//  Twitter
//
//  Created by Marty Nodado on 2/12/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class HomeTableTableViewController: UITableViewController {

    var tweetArray = [NSDictionary]()
    var numberOfTweets: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets()
        
    }

    func loadTweets() {
        
        let apiUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let params = ["count": 15]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: apiUrl, parameters: params, success: { (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData()
            
        }, failure: { (Error) in
            print("Could nto retrieve tweets!")
        })
        
    }
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout() // actually logs out from Twitter
        
        self.dismiss(animated: true, completion: nil) // animation for leaving Home screen
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        
        // Name Preparation
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        let screenName = user["screen_name"] as? String
        
        // Image Preparation
        let imageURL = URL(string: ((user["profile_image_url_https"] as? String)!))
        let data = try? Data(contentsOf: imageURL!)
        
        // API to app
        cell.usernameLabel.text = user["name"] as? String
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        cell.screenNameLabel.text = "@" + screenName!
        
        if let imageData = data {
            cell.profileImage.image = UIImage(data: imageData)
        }
        
        return cell
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
