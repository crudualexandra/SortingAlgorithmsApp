import Foundation

class InstrumentedBubbleSort {
    
    private struct BSStats {
        var operations = 0
        var swaps = 0
    }
    
    static func run(array: [Int]) -> DetailedMetrics {
        var arr = array
        var stats = BSStats()
        
        let start = CFAbsoluteTimeGetCurrent()
        bubbleSort(&arr, &stats)
        let end = CFAbsoluteTimeGetCurrent()
        
        return DetailedMetrics(
            algorithm: "BubbleSort",
            inputSize: array.count,
            timeElapsed: end - start,
            operations: stats.operations,
            swaps: stats.swaps,
            recursionDepth: 0 // BubbleSort is not recursive
        )
    }
    
    private static func bubbleSort(_ arr: inout [Int], _ stats: inout BSStats) {
        let n = arr.count
        for i in 0..<(n - 1) {
            for j in 0..<(n - i - 1) {
                stats.operations += 1 // comparison
                if arr[j] > arr[j+1] {
                    arr.swapAt(j, j+1)
                    stats.swaps += 1
                }
            }
        }
    }
}
//
//  InstrumentedBubbleSort.swift
//  SortingAlgorithms
//
//  Created by Crudu Alexandra on 11.03.2025.
//

