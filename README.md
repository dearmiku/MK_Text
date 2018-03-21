# MK_Text
[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/dearmiku/MK_Text/master/LICENSE) [![Support](https://img.shields.io/badge/support-iOS%208%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/) [![Support](https://img.shields.io/badge/support-OSX%2010.10%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/macos) [![CocoaPods](https://img.shields.io/cocoapods/p/MK_Text.svg?style=flat)](https://github.com/dearmiku/MK_Text)

# Introduction
**MK_Text** is a pure Swift framework that makes it easy for developers to use rich text. The goal is to align with YYText. The function will be gradually enriched in the future. Currently, the basic functions of Label are realized.~ (๑•ᴗ•๑) The last thing to say is that my English is not very good. Please forgive me.[中文文档](https://github.com/dearmiku/MK_Text/blob/master/Doc_CN/README_CN.md)



# Features
> Support picture and text mixing, support rich text and View mixed
>
> Support for asynchronous typographic rendering
>
> Support highlight text settings
>
> Support OSX and iOS
>
> Supports automatic layout
> 
> 

# Usage
## Photo-text

Can customize the picture display size, the default display picture original size ~

Can set the picture and its sub-line of its way, the default is consistent with the middle line of the word ~
```
        let imStr = NSMutableAttributedString.mk_image(im: MK_Image.init(named: NSImage.Name.init("face"))!, size: CGSize.init(width: 30, height: 30), alignType: NSMutableAttributedString.AlignType.top)
        
        //Set the View method and set the picture basically the same
                
        let v = UISwitch.init()
        let viewStr = NSMutableAttributedString.mk_view(view: v, superView: ml, size: v.bounds.size)
        
```



## Highlighted text

When using the highlighting attribute, first create a **MK_TapResponse** structure and return two optional closures: 1. Rich text attribute when highlighted ~ 2. Closed callback closure when clicked.

Here's the logic to determine whether the click is complete is consistent with Button's touchUpInside~

```

        let tap = NSMutableAttributedString.init(string: "Clickable character")
        let response = MK_TapResponse.init(highlitedBlock: { (str) -> [NSAttributedStringKey : Any]? in
            return [NSAttributedStringKey.foregroundColor : UIColor.red]
        }) { (str, range) in
            print("Click on the string~")
        }
        tap.addTapAttr(response: response, range: nil)
```

## Alignment

Set by the alignment property of **MK_Label** (default is left-aligned), here centered for example
 <img src="https://github.com/dearmiku/MK_Text/blob/master/Image/%E5%B1%85%E4%B8%AD%E5%AF%B9%E9%BD%90.png?raw=true" width = "300"  alt="居中对齐效果图" align=center />


## Advance line break
For better reading results, sometimes we need to wrap early, otherwise a complete word will be displayed in two lines, just like **UILable**. I provide the following attributes to achieve this effect

```
     ///Decide whether to perform premature line break condition closure
     /// Argument 1: Rich text to be drawn by Label
     /// Argument 2: subscript of the character at the end of the line
     ///Default does not advance line break
    var makeNewLineEarlyConditionBlock:((NSAttributedString,Int)->(Bool)) = {(str,index)->Bool in
        return false
    }

   /// array of word separators (single characters)
    var wordSeparatorArr:[String] = [" "]
```
The `wordSeparatorArr` array stores word separators. The default array contains only one " " (space) element. Just like **UILabel**, different words are separated by spaces.

`makeNewLineEarlyConditionBlock`: When the line is to be wrapped, if there is a word split into two lines, the closure will be called back to determine if the line should be prepended, because for Chinese, Japanese, there is no such a Words are displayed in two lines, where the user can handle it according to his actual situation.

### Effect Display

1, Did not use early line breaks

 <img src="https://raw.githubusercontent.com/dearmiku/MK_Text/master/Image/makeNewLine1.png" width = "300"  alt="未提前换行效果图" align=center />

2, the use of early line breaks (delimiter "", the closure directly returns `true`)

 <img src="https://raw.githubusercontent.com/dearmiku/MK_Text/master/Image/makeNewLine2.png" width = "300"  alt="提前换行效果图" align=center />

## Asynchronous Rendering
By setting the Label's **isAsync** property to determine ~ defaults to false

## Effect Display
At present, only the above functions are implemented, and other functions will be enriched in the future.

 <img src="https://raw.githubusercontent.com/dearmiku/MK_Text/master/Image/iOS%E6%95%88%E6%9E%9C%E5%9B%BE.gif" width = "300"  alt="iOS效果图" align=center />

 <img src="https://raw.githubusercontent.com/dearmiku/MK_Text/master/Image/OSX%E6%95%88%E6%9E%9C%E5%9B%BE.gif" width = "500"  alt="OSX效果图" align=center />



# Performance
About performance I simply tested it and compared it to **YY_Text**. Here is a simple comparison of the time used to draw~

 <img src="https://raw.githubusercontent.com/dearmiku/MK_Text/master/Image/T1.png" width = "500"  alt="性能测试结果图" align=center />
  <img src="https://raw.githubusercontent.com/dearmiku/MK_Text/master/Image/T2.png" width = "500"  alt="性能测试结果图" align=center />


Here is the test time-consuming part of the code, the comparison is the drawing time ~
**MK_Text**

 <img src="https://raw.githubusercontent.com/dearmiku/MK_Text/master/Image/C1.png" width = "500"  alt="性能测试代码图" align=center />

**YY_Text**

 <img src="https://raw.githubusercontent.com/dearmiku/MK_Text/master/Image/C2.png" width = "500"  alt="性能测试代码图" align=center />

Measured results are faster **MK_Text**, may be my function is relatively simple and the reason for using **Swift** ~ it is not slow ~

# Use caution
## Modifying Rich Text Properties Midway
If you need to refresh the UI interface while modifying the rich text attributes, use the following method
```
public func mk_setAttrtbute(dic:[NSAttributedStringKey : Any], range: NSRange)->Void
```

## Automatic layout

** MK_Text** support for automatic constraints is done with reference to **UILabel**. When View's **translatesAutoresizingMaskIntoConstraints** is true, it is rendered according to the View's frame.

If false, it will judge whether the constraint is constrained to width and height. If it is constrained, it will be rendered according to the width and height of the constraint. If it is not constrained, it will complement the width and height constraints according to the rendering content.


# Install
## CocoaPods
Add pod 'MK_Text' in Podfile


# System Requirements
OSX 10.10 or iOS 8.0


