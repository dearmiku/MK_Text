# MK_Text
[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/dearmiku/MK_Text/master/LICENSE) [![Support](https://img.shields.io/badge/support-iOS%208%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/) [![Support](https://img.shields.io/badge/support-OSX%2010.10%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/macos) [![CocoaPods](https://img.shields.io/cocoapods/p/MK_Text.svg?style=flat)]()

# 简介
**MK_Text**是方便开发者使用富文本的纯Swift框架,目标向YYText看齐,功能会在后续逐渐丰富,目前实现了Label的基本功能~ (๑•ᴗ•๑)

# 特性
> 支持图文混排,支持富文本与View混排
> 
> 支持异步排版渲染
> 
> 支持高亮文字设置
> 
> 支持OSX 与 iOS
> 
> 支持自动布局

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

## 效果
目前只实现了上述的功能,其他功能会在后续丰富~

![iOS效果图](https://raw.githubusercontent.com/dearmiku/MK_Text/master/Image/iOS%E6%95%88%E6%9E%9C%E5%9B%BE.gif)


![OSX效果图](https://raw.githubusercontent.com/dearmiku/MK_Text/master/Image/OSX%E6%95%88%E6%9E%9C%E5%9B%BE.gif)


## 异步渲染
通过设置 Label的**isAsync**属性来确定~ 默认为false


## 使用注意
### 中途修改富文本属性
若需要在修改富文本属性的同时刷新UI界面,请使用下面这个方法

```
public func mk_setAttrtbute(dic:[NSAttributedStringKey : Any], range: NSRange)->Void
```

### 自动布局

**MK_Text**对于自动约束的支持是参照**UILabel**来做的, 当View的**translatesAutoresizingMaskIntoConstraints**为true时, 则按照View的frame进行渲染. 

若为false,则会判断约束是否约束到宽高, 若约束到 则按约束的宽高进行渲染,若未约束到,则会根据渲染内容来补充宽高约束~

**MK_Text**也提供了限制补充的最大高度和宽度~

```
/// 限制填充的最大宽度,当到达时会自动换行
public var layoutMaxWidth:CGFloat 

/// 限制填充的最大高度,当到达时将不再绘制
public var layoutMaxHight:CGFloat


```



# 安装
## CocoaPods
在 Podfile 中添加 pod 'MK_Text'


# 系统要求
OSX 10.10 或 iOS 8.0

