struct QuickSort {
    static func sortOperations(_ array: [Int]) -> [SortOperation] {
        var arr = array
        var steps = [SortOperation]()
        
        // Record initial array state
        steps.append(SortOperation(
            array: arr,
            highlightIndices: [],
            description: "Initial array"
        ))
        
        quicksortHelper(&arr, low: 0, high: arr.count - 1, steps: &steps)
        return steps
    }
    
    private static func quicksortHelper(_ arr: inout [Int],
                                        low: Int,
                                        high: Int,
                                        steps: inout [SortOperation]) {
        if low < high {
            let pivotIndex = partition(&arr, low: low, high: high, steps: &steps)
            quicksortHelper(&arr, low: low, high: pivotIndex - 1, steps: &steps)
            quicksortHelper(&arr, low: pivotIndex + 1, high: high, steps: &steps)
        }
    }
    
    private static func partition(_ arr: inout [Int],
                                  low: Int,
                                  high: Int,
                                  steps: inout [SortOperation]) -> Int {
        let pivot = arr[high]
        var i = low
        
        for j in low..<high {
            // Record the comparison for each element against the pivot
            steps.append(SortOperation(
                array: arr,
                highlightIndices: [j],
                description: "Comparing element at index \(j) (\(arr[j])) with pivot (\(pivot))"
            ))
            if arr[j] < pivot {
                arr.swapAt(i, j)
                steps.append(SortOperation(
                    array: arr,
                    highlightIndices: [i, j],
                    description: "Swapped elements at indices \(i) and \(j) (pivot = \(pivot))"
                ))
                i += 1
            } else {
                // Record when no swap is done
                steps.append(SortOperation(
                    array: arr,
                    highlightIndices: [j],
                    description: "No swap: element at index \(j) (\(arr[j])) >= pivot (\(pivot))"
                ))
            }
        }
        // Move pivot into its correct position
        arr.swapAt(i, high)
        steps.append(SortOperation(
            array: arr,
            highlightIndices: [i, high],
            description: "Moved pivot to index \(i)"
        ))
        return i
    }
}
