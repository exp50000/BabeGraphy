//
//  followerVC.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/7/6.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import PMAlertController
import Haneke

// 要顯示 storyBoardId
var show:String?

class followersVC: UITableViewController {
    
    
    var usernameArray = [String]()
    
    // 離線快取
    let cache = Shared.dataCache
    
    // 追蹤中 or 追蹤者 資料的json陣列
    // haneke 跟 swifty json 一定會衝突 要明確宣告類別 並直接實體化
    // var follow = [JSON]()
    var follow: Array<SwiftyJSON.JSON> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = show?.uppercaseString
        
        if show == "followers"{
            loadFollowers()
        }
        
        if show == "followings"{
            loadFollowings()
        }
        
        
    }
    
    // MARK: - Customer function
    func loadFollowers(){
        
        
        
    }
    
    
    func loadFollowings(){
        
        guard let AccessToken = NSUserDefaults.standardUserDefaults().stringForKey("AccessToken") else{ return }
        
        Alamofire.request(.POST, "http://140.136.155.143/api/connection/search_following",parameters: ["token":AccessToken]).validate().responseJSON { (response) in
            
            switch response.result{
                
            case .Success(let json):
                
                print(json)
                
                let json = SwiftyJSON.JSON(json)
                
                // 走訪陣列
                for (_,subJson):(String, SwiftyJSON.JSON) in json {
                    
                    print(subJson["user_to_id"].string)
                    self.follow.append(subJson)
                    
                }
                
                self.tableView.reloadData()
                
            case .Failure(let error):
                
                let alertVC = PMAlertController(title: "抱歉發生了某些問題", description: error.localizedDescription , image: UIImage(named: "error.png"), style: .Alert)
                alertVC.addAction(PMAlertAction(title: "OK", style: .Default, action: nil))
                self.presentViewController(alertVC, animated: true, completion: nil)
                
            }
        }
        
    }
    
    
    // MARK: - Table view data source
    
    // cell height
    //    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //        //  320 / 4 = 80
    //        return self.view.frame.size.width / 4
    //    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  follow.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! followersCell
        
        cell.usernameLbl.text = follow[indexPath.item]["user_to_id"].string
        
        cell.avaImg.hnk_setImageFromURL(NSURL(string: "http://www.sitesnobrasil.com/imagens-fotos/mulheres/l/lisa-simpson.png")!)
        

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
    
    
    
}