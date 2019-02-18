//
// Created by entaoyang on 2019-02-14.
// Copyright (c) 2019 yet.net. All rights reserved.
//

import Foundation
import UIKit


public extension UIView {

	public var layout: YetLayout {
		return YetLayout(self)
	}

	public func layout(block: (YetLayout) -> Void) {
		block(self.layout)
	}

	public func layoutStretch(_ axis: NSLayoutConstraint.Axis) {
		self.setContentHuggingPriority(UILayoutPriority(rawValue: 240), for: axis)
	}

	public func layoutKeepContent(_ axis: NSLayoutConstraint.Axis) {
		self.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 760), for: axis)
	}

	fileprivate var _conList: YetConList {
		let old = objc_getAssociatedObject(self, &_con_key)
		if old != nil {
			return old as! YetConList
		}
		let c = YetConList()
		objc_setAssociatedObject(self, &_con_key, c, .OBJC_ASSOCIATION_RETAIN)
		return c
	}
}

private var _con_key = "_conkey_"

fileprivate class YetConList {
	var list = [NSLayoutConstraint]()
}
fileprivate extension Array {

    mutating func removeFirstIf(block: (Element) -> Bool) -> Element? {
        for i in self.indices {
            let item = self[i]
            if block(item) {
                self.remove(at: i)
                return item
            }
        }
        return nil
    }
}

public class YetLayout {
	private unowned var view: UIView

	public init(_ view: UIView) {
		self.view = view
		self.view.translatesAutoresizingMaskIntoConstraints = false
	}

	public func removeAll() {
		for c in view._conList.list {
			c.isActive = false
		}
		view._conList.list = []
	}

	public func remove(ident: String) {
		let c = self.view._conList.list.removeFirstIf { (n: NSLayoutConstraint) in
			n.identifier == ident
		}
		c?.isActive = false
	}


	public var left: YetLayoutRel {
		return YetLayoutRel(self.view, .left)
	}

	public var right: YetLayoutRel {
		return YetLayoutRel(self.view, .right)
	}

	public var top: YetLayoutRel {
		return YetLayoutRel(self.view, .top)
	}

	public var bottom: YetLayoutRel {
		return YetLayoutRel(self.view, .bottom)
	}

	public var leading: YetLayoutRel {
		return YetLayoutRel(self.view, .leading)
	}

	public var trailing: YetLayoutRel {
		return YetLayoutRel(self.view, .trailing)
	}

	public var width: YetLayoutRel {
		return YetLayoutRel(self.view, .width)
	}

	public var height: YetLayoutRel {
		return YetLayoutRel(self.view, .height)
	}

	public var centerX: YetLayoutRel {
		return YetLayoutRel(self.view, .centerX)
	}

	public var centerY: YetLayoutRel {
		return YetLayoutRel(self.view, .centerY)
	}

	public var lastBaseline: YetLayoutRel {
		return YetLayoutRel(self.view, .lastBaseline)
	}

	public var firstBaseline: YetLayoutRel {
		return YetLayoutRel(self.view, .firstBaseline)
	}

	public var leftMargin: YetLayoutRel {
		return YetLayoutRel(self.view, .leftMargin)
	}

	public var rightMargin: YetLayoutRel {
		return YetLayoutRel(self.view, .rightMargin)
	}

	public var topMargin: YetLayoutRel {
		return YetLayoutRel(self.view, .topMargin)
	}

	public var bottomMargin: YetLayoutRel {
		return YetLayoutRel(self.view, .bottomMargin)
	}

	public var leadingMargin: YetLayoutRel {
		return YetLayoutRel(self.view, .leadingMargin)
	}

	public var trailingMargin: YetLayoutRel {
		return YetLayoutRel(self.view, .trailingMargin)
	}

	public var centerYWithinMargins: YetLayoutRel {
		return YetLayoutRel(self.view, .centerYWithinMargins)
	}

}

public class YetLayoutRel {
	private unowned var view: UIView
	private let attr: NSLayoutConstraint.Attribute

	fileprivate init(_ view: UIView, _ attr: NSLayoutConstraint.Attribute) {
		self.view = view
		self.attr = attr
	}

	public func eq(_ c: CGFloat) -> YetLayoutAttr2None {
		return YetLayoutAttr2None(view, attr, .equal, c)
	}

	public func ge(_ c: CGFloat) -> YetLayoutAttr2None {
		return YetLayoutAttr2None(view, attr, .greaterThanOrEqual, c)
	}

	public func le(_ c: CGFloat) -> YetLayoutAttr2None {
		return YetLayoutAttr2None(view, attr, .lessThanOrEqual, c)
	}

	public func eq(_ v: UIView) -> YetLayoutAttr2Other {
		return YetLayoutAttr2Other(view, attr, .equal, v)
	}

	public func ge(_ v: UIView) -> YetLayoutAttr2Other {
		return YetLayoutAttr2Other(view, attr, .greaterThanOrEqual, v)
	}

	public func le(_ v: UIView) -> YetLayoutAttr2Other {
		return YetLayoutAttr2Other(view, attr, .lessThanOrEqual, v)
	}

	public var eqParent: YetLayoutAttr2Other {
		return YetLayoutAttr2Other(view, attr, .equal, view.superview!)
	}
	public var geParent: YetLayoutAttr2Other {
		return YetLayoutAttr2Other(view, attr, .greaterThanOrEqual, view.superview!)
	}
	public var leParent: YetLayoutAttr2Other {
		return YetLayoutAttr2Other(view, attr, .lessThanOrEqual, view.superview!)
	}
}

public class YetLayoutAttr2Base {
	fileprivate var view: UIView
	fileprivate let attr: NSLayoutConstraint.Attribute
	fileprivate let rel: NSLayoutConstraint.Relation
	fileprivate var view2: UIView? = nil
	fileprivate var attr2: NSLayoutConstraint.Attribute = .notAnAttribute
	fileprivate var multi: CGFloat = 1
	fileprivate var constant: CGFloat = 0
	fileprivate var priority: UILayoutPriority = UILayoutPriority.required
	fileprivate var idName: String? = nil

	fileprivate init(_ view: UIView, _ attr: NSLayoutConstraint.Attribute, _ rel: NSLayoutConstraint.Relation) {
		self.view = view
		self.attr = attr
		self.rel = rel
	}

	private func findOld() -> NSLayoutConstraint? {
		let ls = self.view._conList.list.filter { (n: NSLayoutConstraint) in
			n.isActive && n.firstItem === view && n.firstAttribute == attr && n.relation == rel
		}
		if !ls.isEmpty {
			return ls.first
		}
		return nil
	}

	public func update() {
		if let c = findOld() {
			c.constant = constant
			view.setNeedsUpdateConstraints()
			view.superview?.setNeedsUpdateConstraints()
		}
	}

	public func remove() {
		let c = self.view._conList.list.removeFirstIf { (n: NSLayoutConstraint) in
			n.firstItem === view && n.firstAttribute == attr && n.relation == rel
		}
		c?.isActive = false
	}

	@discardableResult
	public func active() -> NSLayoutConstraint {
		let n = NSLayoutConstraint(item: self.view, attribute: attr, relatedBy: rel, toItem: view2, attribute: attr2, multiplier: multi, constant: constant)
		n.priority = priority
		if let name = idName {
			n.identifier = name
		}
		n.isActive = true
		self.view._conList.list.append(n)
		return n
	}
}

public class YetLayoutAttr2None: YetLayoutAttr2Base {

	fileprivate init(_ view: UIView, _ attr: NSLayoutConstraint.Attribute, _ rel: NSLayoutConstraint.Relation, _ c: CGFloat) {
		super.init(view, attr, rel)
		self.constant = c
	}


	public func priority(_ p: UILayoutPriority) -> YetLayoutAttr2None {
		self.priority = p
		return self
	}

	public func priority(_ n: Int) -> YetLayoutAttr2None {
		self.priority = UILayoutPriority(rawValue: Float(n))
		return self
	}

	public var priorityLow: YetLayoutAttr2None {
		self.priority = UILayoutPriority.defaultLow
		return self
	}
	public var priorityHigh: YetLayoutAttr2None {
		self.priority = UILayoutPriority.defaultHigh
		return self
	}
	public var priorityFittingSize: YetLayoutAttr2None {
		self.priority = UILayoutPriority.fittingSizeLevel
		return self
	}

	public func ident(_ name: String) -> YetLayoutAttr2None {
		self.idName = name
		return self
	}
}

public class YetLayoutAttr2Other: YetLayoutAttr2Base {

	fileprivate init(_ view: UIView, _ attr: NSLayoutConstraint.Attribute, _ rel: NSLayoutConstraint.Relation, _ view2: UIView) {
		super.init(view, attr, rel)
		self.view2 = view2
		self.attr2 = self.attr
	}


	public func priority(_ p: UILayoutPriority) -> YetLayoutAttr2Other {
		self.priority = p
		return self
	}

	public func priority(_ n: Int) -> YetLayoutAttr2Other {
		self.priority = UILayoutPriority(rawValue: Float(n))
		return self
	}

	public var priorityLow: YetLayoutAttr2Other {
		self.priority = UILayoutPriority.defaultLow
		return self
	}
	public var priorityHigh: YetLayoutAttr2Other {
		self.priority = UILayoutPriority.defaultHigh
		return self
	}
	public var priorityFittingSize: YetLayoutAttr2Other {
		self.priority = UILayoutPriority.fittingSizeLevel
		return self
	}

	public func ident(_ name: String) -> YetLayoutAttr2Other {
		self.idName = name
		return self
	}

	public func divided(_ m: CGFloat) -> YetLayoutAttr2Other {
		self.multi = 1 / m
		return self
	}

	public func multi(_ m: CGFloat) -> YetLayoutAttr2Other {
		self.multi = m
		return self
	}

	public func offset(_ c: CGFloat) -> YetLayoutAttr2Other {
		self.constant = c
		return self
	}

	public var left: YetLayoutAttr2Other {
		attr2 = .left
		return self
	}


	public var right: YetLayoutAttr2Other {
		attr2 = .right
		return self
	}

	public var top: YetLayoutAttr2Other {
		attr2 = .top
		return self
	}

	public var bottom: YetLayoutAttr2Other {
		attr2 = .bottom
		return self
	}

	public var leading: YetLayoutAttr2Other {
		attr2 = .leading
		return self
	}

	public var trailing: YetLayoutAttr2Other {
		attr2 = .trailing
		return self
	}

	public var width: YetLayoutAttr2Other {
		attr2 = .width
		return self
	}

	public var height: YetLayoutAttr2Other {
		attr2 = .height
		return self
	}

	public var centerX: YetLayoutAttr2Other {
		attr2 = .centerX
		return self
	}

	public var centerY: YetLayoutAttr2Other {
		attr2 = .centerY
		return self
	}

	public var lastBaseline: YetLayoutAttr2Other {
		attr2 = .lastBaseline
		return self
	}

	public var firstBaseline: YetLayoutAttr2Other {
		attr2 = .firstBaseline
		return self
	}

	public var leftMargin: YetLayoutAttr2Other {
		attr2 = .leftMargin
		return self
	}

	public var rightMargin: YetLayoutAttr2Other {
		attr2 = .rightMargin
		return self
	}

	public var topMargin: YetLayoutAttr2Other {
		attr2 = .topMargin
		return self
	}

	public var bottomMargin: YetLayoutAttr2Other {
		attr2 = .bottomMargin
		return self
	}

	public var leadingMargin: YetLayoutAttr2Other {
		attr2 = .leadingMargin
		return self
	}

	public var trailingMargin: YetLayoutAttr2Other {
		attr2 = .trailingMargin
		return self
	}

	public var centerYWithinMargins: YetLayoutAttr2Other {
		attr2 = .centerYWithinMargins
		return self
	}

}


public extension YetLayout {
	@discardableResult
	public func centerXOf(_ v: UIView, _ offset: CGFloat = 0) -> YetLayout {
		self.centerX.eq(v).offset(offset).active()
		return self
	}

	@discardableResult
	public func centerYOf(_ v: UIView, _ offset: CGFloat = 0) -> YetLayout {
		self.centerY.eq(v).offset(offset).active()
		return self
	}

	@discardableResult
	public func toLeftOf(_ v: UIView, _ offset: CGFloat = 0) -> YetLayout {
		self.right.eq(v).left.offset(offset).active()
		return self
	}

	@discardableResult
	public func toRightOf(_ v: UIView, _ offset: CGFloat = 0) -> YetLayout {
		self.left.eq(v).right.offset(offset).active()
		return self
	}

	@discardableResult
	public func below(_ v: UIView, _ offset: CGFloat = 0) -> YetLayout {
		self.top.eq(v).bottom.offset(offset).active()
		return self
	}

	@discardableResult
	public func above(_ v: UIView, _ offset: CGFloat = 0) -> YetLayout {
		self.bottom.eq(v).top.offset(offset).active()
		return self
	}

	@discardableResult
	public func widthOf(_ v: UIView) -> YetLayout {
		self.width.eq(v).active()
		return self
	}

	@discardableResult
	public func heightOf(_ v: UIView) -> YetLayout {
		self.height.eq(v).active()
		return self
	}

	@discardableResult
	public func leftOf(_ v: UIView) -> YetLayout {
		self.left.eq(v).active()
		return self
	}

	@discardableResult
	public func rightOf(_ v: UIView) -> YetLayout {
		self.right.eq(v).active()
		return self
	}

	@discardableResult
	public func topOf(_ v: UIView) -> YetLayout {
		self.top.eq(v).active()
		return self
	}

	@discardableResult
	public func bottomOf(_ v: UIView) -> YetLayout {
		self.bottom.eq(v).active()
		return self
	}

	@discardableResult
	public func centerParent() -> YetLayout {
		self.centerXParent()
		self.centerYParent()
		return self
	}

	@discardableResult
	public func centerXParent(_ offset: CGFloat = 0) -> YetLayout {
		self.centerX.eqParent.offset(offset).active()
		return self
	}

	@discardableResult
	public func centerYParent(_ offset: CGFloat = 0) -> YetLayout {
		self.centerY.eqParent.offset(offset).active()
		return self
	}

	@discardableResult
	public func fillX() -> YetLayout {
		return self.fillX(0, 0)
	}

	@discardableResult
	public func fillX(_ leftOffset: CGFloat, _ rightOffset: CGFloat) -> YetLayout {
		self.leftParent(leftOffset)
		return self.rightParent(rightOffset)
	}

	@discardableResult
	public func fillY() -> YetLayout {
		return self.fillY(0, 0)
	}

	@discardableResult
	public func fillY(_ topOffset: CGFloat, _ bottomOffset: CGFloat) -> YetLayout {
		self.topParent(topOffset)
		return self.bottomParent(bottomOffset)
	}

	@discardableResult
	public func fill() -> YetLayout {
		fillX()
		fillY(0, 0)
		return self
	}


	@discardableResult
	public func topParent(_ n: CGFloat = 0) -> YetLayout {
		self.top.eqParent.offset(n).active()
		return self
	}

	@discardableResult
	public func bottomParent(_ n: CGFloat = 0) -> YetLayout {
		self.bottom.eqParent.offset(n).active()
		return self
	}

	@discardableResult
	public func leftParent(_ n: CGFloat = 0) -> YetLayout {
		self.left.eqParent.offset(n).active()
		return self
	}

	@discardableResult
	public func rightParent(_ n: CGFloat = 0) -> YetLayout {
		self.right.eqParent.offset(n).active()
		return self
	}

	@discardableResult
	public func heightLe(_ w: CGFloat) -> YetLayout {
		self.height.le(w).active()
		return self
	}

	@discardableResult
	public func heightGe(_ w: CGFloat) -> YetLayout {
		self.height.ge(w).active()
		return self
	}

	@discardableResult
	public func height(_ w: CGFloat) -> YetLayout {
		self.height.eq(w).active()
		return self
	}

	@discardableResult
	public func heightEdit() -> YetLayout {
		self.height(YetLayoutConst.editHeight)
		return self
	}

	@discardableResult
	public func heightText() -> YetLayout {
		self.height(YetLayoutConst.textHeight)
		return self
	}

	@discardableResult
	public func heightButton() -> YetLayout {
		self.height(YetLayoutConst.buttonHeight)
		return self
	}

	@discardableResult
	public func widthLe(_ w: CGFloat) -> YetLayout {
		self.width.le(w).active()
		return self
	}

	@discardableResult
	public func widthGe(_ w: CGFloat) -> YetLayout {
		self.width.ge(w).active()
		return self
	}

	@discardableResult
	public func width(_ w: CGFloat) -> YetLayout {
		self.width.eq(w).active()
		return self
	}


	@discardableResult
	public func size(_ sz: CGFloat) -> YetLayout {
		return self.width(sz).height(sz)
	}

	@discardableResult
	public func size(_ w: CGFloat, _ h: CGFloat) -> YetLayout {
		return self.width(w).height(h)
	}

	@discardableResult
	public func widthFit(_ c: CGFloat = 0) -> YetLayout {
		let sz = self.view.sizeThatFits(CGSize.zero)
		self.width(sz.width + c)
		return self
	}

	@discardableResult
	public func heightFit(_ c: CGFloat = 0) -> YetLayout {
		let sz = self.view.sizeThatFits(CGSize.zero)
		self.height(sz.height + c)
		return self
	}

	@discardableResult
	public func sizeFit() -> YetLayout {
		let sz = self.view.sizeThatFits(CGSize.zero)
		self.width(sz.width)
		self.height(sz.height)
		return self
	}

}

public class YetLayoutConst {
	public static var buttonHeight: CGFloat = 42
	public static var editHeight: CGFloat = 42
	public static var textHeight: CGFloat = 30
}