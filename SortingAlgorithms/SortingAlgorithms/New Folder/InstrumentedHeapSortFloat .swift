//
//  InstrumentedHeapSortFloat .swift
//  SortingAlgorithms
//
//  Created by Crudu Alexandra on 11.03.2025.
//

import Foundation

class InstrumentedHeapSortFloat {
    
    private struct HSStats {
        var operations = 0   // e.g., comparisons in heapify
        var swaps = 0        // each time we swap elements in the array
        // heap sort is typically iterative, so recursionDepth = 0
    }
    
    static func run(array: [Double]) -> DetailedMetrics {
        var stats = HSStats()
        var arr = array
        
        let start = CFAbsoluteTimeGetCurrent()
        heapSort(&arr, &stats)
        let end = CFAbsoluteTimeGetCurrent()
        
        return DetailedMetrics(
            algorithm: "HeapSort",
            inputSize: arr.count,
            timeElapsed: end - start,
            operations: stats.operations,
            swaps: stats.swaps,
            recursionDepth: 0
        )
    }
    
    // MARK: - HeapSort
    
    private static func heapSort(_ arr: inout [Double],
                                 _ stats: inout HSStats) {
        let n = arr.count
        
        // build max heap
        for i in stride(from: n/2 - 1, through: 0, by: -1) {
            heapify(&arr, n, i, &stats)
        }
        
        // one by one extract elements
        for i in stride(from: n - 1, through: 0, by: -1) {
            // move current root to end
            arr.swapAt(0, i)
            stats.swaps += 1
            // call max heapify on the reduced heap
            heapify(&arr, i, 0, &stats)
        }
    }
    
    private static func heapify(_ arr: inout [Double],
                                _ n: Int,
                                _ i: Int,
                                _ stats: inout HSStats) {
        var largest = i
        let left = 2 * i + 1
        let right = 2 * i + 2
        
        if left < n {
            stats.operations += 1  // comparing arr[left] > arr[largest]?
            if arr[left] > arr[largest] {
                largest = left
            }
        }
        if right < n {
            stats.operations += 1  // comparing arr[right] > arr[largest]?
            if arr[right] > arr[largest] {
                largest = right
            }
        }
        
        // If largest is not root
        if largest != i {
            arr.swapAt(i, largest)
            stats.swaps += 1
            // recursively heapify the affected sub-tree
            heapify(&arr, n, largest, &stats)
        }
    }
}

