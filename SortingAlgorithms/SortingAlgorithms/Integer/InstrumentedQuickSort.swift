//
//  InstrumentedQuickSort.swift
//  SortingAlgorithms
//
//  Created by Crudu Alexandra on 11.03.2025.
//


import Foundation

class InstrumentedQuickSort {
    
    // We’ll define a nested helper struct to store counters for a single run.
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
    
    /// Sorts `array` using QuickSort, returning DetailedMetrics (time, ops, swaps, recursionDepth).
    static func run(array: [Int]) -> DetailedMetrics {
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
    
    private static func quicksort(_ arr: inout [Int],
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
    
    private static func partition(_ arr: inout [Int],
                                  low: Int,
                                  high: Int,
                                  stats: inout QSStats) -> Int {
        let pivot = arr[high]
        var i = low
        
        for j in low..<high {
            stats.operations += 1  // Count a "comparison" operation
            if arr[j] < pivot {
                arr.swapAt(i, j)
                stats.swaps += 1
                i += 1
            }
        }
        // Final swap to move pivot
        arr.swapAt(i, high)
        stats.swaps += 1
        
        return i
    }
}
