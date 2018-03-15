//
//  MK_AsyncView.swift
//  MK_Text
//
//  Created by MBP on 2018/1/23.
//  Copyright © 2018年 MBP. All rights reserved.
//

#if os(macOS)
    import AppKit
#else
    import UIKit
#endif


public class MK_AsyncView: MK_View {

    override public func draw(_ rect: CGRect) {
        guard let task = self.drawTask else {
            return
        }
        let op = BlockOperation.init(block: {
            if task.willDisplayBlock != nil{
                task.willDisplayBlock!(self)
            }
            if task.disPlayBlock != nil {

                let im = task.disPlayBlock!()
                OperationQueue.main.addOperation({
                    #if os(macOS)
                        self.layer?.contents = im
                    #else
                        self.layer.contents = im
                    #endif
                })
            }
            if task.didDisplaBlocky != nil{
                task.didDisplaBlocky!(self)
            }
        })
        if isAsync{
            DrawOPSetAddOperation(op: op)
        }else{
            OperationQueue.main.addOperation(op)
        }
    }



    ///是否异步绘制~
    public var isAsync:Bool = false

    fileprivate var drawTask:MK_AsyncTask?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }

    func setUpView(){
        _ = MK_RunTimeRuntimeObserver.share
        #if os(macOS)
            self.wantsLayer = true
        #endif

    }

    func setNewTask(task:MK_AsyncTask){
        if var cancelTask = drawTask{
            cancelTask.isCancel = false
        }
        self.drawTask = task
    }
}
