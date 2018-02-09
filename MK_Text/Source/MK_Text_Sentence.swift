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
protocol MK_Text_Sentence_Protocol {

    ///绘制大小
    var size:CGSize { get }

    ///在指定context 和 起点(左上角)进行绘制
    func drawInContext(context:CGContext,startCenterPoint:CGPoint)

}

///绘制字句--字符串
class MK_Text_SenTence_String : MK_Text_Sentence_Protocol {

    var str:NSMutableAttributedString

    var size:CGSize

    init(string:NSMutableAttributedString,strSize:CGSize) {
        str = string
        size = strSize
    }

    func drawInContext(context:CGContext,startCenterPoint:CGPoint){

        let frameSetter = CTFramesetterCreateWithAttributedString(str)
        let strSize = str.mk_size
        let y = startCenterPoint.y - strSize.height * 0.5
        let drawRec = CGRect.init(origin: CGPoint.init(x: startCenterPoint.x, y: y), size: strSize)
        let frame = CTFramesetterCreateFrame(frameSetter, CFRange.init(location: 0, length: str.length), CGPath.init(rect: drawRec, transform: nil), nil)
        CTFrameDraw(frame, context)
    }
}



///绘制字句--附件
class MK_Text_SenTence_Accessory : MK_Text_Sentence_Protocol {

    var acc:MK_Accessory

    var size:CGSize

    init(accessory: MK_Accessory, accSize: CGSize){
        acc = accessory
        size = accSize
    }

    func drawInContext(context:CGContext,startCenterPoint:CGPoint){

        let accSize = acc.acc_Size
        switch acc.content! {
        case .image(let(im, _ )):
            let y = startCenterPoint.y - accSize.MK_Accessory_Height*0.5 - accSize.MK_Accessory_Descent
            let rect = CGRect.init(origin: CGPoint.init(x: startCenterPoint.x, y: y), size: size)
            context.draw(im.CGImage, in: rect)

        case .view(let(view, _ , superV)):

            #if os(macOS)
                let y = startCenterPoint.y - accSize.MK_Accessory_Height*0.5 - accSize.MK_Accessory_Descent
            #else
                let y =  superV.getBoundsThreadSafe().height - startCenterPoint.y - accSize.MK_Accessory_Height*0.5 - accSize.MK_Accessory_Descent
            #endif

            let rect = CGRect.init(origin: CGPoint.init(x: startCenterPoint.x, y: y), size: size)

            OperationQueue.main.addOperation {
                view.frame = rect
                superV.addSubview(view)
            }
        }
    }
}


