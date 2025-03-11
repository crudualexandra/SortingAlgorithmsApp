import Foundation

class InstrumentedHeapSort {
    
    private struct HSStats {
        var operations = 0
        var swaps = 0
        // HeapSort is typically not recursive, so recursionDepth=0
    }
    
    static func run(array: [Int]) -> DetailedMetrics {
        var arr = array
        var stats = HSStats()
        
        let start = CFAbsoluteTimeGetCurrent()
        heapSort(&arr, &stats)
        let end = CFAbsoluteTimeGetCurrent()
        
        return DetailedMetrics(
            algorithm: "HeapSort",
            inputSize: array.count,
            timeElapsed: end - start,
            operations: stats.operations,
            swaps: stats.swaps,
            recursionDepth: 0 // no recursion in typical heap sort
        )
    }
    
    private static func heapSort(_ arr: inout [Int], _ stats: inout HSStats) {
        let n = arr.count
        
        // build max heap
        for i in stride(from: n/2 - 1, through: 0, by: -1) {
            heapify(&arr, n, i, &stats)
        }
        // extract elements one by one
        for i in stride(from: n-1, through: 0, by: -1) {
            // swap
            arr.swapAt(0, i)
            stats.swaps += 1
            // re-heapify
            heapify(&arr, i, 0, &stats)
        }
    }
    
    private static func heapify(_ arr: inout [Int],
                                _ n: Int,
                                _ i: Int,
                                _ stats: inout HSStats) {
        var largest = i
        let left = 2*i + 1
        let right = 2*i + 2
        
        if left < n {
            stats.operations += 1 // comparing left child
            if arr[left] > arr[largest] {
                largest = left
            }
        }
        if right < n {
            stats.operations += 1 // comparing right child
            if arr[right] > arr[largest] {
                largest = right
            }
        }
        
        if largest != i {
            arr.swapAt(i, largest)
            stats.swaps += 1
            heapify(&arr, n, largest, &stats)
        }
    }
}
//
//  InstrumentedHeapSort.swift
//  SortingAlgorithms
//
//  Created by Crudu Alexandra on 11.03.2025.
//

