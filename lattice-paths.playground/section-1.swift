// This is a solution to Project Euler's problem number 15: https://projecteuler.net/problem=15

var memoizedSolutions = [String : UInt64]()

func numberOfPathsTo(end:(x:Int, y:Int)) -> UInt64 {
    return numberOfPathsHelper((0, 0), end)
}

func numberOfPathsHelper(current:(x:Int, y:Int), _ end:(x:Int, y:Int)) -> UInt64 {
    
    let reachedTheEnd = current.x == end.x && current.y == end.y
    if (reachedTheEnd) {
        return 1
    }
    
    let dx = end.x - current.x
    let dy = end.y - current.y
    let key = "\(dx)-\(dy)"
    
    if let memoizedSolution = memoizedSolutions[key] {
        return memoizedSolution
    }
    
    let canMoveRight = current.x < end.x
    let canMoveDown = current.y < end.y
    let right = (current.x + 1, current.y)
    let down = (current.x, current.y + 1)
    
    if (canMoveRight && canMoveDown) {
        let result = numberOfPathsHelper(right, end) + numberOfPathsHelper(down, end)
        memoizedSolutions[key] = result
        return result
    } else if (canMoveRight) {
        let result = numberOfPathsHelper(right, end)
        memoizedSolutions[key] = result
        return result
    } else if (canMoveDown) {
        let result = numberOfPathsHelper(down, end)
        memoizedSolutions[key] = result
        return result
    }
    
    assert(false, "Should not reach this point.")
    return 0
}

numberOfPathsTo((2, 2)) == 6
numberOfPathsTo((20, 20)) == 137846528820
