
//
//  ReadInfo.swift
//  宠物管家
//
//  Created by lyj on 15/8/29.
//  Copyright © 2015年 lyj. All rights reserved.
//

import Foundation
class ReadInfo {
    private(set) var cellImgUrl: String!
    private(set) var cellTitle: String!
    private(set) var cellUrl: String!
    init(cellImgUrl: String,cellTitle: String,cellUrl: String){
        self.cellImgUrl = cellImgUrl
        self.cellTitle = cellTitle
        self.cellUrl = cellUrl
    }
}