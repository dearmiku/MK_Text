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
    
    var lineHeight:CGFloat

    var centerOff:CGFloat
    
    func drawInContext(context:CGContext,size:CGSize){
        var startX = lineStartCenterPoint.x
        for item in sentenceArr {
            let size = item.size
            item.drawInContext(context: context, startCenterPoint: CGPoint.init(x: startX, y: lineStartCenterPoint.y - centerOff))
            startX += size.width
        }
    }
}

extension MK_TextLine {
    
    func getAttrbuteStrAt(point:CGPoint)->NSAttributedString?{
        var wi = CGFloat(0.0)
        for item in sentenceArr {
            if wi + item.size.width >= point.x && point.x > wi && item is MK_Text_SenTence_String{
                let str = (item as! MK_Text_SenTence_String).str
                let framesetter = CTFramesetterCreateWithAttributedString(str)
                let frame = CTFramesetterCreateFrame(framesetter, CFRange.init(location: 0, length: str.length), CGPath.init(rect: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: INTPTR_MAX, height: INTPTR_MAX)), transform: nil), nil)
                let line = unsafeBitCast(CFArrayGetValueAtIndex(CTFrameGetLines(frame), 0), to: CTLine.self)
                let clickPoint = CGPoint.init(x: point.x - wi, y: (str.mk_size.height)*0.5)
                let starIndex = CTLineGetStringIndexForPosition(line, clickPoint)
                guard starIndex + 1 <= (str.string as NSString).length else { return nil }
                let res = str.attributedSubstring(from: NSRange.init(location: starIndex, length: 1))
                return res
            }
            wi += item.size.width
        }
        return nil
    }
}

