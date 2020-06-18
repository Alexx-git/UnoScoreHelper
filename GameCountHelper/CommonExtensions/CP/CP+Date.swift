//
//  CP+Date.swift
//  CustomerPortal
//
//  Created by Vlad on 8/7/19.
//  Copyright © 2019 Corrigo Inc. All rights reserved.
//

import Foundation
class Time: Comparable, Equatable {
	init(_ date: Date) {
		//get the current calender
		let calendar = Calendar.current
		
		//get just the minute and the hour of the day passed to it
		let dateComponents = calendar.dateComponents([.hour, .minute], from: date)
		
		//calculate the seconds since the beggining of the day for comparisions
		let dateSeconds = dateComponents.hour! * 3600 + dateComponents.minute! * 60
		
		//set the varibles
		secondsSinceBeginningOfDay = dateSeconds
		hour = dateComponents.hour!
		minute = dateComponents.minute!
	}
	
	init(_ hour: Int, _ minute: Int) {
		//calculate the seconds since the beggining of the day for comparisions
		let dateSeconds = hour * 3600 + minute * 60
		
		//set the varibles
		secondsSinceBeginningOfDay = dateSeconds
		self.hour = hour
		self.minute = minute
	}
	
	var hour : Int
	var minute: Int
	
	var date: Date {
		//get the current calender
		let calendar = Calendar.current
		
		//create a new date components.
		var dateComponents = DateComponents()
		
		dateComponents.hour = hour
		dateComponents.minute = minute
		
		return calendar.date(byAdding: dateComponents, to: Date())!
	}
	
	/// the number or seconds since the beggining of the day, this is used for comparisions
	//private
	let secondsSinceBeginningOfDay: Int
	
	//comparisions so you can compare times
	static func == (lhs: Time, rhs: Time) -> Bool {
		return lhs.secondsSinceBeginningOfDay == rhs.secondsSinceBeginningOfDay
	}
	
	static func < (lhs: Time, rhs: Time) -> Bool {
		return lhs.secondsSinceBeginningOfDay < rhs.secondsSinceBeginningOfDay
	}
	
	static func <= (lhs: Time, rhs: Time) -> Bool {
		return lhs.secondsSinceBeginningOfDay <= rhs.secondsSinceBeginningOfDay
	}
	
	
	static func >= (lhs: Time, rhs: Time) -> Bool {
		return lhs.secondsSinceBeginningOfDay >= rhs.secondsSinceBeginningOfDay
	}
	
	
	static func > (lhs: Time, rhs: Time) -> Bool {
		return lhs.secondsSinceBeginningOfDay > rhs.secondsSinceBeginningOfDay
	}
}

extension Date {
	static func merge( date: Date, time: Date, calendar:Calendar?) -> Date? {
		let calendar = calendar ?? Calendar.current
		var dateComponents = DateComponents()
		dateComponents.year = calendar.component(.year, from: date)
		dateComponents.month = calendar.component(.month, from: date)
		dateComponents.day = calendar.component(.day, from: date)
		
		dateComponents.hour = calendar.component(.hour, from: time)
		dateComponents.minute = calendar.component(.minute, from: time)
		dateComponents.second = calendar.component(.second, from: time)
		
		guard let resultDateTime = calendar.date(from: dateComponents) else {
			return nil
		}
		return resultDateTime
	}
	
	func daysShift(_ shift: Int) -> Date {
		return Calendar.current.date(byAdding: .day, value: shift, to: self)!
	}

	func toString( dateFormat format  : String ) -> String
	{
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = format
		return dateFormatter.string(from: self)
	}
	
	func convertToTimeZone(initTimeZone: TimeZone, timeZone: TimeZone) -> Date {
		let delta = TimeInterval(timeZone.secondsFromGMT() - initTimeZone.secondsFromGMT())
		return addingTimeInterval(delta)
	}
	
	func totalDistance(from date: Date, resultIn component: Calendar.Component) -> Int? {
		return Calendar.current.dateComponents([component], from: self, to: date).value(for: component)
	}
	//MARK compare with components:
	func compare(with date: Date, only component: Calendar.Component) -> Int {
		let days1 = Calendar.current.component(component, from: self)
		let days2 = Calendar.current.component(component, from: date)
		return days1 - days2
	}
	
	func hasSame(_ component: Calendar.Component, as date: Date) -> Bool {
		return self.compare(with: date, only: component) == 0
	}
	var time: Time {
		return Time(self)
	}
}

extension DateFormatter {
	func date(from string: String?) -> Date? {
		if let string = string {
			return date(from: string)
		}
		else {
			return nil
		}
	}
}


