import UIKit

func makeIncrementer(forIncrement amount: Int) -> () -> Int {
    var runningTotal = 0
    func incrementer() -> Int {
        runningTotal += amount
        return runningTotal
    }
    return incrementer
}

// func creates different references in the memory

let incrementByTen = makeIncrementer(forIncrement: 10)

print(incrementByTen())
print(incrementByTen())


