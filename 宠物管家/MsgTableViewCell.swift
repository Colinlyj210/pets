//
//  MsgTableViewCell.swift
//  宠物管家
//
//  Created by lyj on 15/8/17.
//  Copyright © 2015年 lyj. All rights reserved.
//

import UIKit

class MsgTableViewCell: UITableViewCell {
    @IBOutlet weak var contentText: UITextView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImg: UIImageView!
    var msgInfo: MsgInfo?{
        didSet{
            configCell()
        }
    }
    private func configCell(){
        contentText.text = msgInfo?.contentText
        time.text = msgInfo?.time
        userName.text = msgInfo?.userName
        userImg.image = UIImage(named: (msgInfo?.userImg)!)
    }
}
