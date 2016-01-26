//
//  AddCommentDelegate.swift
//  shaurmApp
//
//  Created by Tim Galiullin on 2016-01-22.
//  Copyright © 2016 NikolaevIgor. All rights reserved.
//

import Foundation

protocol AddCommentDelegate{
    func addCommentDidFinish(addCommentText:String,controller:addCommentVC)
}

protocol StarViewDelegate{
    func dismissStarView(controller:AnyObject)
}