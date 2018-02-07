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

///高亮属性响应
public struct MK_TapResponse {

    public var highlitedBlock : ((_ str:NSAttributedString)->[NSAttributedStringKey : Any]?)

    public var clickBlock : ((_ str:NSAttributedString , _ range:NSRange)->())?


    /// 属性初始化
    ///
    /// - Parameters:
    ///   - highlite: 高亮时回调闭包 返回高亮时属性
    ///   - click: 点击有效完成时回调闭包
    public init(highlite:@escaping (_ str:NSAttributedString)->[NSAttributedStringKey : Any]?,click:@escaping (_ str:NSAttributedString , _ range:NSRange)->()) {
        self.highlitedBlock = highlite
        self.clickBlock = click
    }
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


    /// 向富文本中添加高亮属性~
    ///
    /// - Parameters:
    ///   - response: 响应信息
    ///   - range: 作用范围
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


///点击相关~
extension MK_TextLayout {

    func getTapString(point:CGPoint)->MK_TapStringAttr?{

        guard let arr = lineArray else { return nil }
        guard let line = getLineAt(point: point, arr: arr) else { return nil }

        guard let str = line.getAttrbuteStrAt(point: point) else { return nil }

        guard let res = str.getTapStringAttr() else { return nil }

        return res
    }

    fileprivate func getLineAt(point:CGPoint,arr:[MK_TextLine])->MK_TextLine?{
        guard arr.count != 0 else { return nil }
        var hi = CGFloat(0)
        for line in arr {
            hi += line.lineHeight
            if hi >= point.y{
                return line
            }
        }
        return nil
    }

}

