struct HeapSort {
    static func sortOperations(_ array: [Int]) -> [SortOperation] {
        var arr = array
        var steps = [SortOperation]()
        
        // Record the initial state
        steps.append(SortOperation(
            array: arr,
            highlightIndices: [],
            description: "Initial array"
        ))
        
        let n = arr.count
        
        // Build max heap
        for i in stride(from: n / 2 - 1, through: 0, by: -1) {
            heapify(&arr, n, i, &steps)
        }
        
        // Extract elements from heap
        for i in stride(from: n - 1, through: 0, by: -1) {
            arr.swapAt(0, i)
            steps.append(SortOperation(
                array: arr,
                highlightIndices: [0, i],
                description: "Swapped root with index \(i)"
            ))
            heapify(&arr, i, 0, &steps)
        }
        
        return steps
    }
    
    private static func heapify(_ arr: inout [Int],
                                _ n: Int,
                                _ i: Int,
                                _ steps: inout [SortOperation]) {
        var largest = i
        let left = 2 * i + 1
        let right = 2 * i + 2
        
        // Compare with left child
        if left < n {
            steps.append(SortOperation(
                array: arr,
                highlightIndices: [i, left],
                description: "Comparing parent \(arr[i]) with left child \(arr[left])"
            ))
            if arr[left] > arr[largest] {
                largest = left
            } else {
                steps.append(SortOperation(
                    array: arr,
                    highlightIndices: [i, left],
                    description: "No swap: \(arr[i]) is larger than or equal to left child \(arr[left])"
                ))
            }
        }
        
        // Compare with right child
        if right < n {
            steps.append(SortOperation(
                array: arr,
                highlightIndices: [i, right],
                description: "Comparing parent \(arr[i]) with right child \(arr[right])"
            ))
            if arr[right] > arr[largest] {
                largest = right
            } else {
                steps.append(SortOperation(
                    array: arr,
                    highlightIndices: [i, right],
                    description: "No swap: \(arr[i]) is larger than or equal to right child \(arr[right])"
                ))
            }
        }
        
        if largest != i {
            arr.swapAt(i, largest)
            steps.append(SortOperation(
                array: arr,
                highlightIndices: [i, largest],
                description: "Swapped \(arr[largest]) and \(arr[i]) (heapify)"
            ))
            heapify(&arr, n, largest, &steps)
        } else {
            // Record that no swap was needed for this subtree
            steps.append(SortOperation(
                array: arr,
                highlightIndices: [i],
                description: "No swap needed for index \(i)"
            ))
        }
    }
}
