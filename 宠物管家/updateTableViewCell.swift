//
//  updateTableViewCell.swift
//  宠物管家
//
//  Created by lyj on 15/8/17.
//  Copyright © 2015年 lyj. All rights reserved.
//

import UIKit

class updateTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!//cell的标题
    @IBOutlet var btn: [RadioButton]!//cell的按钮数组
    @IBAction func chooseBtn(sender: RadioButton) {
        //被点击了即选中状态就改变图片和字体颜色
        sender.setImage(UIImage(named: "radio_checked"), forState: UIControlState.Selected)
        sender.setTitleColor(UIColor.blueColor(), forState: UIControlState.Selected)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //定义每个按钮的tag
        btn[0].tag = 5
        btn[1].tag = 3
        btn[2].tag = 1
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
