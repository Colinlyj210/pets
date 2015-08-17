//
//  MsgInfo.swift
//  宠物管家
//
//  Created by lyj on 15/8/17.
//  Copyright © 2015年 lyj. All rights reserved.
//

import Foundation
class MsgInfo {
    private(set) var userImg: String!
    private(set) var userName: String!
    private(set) var time: String!
    private(set) var contentText: String!
    init(userImg: String,userName: String,time: String,contentText: String){
        self.contentText = contentText
        self.userImg = userImg
        self.userName = userName
        self.time = time
    }
}