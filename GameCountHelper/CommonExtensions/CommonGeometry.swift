//
//  CGGeometry 
//  Crypto
//
//  Created by Vlad on 9/19/19.
//  Copyright © 2019 Vlad. All rights reserved.
//

import UIKit

extension CGRect {
    
    enum VerticalPosition: CGFloat{
        case top = 0.0
        case center = 0.5
        case bottom = 1.0
    }

    enum HorizontalPosition: CGFloat{
        case left = 0.0
        case center = 0.5
        case right = 1.0
    }
    
    typealias RectPosition = (HorizontalPosition, VerticalPosition)
    
	func insets(in container: CGSize) -> UIEdgeInsets {
		let left = self.origin.x
		let top = self.origin.y
		let right = container.width - left - self.width
		let bottom = container.height - top - self.height
		return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
	}
    
	func insets(in container: CGRect) -> UIEdgeInsets {
		return self.insets(in: container.size)
	}
	
	func innerRectWithSize(_ size: CGSize, position: RectPosition, offset: CGPoint = .zero) -> CGRect {
		let fx = position.0.rawValue
		let fy = position.1.rawValue
		let x = self.minX + (self.width - size.width) * fx
		let y = self.minY + (self.height - size.height) * fy
		let newOrigin = CGPoint(x: x, y: y) + offset
		return CGRect(origin: newOrigin, size: size)
	}
	
	mutating func moveTo(_ position: RectPosition, of rect: CGRect, offset: CGPoint = .zero) {
		self = rect.innerRectWithSize(self.size, position: position, offset: offset)
	}
	
	var center: CGPoint {
		return CGPoint(x: midX, y: midY)
	}
	
}

extension CGSize {
	
	init(all: CGFloat) {
		self.init(width: all, height: all)
	}
	
	init(_ width: CGFloat, _ height: CGFloat) {
		self.init(width: width, height: height)
	}
	
	func insets(in container: CGSize) -> UIEdgeInsets {
		let vInsets = (container.height - self.height) / 2.0
		let hInsets = (container.width - self.width) / 2.0
		return UIEdgeInsets(top: vInsets, left: hInsets, bottom: vInsets, right: hInsets)
	}
    
    func sizeWithInsets(_ insets: UIEdgeInsets) -> CGSize {
        return CGSize(width: self.width - insets.width, height: self.height - insets.height)
    }

	var point: CGPoint {
		return CGPoint(x: width, y: height)
	}
}

extension CGPoint {
	
	init(_ x: CGFloat, _ y: CGFloat) {
		self.init(x: x, y: y)
	}
	
	var size: CGSize {
		return CGSize(width: x, height: y)
	}
	
}


enum EdgeInsetsEdge {
	case top
	case left
	case bottom
	case right
}


extension CGAffineTransform {
    
    init(from: CGRect, toRect to: CGRect) {
        self.init(translationX: to.midX-from.midX, y: to.midY-from.midY)
        self = self.scaledBy(x: to.width/from.width, y: to.height/from.height)
    }
}

extension UIEdgeInsets {
    
    init(edge: EdgeInsetsEdge, value: CGFloat) {
        self.init()
        switch edge {
            case .top: self.top = value
            case .left: self.left = value
            case .bottom: self.bottom = value
            case .right: self.right = value
        }
    }
    
    static func all(_ value: CGFloat) -> Self {
        return UIEdgeInsets(top: value, left: value, bottom: value, right: value)
    }
    
    static func allX(_ value: CGFloat) -> Self {
        return UIEdgeInsets(top: 0.0, left: value, bottom: 0.0, right: value)
    }
    
    static func allY(_ value: CGFloat) -> Self {
        return UIEdgeInsets(top: value, left: 0.0, bottom: value, right: 0.0)
    }
    
    func allX(_ value: CGFloat) -> Self {
        return UIEdgeInsets(top: self.top, left: value, bottom: self.bottom, right: value)
    }
    
    func allY(_ value: CGFloat) -> Self {
        return UIEdgeInsets(top: value, left: self.left, bottom: value, right: self.right)
    }
    
    func with(top: CGFloat? = nil, left: CGFloat? = nil, bottom: CGFloat? = nil, right: CGFloat? = nil) -> UIEdgeInsets {
        var ins = self
        ins.left ?= left
        ins.top ?= top
        ins.right ?= right
        ins.bottom ?= bottom
        return ins
    }
    
    var width: CGFloat {
        return left + right
    }
    
    var height: CGFloat {
        return top + bottom
    }
}


