//
//  MK_AsyncTask.swift
//  MK_Text
//
//  Created by MBP on 2018/1/22.
//  Copyright © 2018年 MBP. All rights reserved.
//

import Foundation
import CoreGraphics

struct MK_AsyncTask{

    var willDisplayBlock:((_ layer:MK_AsyncView)->())?

    var disPlayBlock:(()->CGImage?)?

    var didDisplaBlocky:((_ layer:MK_AsyncView)->())?

    var isCancel:Bool = false

    init() {
        willDisplayBlock = nil
        disPlayBlock = nil
        disPlayBlock = nil
    }
}


