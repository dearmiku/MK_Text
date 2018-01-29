//
//  MK_TextLine.swift
//  MK_Text
//
//  Created by MBP on 2018/1/26.
//  Copyright © 2018年 MBP. All rights reserved.
//

import Foundation
import CoreGraphics
import CoreText


///绘制字行~
struct MK_TextLine{

    var sentenceArr:[MK_Text_Sentence_Protocol]

    var lineStartCenterPoint:CGPoint

    func drawInContext(context:CGContext,size:CGSize){
        var startX = lineStartCenterPoint.x
        for item in sentenceArr {
            let size = item.size
            item.drawInContext(context: context, startCenterPoint: CGPoint.init(x: startX, y: lineStartCenterPoint.y))
            startX += size.width
        }
    }

}



