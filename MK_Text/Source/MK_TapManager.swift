//
//  MK_TapManager.swift
//  MK_Text
//
//  Created by MBP on 2018/2/5.
//  Copyright © 2018年 MBP. All rights reserved.
//

import Foundation


class MK_TapManager {

    var currentTapAtt:MK_TapStringAttr?

    var currentAttStr:NSMutableAttributedString?

    func tapDownAt(point:CGPoint,view:MK_Label){

        guard let str = view.text else { return }
        guard let tap = view.layout.getTapString(point: point) else { return }
        currentTapAtt = tap

        guard let range = tap.getRangeIn(attStr: str) else { return }
        guard let hiAtt = tap.response.highlitedBlock(str) else { return }
        currentAttStr = NSMutableAttributedString.init(attributedString: str)

        str.addAttributes(hiAtt, range: range)
        view.draw(view.bounds)

    }

    func tapUpAt(point:CGPoint,view:MK_Label){

        guard let str1 = currentAttStr else { return }
        view.text = str1
        view.draw(view.bounds)


        guard let tap1 = currentTapAtt else { return }
        guard let tapNow = view.layout.getTapString(point: point) else { return }
        guard let range = tap1.getRangeIn(attStr: str1) else { return }
        if tap1.id == tapNow.id {
            tapNow.response.clickBlock?(str1,range)
        }


    }

}
