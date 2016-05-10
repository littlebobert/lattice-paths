// This is a solution to Project Euler's problem number 15: https://projecteuler.net/problem=15

// This function was presented in the Advanced Swift talk at WWDC 2014. It memoizes
// an arbitrary function as long as that function takes in a variable that is hashable.
// We'll use it below on our simple recursive algorithm.
func memoize<T: Hashable, U>(body: (T -> U, T) -> U) -> (T -> U) {
    
    var solutions = [T : U]()
    
    func result(n: T) -> U {
        if let q = solutions[n] { return q }
        let r = body(result, n)
        solutions[n] = r
        return r
    }
    
    return result
}

// Here it is memoizing fibonacci:
let fibonacci = memoize({fibonacci, n in n <= 2 ? 1 : fibonacci(n - 1) + fibonacci(n - 2)})

fibonacci(5) == 5
fibonacci(6) == 8
fibonacci(7) == 13
fibonacci(50) == 12586269025

// The memoize function takes in a function that takes in a value that must be hashable. Since tuples in Swift
// aren't hashable, we create a struct here called Input which acts as a tuple and is hashable.
struct Input: Hashable {
    let x:Int
    let y:Int
    
    init(_ tuple: (x: Int, y: Int)) {
        self.x = tuple.x
        self.y = tuple.y
    }
    
    var hashValue: Int {
        get {
            return "(\(x), \(y))".hashValue
        }
    }
}

// Make Input Equatable.
func ==(lhs: Input, rhs: Input) -> Bool {
    return lhs.x == rhs.x &&
        lhs.y == rhs.y
}

let memoizedHelper = memoize({ (numberOfPathsHelper: (Input -> UInt64), input: Input) -> UInt64 in
    
    let current = input
    let end = (x: 0, y: 0)
    
    let reachedTheEnd = current.x == end.x && current.y == end.y
    if (reachedTheEnd) {
        return 1
    }
    
    let canMoveRight = current.x < end.x
    let canMoveDown = current.y < end.y
    let right = (current.x + 1, current.y)
    let down = (current.x, current.y + 1)
    
    if (canMoveRight && canMoveDown) {
        return numberOfPathsHelper(Input(right)) + numberOfPathsHelper(Input(down))
    } else if (canMoveRight) {
        return numberOfPathsHelper(Input(right))
    } else if (canMoveDown) {
        return numberOfPathsHelper(Input(down))
    }
    
    assert(false, "Should not reach this point.")
    return 0
})

func numberOfPathsTo(end:(x:Int, y:Int)) -> UInt64 {
    return memoizedHelper(Input((-1 * end.x, -1 * end.y)))
}

numberOfPathsTo((1, 1)) == 2
numberOfPathsTo((2, 2)) == 6
numberOfPathsTo((20, 20)) == 137846528820
