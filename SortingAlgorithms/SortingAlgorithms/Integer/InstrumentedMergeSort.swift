import Foundation

class InstrumentedMergeSort {
    
    private struct MSStats {
        var operations = 0
        var swaps = 0          // We'll treat each array write as a "move"
        var currentDepth = 0
        var maxDepth = 0
        
        mutating func enterDepth() {
            currentDepth += 1
            maxDepth = max(maxDepth, currentDepth)
        }
        
        mutating func leaveDepth() {
            currentDepth -= 1
        }
    }
    
    static func run(array: [Int]) -> DetailedMetrics {
        var stats = MSStats()
        var arr = array
        
        let start = CFAbsoluteTimeGetCurrent()
        mergeSort(&arr, &stats)
        let end = CFAbsoluteTimeGetCurrent()
        
        return DetailedMetrics(
            algorithm: "MergeSort",       // Make sure this matches your chart’s color keys
            inputSize: array.count,
            timeElapsed: end - start,
            operations: stats.operations,
            swaps: stats.swaps,           // now properly counting “moves”
            recursionDepth: stats.maxDepth
        )
    }
    
    private static func mergeSort(_ arr: inout [Int],
                                  _ stats: inout MSStats) {
        mergeSortHelper(&arr, start: 0, end: arr.count - 1, stats: &stats)
    }
    
    private static func mergeSortHelper(_ arr: inout [Int],
                                        start: Int,
                                        end: Int,
                                        stats: inout MSStats) {
        if start < end {
            stats.enterDepth()
            let mid = (start + end) / 2
            mergeSortHelper(&arr, start: start, end: mid, stats: &stats)
            mergeSortHelper(&arr, start: mid + 1, end: end, stats: &stats)
            merge(&arr, start: start, mid: mid, end: end, stats: &stats)
            stats.leaveDepth()
        }
    }
    
    private static func merge(_ arr: inout [Int],
                              start: Int,
                              mid: Int,
                              end: Int,
                              stats: inout MSStats) {
        let left = Array(arr[start...mid])
        let right = Array(arr[mid+1...end])
        var i = 0, j = 0
        var k = start
        
        // Compare elements from left[] and right[]
        while i < left.count && j < right.count {
            stats.operations += 1  // counting each comparison
            if left[i] <= right[j] {
                arr[k] = left[i]
                stats.swaps += 1    // treat this as one "move"
                i += 1
            } else {
                arr[k] = right[j]
                stats.swaps += 1
                j += 1
            }
            k += 1
        }
        
        // Copy remaining from left[]
        while i < left.count {
            arr[k] = left[i]
            stats.swaps += 1
            i += 1
            k += 1
        }
        
        // Copy remaining from right[]
        while j < right.count {
            arr[k] = right[j]
            stats.swaps += 1
            j += 1
            k += 1
        }
    }
}
