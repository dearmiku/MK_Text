//
//  MK_Text_Sentence.swift
//  MK_Text_iOS
//
//  Created by MBP on 2018/1/29.
//  Copyright © 2018年 MBP. All rights reserved.
//

import Foundation
import CoreGraphics
import CoreText

///绘制字句协议
protocol MK_Text_Sentence_Protocol : NSObjectProtocol {

    ///绘制大小
    var size:CGSize! { get }

    ///在指定context 和 起点(左上角)进行绘制
    func drawInContext(context:CGContext,startPoint:CGPoint)

}

///绘制字句--字符串
class MK_Text_SenTence_String : NSObject, MK_Text_Sentence_Protocol {

    var str:NSMutableAttributedString!

    var size:CGSize!

    func drawInContext(context:CGContext,startPoint:CGPoint){
        let frameSetter = CTFramesetterCreateWithAttributedString(str)
        let drawRec = CGRect.init(origin: startPoint, size: size)
        let frame = CTFramesetterCreateFrame(frameSetter, CFRange.init(location: 0, length: str.length), CGPath.init(rect: drawRec, transform: nil), nil)
        CTFrameDraw(frame, context)
    }

}

///绘制字句--附件
class MK_Text_SenTence_Accessory : NSObject, MK_Text_Sentence_Protocol {

    var acc:MK_Accessory!

    var size:CGSize!

    func drawInContext(context:CGContext,startPoint:CGPoint){

        let rect = CGRect.init(origin: startPoint, size: size)
        switch acc.content! {
        case .image(let(im, _ )):
            context.draw(im.CGImage, in: rect)

        case .view(let(view, _ , superV)):
            OperationQueue.main.addOperation {
                view.frame = rect
                superV.addSubview(view)
            }
        }
    }

}
