//
//  InstrumentedBubbleSortFloat .swift
//  SortingAlgorithms
//
//  Created by Crudu Alexandra on 11.03.2025.
//

import Foundation

class InstrumentedBubbleSortFloat {
    
    private struct BSStats {
        var operations = 0  // comparisons
        var swaps = 0       // swaps
    }
    
    static func run(array: [Double]) -> DetailedMetrics {
        var stats = BSStats()
        var arr = array
        
        let start = CFAbsoluteTimeGetCurrent()
        bubbleSort(&arr, &stats)
        let end = CFAbsoluteTimeGetCurrent()
        
        return DetailedMetrics(
            algorithm: "BubbleSort",
            inputSize: arr.count,
            timeElapsed: end - start,
            operations: stats.operations,
            swaps: stats.swaps,
            recursionDepth: 0
        )
    }
    
    private static func bubbleSort(_ arr: inout [Double],
                                   _ stats: inout BSStats) {
        let n = arr.count
        for i in 0..<(n - 1) {
            for j in 0..<(n - i - 1) {
                // comparison
                stats.operations += 1
                if arr[j] > arr[j + 1] {
                    // swap
                    arr.swapAt(j, j + 1)
                    stats.swaps += 1
                }
            }
        }
    }
}
