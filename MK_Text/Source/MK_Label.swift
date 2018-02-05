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

    ///布局
    let layout = MK_TextLayout()
    ///点击
    lazy var tapManager = MK_TapManager()


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

    ///按下~~
    fileprivate func tapDownAt(point:CGPoint){
        tapManager.tapDownAt(point: point, view: self)
    }
    ///抬起
    fileprivate func tapUpAt(point:CGPoint){
        tapManager.tapUpAt(point: point, view: self)
    }
}

#if os(macOS)

    extension MK_Label {
        public override func mouseDown(with event: NSEvent) {
            let location = self.convert(event.locationInWindow, to: nil)
            tapDownAt(point: CGPoint.init(x: location.x, y: self.bounds.size.height - location.y))
        }

        public override func mouseUp(with event: NSEvent) {
            let location = self.convert(event.locationInWindow, to: nil)
            tapUpAt(point: CGPoint.init(x: location.x, y: self.bounds.size.height - location.y))
        }
    }

#else
    extension MK_Label {
        public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let location = touches.first?.location(in: self) else { return }
            tapDownAt(point: location)
        }
    }

#endif

