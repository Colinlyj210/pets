//
//  ReadTableViewCell.swift
//  宠物管家
//
//  Created by lyj on 15/8/29.
//  Copyright © 2015年 lyj. All rights reserved.
//

import UIKit

class ReadTableViewCell: UITableViewCell {
    @IBOutlet weak var lab: UILabel!
    @IBOutlet weak var img: UIImageView!
    private(set) var cellUrl: String!
    var readInfo: ReadInfo?{
        didSet{
            self.img.sd_setImageWithURL(NSURL(string: readInfo!.cellImgUrl), placeholderImage: UIImage(named: "dog"))
            self.lab.text = readInfo!.cellTitle
            self.cellUrl = readInfo?.cellUrl
        }
    }
}
