//
//  EasyTimerTimeInterval.swift
//  EasyTimerTimeInterval
//
//  Created by Niklas Fahl on 3/2/16.
//  Copyright © 2016 High Bay. All rights reserved.
//

import Foundation

// Powered by Swifty Timer Extension - radex
extension Double {
    public var millisecond: TimeInterval  { return self / 1000 }
    public var second: TimeInterval       { return self }
    public var minute: TimeInterval       { return self * 60 }
    public var hour: TimeInterval         { return self * 3600 }
    public var day: TimeInterval          { return self * 3600 * 24 }
    
    public var milliseconds: TimeInterval  { return self / 1000 }
    public var seconds: TimeInterval       { return self }
    public var minutes: TimeInterval       { return self * 60 }
    public var hours: TimeInterval         { return self * 3600 }
    public var days: TimeInterval          { return self * 3600 * 24 }
}

extension Int {
    public var millisecond: TimeInterval  { return Double(self) / 1000 }
    public var second: TimeInterval       { return Double(self) }
    public var minute: TimeInterval       { return Double(self) * 60 }
    public var hour: TimeInterval         { return Double(self) * 3600 }
    public var day: TimeInterval          { return Double(self) * 3600 * 24 }
    
//    public var milliseconds: TimeInterval  { return Double(self) / 1000 }
//    public var seconds: TimeInterval       { return Double(self) }
//    public var minutes: TimeInterval       { return Double(self) * 60 }
//    public var hours: TimeInterval         { return Double(self) * 3600 }
//    public var days: TimeInterval          { return Double(self) * 3600 * 24 }
}
