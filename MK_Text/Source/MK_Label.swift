//
//  MK_Label.swift
//  MK_Text
//
//  Created by MBP on 2018/1/26.
//  Copyright © 2018年 MBP. All rights reserved.
//

import CoreGraphics
#if os(macOS)
    import AppKit
#else
    import UIKit
#endif



public class MK_Label:MK_AsyncView{

    ///富文本
    public var text:NSMutableAttributedString? {
        didSet{
            self.draw(self.bounds)
        }
    }

    public func reDraw(){
        self.draw(self.bounds)
    }


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

    ///绘制任务
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

    ///获取点击
    fileprivate func clickLabel(point:CGPoint){
        guard let str = text else { return }
        guard let tap = layout.getTapString(point: point) else { return }
        let range = tap.getRangeIn(attStr: str)
        let s = text?.attributedSubstring(from: range!)
        print(range)
        print(s?.string)

        tap.clickBlock(tap.str)
    }
}

#if os(macOS)

    extension MK_Label {
        public override func mouseDown(with event: NSEvent) {
            let location = self.convert(event.locationInWindow, to: nil)
            clickLabel(point: CGPoint.init(x: location.x, y: self.bounds.size.height - location.y))
        }
    }

#else
    extension MK_Label {
        public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let location = touches.first?.location(in: self) else { return }
            clickLabel(point: location)
        }
    }

#endif

