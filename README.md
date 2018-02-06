# MK_Text

# 简介
**MK_Text**是方便开发者使用富文本的纯Swift框架,目标向YYText看齐,功能会在后续逐渐丰富,目前实现了Label的基本功能~ (๑•ᴗ•๑)

# 特性
> 支持图文混排,支持富文本与View混排
> 支持异步排版渲染
> 支持高亮文字设置
> 支持OSX 与 iOS

# 用法
## 图文混排

可自定义图片显示大小,默认显示图片原始大小~

可是设置图片与其所在子行的对其方式,默认为与字行中线一致~

```
        let imStr = NSMutableAttributedString.mk_image(im: MK_Image.init(named: NSImage.Name.init("face"))!, size: CGSize.init(width: 30, height: 30), alignType: NSMutableAttributedString.AlignType.top)
        
        //控件的用法与图片基本一致
        
        let v = UISwitch.init()
        let viewStr = NSMutableAttributedString.mk_view(view: v, superView: ml, size: v.bounds.size)
        
```



## 高亮文字

使用高亮属性时需先创建**MK_TapResponse**结构体,可选返回两个闭包: 1,高亮时的富文本属性~ 2,完成点击时回调的闭包~

这里判断点击是否完成的逻辑与Button一致~

```

        let tap = NSMutableAttributedString.init(string: "可点击字符")
        let response = MK_TapResponse.init(highlitedBlock: { (str) -> [NSAttributedStringKey : Any]? in
            return [NSAttributedStringKey.foregroundColor : UIColor.red]
        }) { (str, range) in
            print("点击字符串~")
        }
        tap.addTapAttr(response: response, range: nil)
```

## 异步渲染
通过设置 Label的**isAsync**属性来确定~ 默认为false


## 使用注意
### 中途修改富文本属性
若需要在修改富文本属性的同事刷新UI界面,请使用下面这个方法

```
public func mk_setAttrtbute(dic:[NSAttributedStringKey : Any], range: NSRange)->Void
```


# 安装
## CocoaPods
在 Podfile 中添加 pod 'MK_Text'


# 系统要求
OSX 10.10 或 iOS 8.0

