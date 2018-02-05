//
//  MK_TapString.swift
//  MK_Text
//
//  Created by MBP on 2018/1/30.
//  Copyright © 2018年 MBP. All rights reserved.
//

#if os(macOS)
    import AppKit
#else
    import UIKit
#endif

public typealias MK_TapString_Block = (_ str:NSAttributedString)->()


public struct MK_TapResponse {

    public var highlitedBlock : ((_ str:NSAttributedString)->[NSAttributedStringKey : Any]?)

    public var clickBlock : ((_ str:NSAttributedString , _ range:NSRange)->())?

}


///可点击富文本
class MK_TapStringAttr : NSObject {

    static let AttributeKey = "MK_TapStringAttr_Key"

    var response:MK_TapResponse!

    var id:Int = Int(NSDate.init().timeIntervalSince1970)

    ///获取在指定富文本中的Range
    func getRangeIn(attStr:NSAttributedString)->NSRange?{

        var res:NSRange? = nil
        attStr.enumerateAttributes(in: attStr.range, options: NSAttributedString.EnumerationOptions.init(rawValue: 1)) { (dic, range, isCancel) in
            if let att = dic[NSAttributedStringKey.init(MK_TapStringAttr.AttributeKey)] as? MK_TapStringAttr {
                if att.id == self.id{
                    if res == nil {
                        res = range
                    }else {
                        if range.location < res!.location {
                            res?.location = range.location
                        }
                        if range.length + range.location > res!.length + res!.location {
                            res!.length = range.length + range.location - res!.location
                        }
                    }
                }
            }
        }
        return res
    }

}

public extension NSMutableAttributedString {

    ///向富文本添加剪辑属性~ range为nil 则对整个富文本添加
    func addTapAttr(response:MK_TapResponse, range:NSRange?){
        let addRange = range != nil ? range! : self.range
        let att = MK_TapStringAttr()
        att.response = response
        self.addAttributes([NSAttributedStringKey.init(MK_TapStringAttr.AttributeKey) : att], range: addRange)

        #if os(macOS)
        if self.getAttributeValue(name: NSAttributedStringKey.font) == nil {

            self.addAttribute(NSAttributedStringKey.font, value: NSFont.systemFont(ofSize: 10), range: self.range)
        }
        #endif

    }

}

extension NSAttributedString {

    func getTapStringAttr()->MK_TapStringAttr? {
        let res:MK_TapStringAttr? = self.getAttributeValue(name: NSAttributedStringKey.init(MK_TapStringAttr.AttributeKey))
        return res
    }
}


