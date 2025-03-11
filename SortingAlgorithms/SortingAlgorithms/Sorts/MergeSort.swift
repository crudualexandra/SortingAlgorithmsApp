struct MergeSort {
    static func sortOperations(_ array: [Int]) -> [SortOperation] {
        var arr = array
        var steps = [SortOperation]()
        
        // Record the initial state
        steps.append(SortOperation(
            array: arr,
            highlightIndices: [],
            description: "Initial array"
        ))
        
        mergeSortHelper(&arr, start: 0, end: arr.count - 1, steps: &steps)
        return steps
    }
    
    private static func mergeSortHelper(_ arr: inout [Int],
                                        start: Int,
                                        end: Int,
                                        steps: inout [SortOperation]) {
        guard start < end else { return }
        let mid = (start + end) / 2
        mergeSortHelper(&arr, start: start, end: mid, steps: &steps)
        mergeSortHelper(&arr, start: mid + 1, end: end, steps: &steps)
        merge(&arr, start: start, mid: mid, end: end, steps: &steps)
    }
    
    private static func merge(_ arr: inout [Int],
                              start: Int,
                              mid: Int,
                              end: Int,
                              steps: inout [SortOperation]) {
        let leftArray = Array(arr[start...mid])
        let rightArray = Array(arr[mid+1...end])
        
        var i = 0
        var j = 0
        var k = start
        
        while i < leftArray.count && j < rightArray.count {
            // Record the comparison between left and right values
            steps.append(SortOperation(
                array: arr,
                highlightIndices: [],
                description: "Comparing \(leftArray[i]) (left) with \(rightArray[j]) (right)"
            ))
            if leftArray[i] <= rightArray[j] {
                arr[k] = leftArray[i]
                steps.append(SortOperation(
                    array: arr,
                    highlightIndices: [k],
                    description: "Copied \(leftArray[i]) from left to index \(k)"
                ))
                i += 1
            } else {
                arr[k] = rightArray[j]
                steps.append(SortOperation(
                    array: arr,
                    highlightIndices: [k],
                    description: "Copied \(rightArray[j]) from right to index \(k)"
                ))
                j += 1
            }
            k += 1
        }
        
        // Copy any remaining elements from left
        while i < leftArray.count {
            arr[k] = leftArray[i]
            steps.append(SortOperation(
                array: arr,
                highlightIndices: [k],
                description: "Copied \(leftArray[i]) from left to index \(k)"
            ))
            i += 1
            k += 1
        }
        
        // Copy any remaining elements from right
        while j < rightArray.count {
            arr[k] = rightArray[j]
            steps.append(SortOperation(
                array: arr,
                highlightIndices: [k],
                description: "Copied \(rightArray[j]) from right to index \(k)"
            ))
            j += 1
            k += 1
        }
    }
}
