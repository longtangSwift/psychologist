//
//  LinearCongruentialGenerator.swift
//  Psychologist
//
//  Created by CT MacBook Pro on 6/30/15.
//  Copyright © 2015 CT MacBook Pro. All rights reserved.
//

import Foundation

protocol RandomNumberGenerator {
    func random() -> Double
}
//This protocol, RandomNumberGenerator, requires any conforming type to have an instance method called random, which returns a Double value whenever it is called. Although it is not specified as part of the protocol, it is assumed that this value will be a number from 0.0 up to (but not including) 1.0.
//
//The RandomNumberGenerator protocol does not make any assumptions about how each random number will be generated—it simply requires the generator to provide a standard way to generate a new random number.
//
//Here’s an implementation of a class that adopts and conforms to the RandomNumberGenerator protocol. This class implements a pseudorandom number generator algorithm known as a linear congruential generator:

class LinearCongruentialGenerator: RandomNumberGenerator {
    var lastRandom = 42.0 + (NSDate(timeIntervalSince1970: 4597865)).timeIntervalSinceReferenceDate
    let m = 4294967295.0
    let a = 3877.02 + abs((NSDate(timeIntervalSince1970: 14234).timeIntervalSinceReferenceDate - NSDate(timeIntervalSinceNow: 1).timeIntervalSinceReferenceDate - 2 * NSDate(timeIntervalSince1970: 14234).timeIntervalSinceReferenceDate) )
    let c = 29573.07 + abs(sin(NSDate(timeIntervalSince1970: 14234).timeIntervalSinceReferenceDate - NSDate(timeIntervalSinceNow: 1).timeIntervalSinceReferenceDate))
    var d = 1.0
    var e = 1.0
    
    func random() -> Double {
        d = abs( ((1 * a + m + tan(m)) % c) / c )   //    //returns a double 0.XXXXXXX
        var str = String(Double(d))
        var strArr = Array(str.characters)
        var i = strArr.count-1
        str = ""
        while i > -1 { str.append(strArr[i--])  }
        if str.characters.count < 3 {str = "481.234"} //in case we failed to get a number.
        let e = abs( (str as NSString).doubleValue / 3313.13 * tan(sqrt(d+7)) * sin(m+11) / cos(a+13) + M_2_PI*c )
        lastRandom = abs((lastRandom * a + c + 0.913 * e / d) % m)
        return lastRandom / m
    }
}