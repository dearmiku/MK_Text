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
        let size = self.bounds.size
        let op = BlockOperation.init(block: {
            if task.willDisplayBlock != nil{
                task.willDisplayBlock!(self)
            }
            if task.disPlayBlock != nil {
                #if os(macOS)
                    let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceRGB()
                    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
                    guard let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else {return}
                    task.disPlayBlock!(context,size)
                    let im = context.makeImage()
                    OperationQueue.main.addOperation({
                        self.layer?.contents = im
                    })
                #else
                    UIGraphicsBeginImageContext(size)
                    guard let context = UIGraphicsGetCurrentContext() else {return}
                    context.translateBy(x: 0, y: size.height)
                    context.scaleBy(x: 1.0, y: -1.0)

                    task.disPlayBlock!(context,size)

                    let im = UIGraphicsGetImageFromCurrentImageContext()
                    OperationQueue.main.addOperation{
                        self.layer.contents = im?.cgImage
                    }
                    UIGraphicsEndImageContext()
                #endif
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


    var isAsync:Bool = false

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
