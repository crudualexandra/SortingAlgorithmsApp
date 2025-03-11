import Foundation

class InstrumentedQuickSortFloat {
    
    private struct QSStats {
        var operations = 0
        var swaps = 0
        var currentRecursionDepth = 0
        var maxRecursionDepth = 0
        
        mutating func incrementDepth() {
            currentRecursionDepth += 1
            maxRecursionDepth = max(maxRecursionDepth, currentRecursionDepth)
        }
        
        mutating func decrementDepth() {
            currentRecursionDepth -= 1
        }
    }
    
    static func run(array: [Double]) -> DetailedMetrics {
        var stats = QSStats()
        var arr = array
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        quicksort(&arr, low: 0, high: arr.count - 1, stats: &stats)
        
        let endTime = CFAbsoluteTimeGetCurrent()
        let totalTime = endTime - startTime
        
        return DetailedMetrics(
            algorithm: "QuickSort",
            inputSize: arr.count,
            timeElapsed: totalTime,
            operations: stats.operations,
            swaps: stats.swaps,
            recursionDepth: stats.maxRecursionDepth
        )
    }
    
    private static func quicksort(_ arr: inout [Double],
                                  low: Int,
                                  high: Int,
                                  stats: inout QSStats) {
        if low < high {
            stats.incrementDepth()
            let pivot = partition(&arr, low: low, high: high, stats: &stats)
            quicksort(&arr, low: low, high: pivot - 1, stats: &stats)
            quicksort(&arr, low: pivot + 1, high: high, stats: &stats)
            stats.decrementDepth()
        }
    }
    
    private static func partition(_ arr: inout [Double],
                                  low: Int,
                                  high: Int,
                                  stats: inout QSStats) -> Int {
        let pivot = arr[high]
        var i = low
        
        for j in low..<high {
            stats.operations += 1 // comparison
            if arr[j] < pivot {
                arr.swapAt(i, j)
                stats.swaps += 1
                i += 1
            }
        }
        arr.swapAt(i, high)
        stats.swaps += 1
        
        return i
    }
}
