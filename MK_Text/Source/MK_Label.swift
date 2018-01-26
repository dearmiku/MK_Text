//
//  MK_Label.swift
//  MK_Text
//
//  Created by MBP on 2018/1/26.
//  Copyright © 2018年 MBP. All rights reserved.
//

import Foundation
import CoreGraphics

public class MK_Label:MK_AsyncView{

    ///富文本
    var text:NSMutableAttributedString?



    fileprivate let layout = MK_TextLayout()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLabel()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpLabel()
    }

    fileprivate func setUpLabel(){
        self.setNewTask(task: labelTask)
    }

    //绘制任务
    fileprivate lazy var labelTask = { () -> MK_AsyncTask in
        var task = MK_AsyncTask()
        task.disPlayBlock = {[weak self] (context,size)->() in

            guard self != nil else { return }
            guard let str = self?.text else { return }

            let arr = self!.layout.layout(str: str, drawSize: self!.frame.size)
            for item in arr{
                item.drawInContext(context:context, size: self!.frame.size)
            }

        }
        return task
    }()

}
