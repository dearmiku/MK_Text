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
class MK_TextLine{
    
    var sentenceArr:[MK_Text_Sentence_Protocol]
    ///绘制起始中心点(CenterY)
    var lineStartCenterPoint:CGPoint
    ///绘制行高
    var lineHeight:CGFloat
    ///绘制中心点偏差(CenterY_Off)
    var centerOff:CGFloat
    ///绘制X偏差
    var xOff:CGFloat = CGFloat(0)

    init(sentArr:[MK_Text_Sentence_Protocol],startCenterPoint:CGPoint,lineHeight:CGFloat,centerOff:CGFloat) {
        self.sentenceArr =  sentArr
        self.lineStartCenterPoint = startCenterPoint
        self.lineHeight = lineHeight
        self.centerOff = centerOff
    }


    func drawInContext(context:CGContext,size:CGSize){
        var startX = lineStartCenterPoint.x + xOff
        for item in sentenceArr {
            let size = item.size
            item.drawInContext(context: context, startCenterPoint: CGPoint.init(x: startX, y: lineStartCenterPoint.y - centerOff))
            startX += size.width
        }
    }
}

extension MK_TextLine {
    
    func getAttrbuteStrAt(point:CGPoint)->NSAttributedString?{
        var wi = CGFloat(xOff)
        for item in sentenceArr {
            if wi + item.size.width >= point.x && point.x > wi && item is MK_Text_SenTence_String{
                let str = (item as! MK_Text_SenTence_String).str
                let framesetter = CTFramesetterCreateWithAttributedString(str)
                let frame = CTFramesetterCreateFrame(framesetter, CFRange.init(location: 0, length: str.length), CGPath.init(rect: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: INTPTR_MAX, height: INTPTR_MAX)), transform: nil), nil)
                let line = unsafeBitCast(CFArrayGetValueAtIndex(CTFrameGetLines(frame), 0), to: CTLine.self)
                let clickPoint = CGPoint.init(x: point.x - wi, y: (str.mk_size.height)*0.5)
                var starIndex = CTLineGetStringIndexForPosition(line, clickPoint)

                if starIndex == (str.string as NSString).length {
                    starIndex -= 1
                }
                let res = str.attributedSubstring(from: NSRange.init(location: starIndex, length: 1))
                return res
            }
            wi += item.size.width
        }
        return nil
    }
}

