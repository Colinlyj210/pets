//
//  updateTableViewCell.swift
//  宠物管家
//
//  Created by lyj on 15/8/17.
//  Copyright © 2015年 lyj. All rights reserved.
//

import UIKit

class updateTableViewCell: UITableViewCell {
    
    var selectTag = 0

    @IBOutlet weak var title: UILabel!
    @IBOutlet var btn: [RadioButton]!
    @IBAction func chooseBtn(sender: RadioButton) {
        sender.setImage(UIImage(named: "radio_checked"), forState: UIControlState.Selected)
        sender.setTitleColor(UIColor.blueColor(), forState: UIControlState.Selected)
        selectTag = sender.tag
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btn[0].tag = 5
        btn[1].tag = 3
        btn[2].tag = 1

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
