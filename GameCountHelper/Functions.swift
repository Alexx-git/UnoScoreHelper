//
//  Functions.swift
//  Keyboard
//
//  Created by VLADIMIR on 8/18/18.
//  Copyright © 2018 ALEXANDER. All rights reserved.
//

import UIKit

func compareStrings(_ firstString: String?, _ secondString: String?, ignoreCase:Bool = true) -> Bool
{
    guard let first = firstString else { return secondString == nil }
    guard let second = secondString else { return false }
    return first.uppercased() == second.uppercased()
}

//func compareIgnoringCase(firstLetter: String, secondLetter: String) -> Bool
//{
//    if firstLetter.uppercased() == secondLetter.uppercased()
//    {
//        return true
//    }
//    return false
//}

func draw(text: String, rect: CGRect, context: CGContext, font: UIFont, alignment: NSParagraphStyle, color: UIColor)
{
    var drawRect = rect
    let strokeWidth = NSNumber.init(value: 7.0)
    drawRect.size.height -= 2
    drawRect.size.width -= 2
    let components = color.cgColor.components!
    (text as NSString).draw(in: drawRect, withAttributes: [
        NSAttributedString.Key.paragraphStyle: alignment,
        NSAttributedString.Key.font: font,
        NSAttributedString.Key.strokeWidth: strokeWidth,
        NSAttributedString.Key.foregroundColor: UIColor.init(red: components[0] / 2 + 0.5, green: components[1] / 2 + 0.5, blue: components[2] / 2 + 0.5, alpha: components[3])])
    drawRect.origin.y += 2
    drawRect.origin.x += 2
    (text as NSString).draw(in: drawRect, withAttributes: [
        NSAttributedString.Key.paragraphStyle: alignment,
        NSAttributedString.Key.font: font,
        NSAttributedString.Key.strokeWidth: strokeWidth,
        NSAttributedString.Key.foregroundColor: UIColor.init(red: components[0] / 2, green: components[1] / 2, blue: components[2] / 2, alpha: components[3])])
    drawRect.origin.y -= 1
    drawRect.origin.x -= 1
    (text as NSString).draw(in: drawRect, withAttributes: [
        NSAttributedString.Key.paragraphStyle: alignment,
        NSAttributedString.Key.font: font,
        NSAttributedString.Key.strokeWidth: strokeWidth,
        NSAttributedString.Key.foregroundColor: color])
}

func getSecMinHours(from time: Double) -> (Double, Double, Double) {
    let seconds = trunc(time.truncatingRemainder(dividingBy: 60.0))
    let minutes = trunc((time / 60.0).truncatingRemainder(dividingBy: 60.0))
    let hours = trunc(time / 3600)
    return (seconds, minutes, hours)
}

func usualTimeString(from time: Double) -> String {
    let (seconds, minutes, hours) = getSecMinHours(from: time)
    if hours > 0
    {
        return String(format: "%02.0f:%02.0f:%02.0f", hours, minutes, seconds)
    } else
    {
        return String(format: "%02.0f:%02.0f", minutes, seconds)
    }
}
