// Playground - noun: a place where people can play

import UIKit

// This is a solution to Project Euler's problem number 15: https://projecteuler.net/problem=15
// (It takes a few seconds to run on a MacBook Pro from 2013)

var startingPoint = (0, 0)
var finishPoint = (20, 20)

var memoized = Dictionary<String, Int>()

func numberOfPathsHelper(start:(Int, Int), end:(Int, Int)) -> Int {
    if (start.0 == end.0 && start.1 == end.1) {
        return 1
    }
    
    let distanceToEnd = (end.0 - start.0, end.1 - start.1)
    let key = "\(distanceToEnd.0)-\(distanceToEnd.1)"
    if let value = memoized[key] {
        return value
    }
    
    if (start.0 < end.0 && start.1 < end.1) {
        return numberOfPathsHelper((start.0 + 1, start.1), end) + numberOfPathsHelper((start.0, start.1 + 1), end)
    } else if (start.0 < end.0) {
        return numberOfPathsHelper((start.0 + 1, start.1), end)
    } else if (start.1 < end.1) {
        return numberOfPathsHelper((start.0, start.1 + 1), end)
    }
    return 0
}

func numberOfPaths(start:(Int, Int), end:(Int, Int)) -> Int {
    
    for var i = 1; i < end.0; i++ {
        for var x = 1; x <= i; x++ {
            for var y = 1; y <= i; y++ {
                let value = numberOfPathsHelper(start, (x, y))
                let key = "\(x)-\(y)"
                memoized[key] = value
            }
        }

    }
    
    return numberOfPathsHelper(start, end)
}

numberOfPaths(startingPoint, finishPoint)
