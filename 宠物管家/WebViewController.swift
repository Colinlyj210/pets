//
//  WebViewController.swift
//  宠物管家
//
//  Created by lyj on 15/8/7.
//  Copyright © 2015年 lyj. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var web: UIWebView!
    let url = "http://m.taobao.com"
    override func viewDidLoad() {
        super.viewDidLoad()
        let urls = NSURL(string: url)
        let request = NSURLRequest(URL: urls!)
        web.loadRequest(request)
               // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation
/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        self.hidesBottomBarWhenPushed = false

    }
    */

}
