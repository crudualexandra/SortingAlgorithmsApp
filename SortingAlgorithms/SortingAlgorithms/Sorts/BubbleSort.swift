import Foundation

/// A basic Bubble Sort implementation that records every comparison and swap (or no swap).
struct BubbleSort {
    
    /// Returns an array of `SortOperation` steps describing the Bubble Sort process.
    static func sortOperations(_ array: [Int]) -> [SortOperation] {
        var arr = array
        var steps = [SortOperation]()
        
        // Record the initial state
        steps.append(
            SortOperation(
                array: arr,
                highlightIndices: [],
                description: "Initial array"
            )
        )
        
        for i in 0..<arr.count {
            for j in 0..<arr.count - i - 1 {
                // Record the comparison step
                steps.append(
                    SortOperation(
                        array: arr,
                        highlightIndices: [j, j+1],
                        description: "Comparing indices \(j) and \(j+1)"
                    )
                )
                
                // Perform the swap if needed
                if arr[j] > arr[j+1] {
                    arr.swapAt(j, j+1)
                    steps.append(
                        SortOperation(
                            array: arr,
                            highlightIndices: [j, j+1],
                            description: "Swapped elements at indices \(j) and \(j+1)"
                        )
                    )
                } else {
                    // Record step when no swap occurs
                    steps.append(
                        SortOperation(
                            array: arr,
                            highlightIndices: [j, j+1],
                            description: "No swap needed for indices \(j) and \(j+1)"
                        )
                    )
                }
            }
        }
        
        return steps
    }
}
