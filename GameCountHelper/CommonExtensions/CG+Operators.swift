//
//  CG+Operators.swift
//  Common
//
//  Created by Vlad on 5/16/19.
//  Copyright © 2019 Vlad. All rights reserved.
//

// based on https://gist.github.com/ldesroziers

import Foundation
import UIKit

func * (f: CGFloat, i: Int) -> CGFloat {
    return f * CGFloat(i)
}

func * (i: Int, f: CGFloat) -> CGFloat {
    return f * CGFloat(i)
}

func / (f: CGFloat, i: Int) -> CGFloat {
    return f / CGFloat(i)
}

func / (i: Int, f: CGFloat) -> CGFloat {
    return CGFloat(i) / f
}



func += ( rect: inout CGRect, size: CGSize) {
	rect.size += size
}
func -= ( rect: inout CGRect, size: CGSize) {
	rect.size -= size
}
func *= ( rect: inout CGRect, size: CGSize) {
	rect.size *= size
}
func /= ( rect: inout CGRect, size: CGSize) {
	rect.size /= size
}
func += ( rect: inout CGRect, origin: CGPoint) {
	rect.origin += origin
}
func -= ( rect: inout CGRect, origin: CGPoint) {
	rect.origin -= origin
}
func *= ( rect: inout CGRect, origin: CGPoint) {
	rect.origin *= origin
}
func /= ( rect: inout CGRect, origin: CGPoint) {
	rect.origin /= origin
}


/** CGSize+OperatorsAdditions */
func += ( size: inout CGSize, right: CGFloat) {
	size.width += right
	size.height += right
}
func -= ( size: inout CGSize, right: CGFloat) {
	size.width -= right
	size.height -= right
}
func *= ( size: inout CGSize, right: CGFloat) {
	size.width *= right
	size.height *= right
}
func /= ( size: inout CGSize, right: CGFloat) {
	size.width /= right
	size.height /= right
}

func += ( left: inout CGSize, right: CGSize) {
	left.width += right.width
	left.height += right.height
}
func -= ( left: inout CGSize, right: CGSize) {
	left.width -= right.width
	left.height -= right.height
}
func *= ( left: inout CGSize, right: CGSize) {
	left.width *= right.width
	left.height *= right.height
}
func /= ( left: inout CGSize, right: CGSize) {
	left.width /= right.width
	left.height /= right.height
}

func + (size: CGSize, right: CGFloat) -> CGSize {
	return CGSize(width: size.width + right, height: size.height + right)
}
func - (size: CGSize, right: CGFloat) -> CGSize {
	return CGSize(width: size.width - right, height: size.height - right)
}
func * (size: CGSize, right: CGFloat) -> CGSize {
	return CGSize(width: size.width * right, height: size.height * right)
}
func / (size: CGSize, right: CGFloat) -> CGSize {
	return CGSize(width: size.width / right, height: size.height / right)
}

func + (left: CGSize, right: CGSize) -> CGSize {
	return CGSize(width: left.width + right.width, height: left.height + right.height)
}
func - (left: CGSize, right: CGSize) -> CGSize {
	return CGSize(width: left.width - right.width, height: left.height - right.height)
}
func * (left: CGSize, right: CGSize) -> CGSize {
	return CGSize(width: left.width * right.width, height: left.height * right.height)
}
func / (left: CGSize, right: CGSize) -> CGSize {
	return CGSize(width: left.width / right.width, height: left.height / right.height)
}



/** CGPoint+OperatorsAdditions */
func += (point: inout CGPoint, right: CGFloat) {
	point.x += right
	point.y += right
}
func -= (point: inout CGPoint, right: CGFloat) {
	point.x -= right
	point.y -= right
}
func *= (point: inout CGPoint, right: CGFloat) {
	point.x *= right
	point.y *= right
}
func /= (point: inout CGPoint, right: CGFloat) {
	point.x /= right
	point.y /= right
}

func += (left: inout CGPoint, right: CGPoint) {
	left.x += right.x
	left.y += right.y
}
func -= (left: inout CGPoint, right: CGPoint) {
	left.x -= right.x
	left.y -= right.y
}
func *= (left: inout CGPoint, right: CGPoint) {
	left.x *= right.x
	left.y *= right.y
}
func /= (left: inout CGPoint, right: CGPoint) {
	left.x /= right.x
	left.y /= right.y
}

func + (rect: CGRect, point: CGPoint) -> CGRect {
    return CGRect(origin: rect.origin + point, size: rect.size)
}

func - (rect: CGRect, point: CGPoint) -> CGRect {
    return CGRect(origin: rect.origin - point, size: rect.size)
}

func + (point: CGPoint, right: CGFloat) -> CGPoint {
	return CGPoint(x: point.x + right, y: point.y + right)
}
func - (point: CGPoint, right: CGFloat) -> CGPoint {
	return CGPoint(x: point.x - right, y: point.y - right)
}
func * (point: CGPoint, right: CGFloat) -> CGPoint {
	return CGPoint(x: point.x * right, y: point.y * right)
}
func / (point: CGPoint, right: CGFloat) -> CGPoint {
	return CGPoint(x: point.x / right, y: point.y / right)
}

func + (point: CGPoint, right: Double) -> CGPoint {
	return point + CGFloat(right)
}
func - (point: CGPoint, right: Double) -> CGPoint {
	return point - CGFloat(right)
}
func * (point: CGPoint, right: Double) -> CGPoint {
	return point * CGFloat(right)
}
func / (point: CGPoint, right: Double) -> CGPoint {
	return point / CGFloat(right)
}

func + (left: CGPoint, right: CGPoint) -> CGPoint {
	return CGPoint(x: left.x + right.x, y: left.y + right.y)
}
func - (left: CGPoint, right: CGPoint) -> CGPoint {
	return CGPoint(x: left.x - right.x, y: left.y - right.y)
}
func * (left: CGPoint, right: CGPoint) -> CGPoint {
	return CGPoint(x: left.x * right.x, y: left.y * right.y)
}
func / (left: CGPoint, right: CGPoint) -> CGPoint {
	return CGPoint(x: left.x / right.x, y: left.y / right.y)
}
