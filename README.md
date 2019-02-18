# YetLayout
iOS auto layout by swift  

---
[![CI Status](https://img.shields.io/travis/yangentao/YetLayout.svg?style=flat)](https://travis-ci.org/yangentao/YetLayout)
[![Version](https://img.shields.io/cocoapods/v/YetLayout.svg?style=flat)](https://cocoapods.org/pods/YetLayout)
[![License](https://img.shields.io/cocoapods/l/YetLayout.svg?style=flat)](https://cocoapods.org/pods/YetLayout)
[![Platform](https://img.shields.io/cocoapods/p/YetLayout.svg?style=flat)](https://cocoapods.org/pods/YetLayout)


` let lb = UILabel(frame:CGRect.zero) `  
` self.view.addSubView(lb) `  

### 基本用法,属性开头

` lb.layout.width.eq(300).active() `  
` lb.layout.width.eq(300).priority(800).ident("mylabel").active() `  
` lb.layout.width.eq(imageView).width.multi(2).offset(8).priority(800).ident("mylabel2").active() `  

属性相同时, 后面的属性可以省略  
` lb.layout.width.eq(imageView).active() `   

` lb.layout.left.eq(imageView).right.active() `  
` lb.layout.left.eqParent.active() `  

### 组合用法, 函数开头  
` lb.layout.centerParent().width(200).height(200) `  
` lb.layout.fillX().topParent(16).height(200) `  
` lb.layout.toRightOf(imageView).width(200).topParent(30).height(150) `  

### 删除和更新, 更新只能更新constant属性  
` lb.layout.removeAll() `  
` lb.layout.remove(ident: "mylabel") `  

` lb.layout.width.eq(200).update() `  
` lb.layout.width.eq(200).remove() `  


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

YetLayout is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'YetLayout'
```

## Author

yangentao, entaoyang@163.com

## License

YetLayout is available under the MIT license. See the LICENSE file for more info.
