struct BubbleSort {
    static func sortOperations(_ array: [Int]) -> [SortOperation] {
        var arr = array
        var steps = [SortOperation]()
        
        // Record the initial state
        steps.append(SortOperation(
            array: arr,
            highlightIndices: [],
            description: "Initial array"
        ))
        
        for i in 0..<arr.count {
            for j in 0..<arr.count - i - 1 {
                // Record the comparison step even before checking for a swap
                if arr[j] > arr[j+1] {
                    // Swap when needed and record the operation
                    arr.swapAt(j, j+1)
                    steps.append(SortOperation(
                        array: arr,
                        highlightIndices: [j, j+1],
                        description: "Compared indices \(j) and \(j+1): swapped \(arr[j]) with \(arr[j+1])"
                    ))
                } else {
                    // No swap: record that the comparison was made but no change occurred.
                    steps.append(SortOperation(
                        array: arr,
                        highlightIndices: [j, j+1],
                        description: "Compared indices \(j) and \(j+1): no swap needed"
                    ))
                }
            }
        }
        
        return steps
    }
}
