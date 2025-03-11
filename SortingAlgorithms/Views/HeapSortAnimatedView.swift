import SwiftUI

// MARK: - Data Model for Heap Sort Steps

/// Each step shows the current array (representing a heap),
/// which indices are being compared or swapped, and a description.
struct HeapSortOperation {
    let array: [Int]
    let highlightIndices: [Int]
    let description: String
}

// MARK: - Heap Sort Logic (Animated)

/// A new struct to avoid conflicts with any existing `HeapSort` in your project.
struct HeapSortAnimatedLogic {
    
    /// Returns an array of steps (HeapSortOperation) describing
    /// the build-max-heap and sorting phases.
    static func animatedHeapSort(_ array: [Int]) -> [HeapSortOperation] {
        var arr = array
        var steps = [HeapSortOperation]()
        
        // Initial array state
        steps.append(
            HeapSortOperation(array: arr,
                              highlightIndices: [],
                              description: "Initial array")
        )
        
        let n = arr.count
        
        // 1) Build max heap
        for i in stride(from: n / 2 - 1, through: 0, by: -1) {
            heapify(&arr, n, i, &steps)
        }
        
        // 2) Extract elements from heap one by one
        for i in stride(from: n - 1, through: 0, by: -1) {
            // Move current root to the end
            arr.swapAt(0, i)
            steps.append(
                HeapSortOperation(
                    array: arr,
                    highlightIndices: [0, i],
                    description: "Swapped root (\(arr[i])) with element at index \(i)"
                )
            )
            
            // Call max heapify on the reduced heap
            heapify(&arr, i, 0, &steps)
        }
        
        return steps
    }
    
    /// Maintains the max-heap property at index `i` within array size `n`.
    private static func heapify(_ arr: inout [Int],
                                _ n: Int,
                                _ i: Int,
                                _ steps: inout [HeapSortOperation]) {
        var largest = i
        let left = 2 * i + 1
        let right = 2 * i + 2
        
        // Compare left child
        if left < n {
            // Record the comparison
            steps.append(
                HeapSortOperation(
                    array: arr,
                    highlightIndices: [i, left],
                    description: "Comparing parent arr[\(i)] (\(arr[i])) with left child arr[\(left)] (\(arr[left]))"
                )
            )
            if arr[left] > arr[largest] {
                largest = left
            }
        }
        
        // Compare right child
        if right < n {
            // Record the comparison
            steps.append(
                HeapSortOperation(
                    array: arr,
                    highlightIndices: [i, right],
                    description: "Comparing parent arr[\(i)] (\(arr[i])) with right child arr[\(right)] (\(arr[right]))"
                )
            )
            if arr[right] > arr[largest] {
                largest = right
            }
        }
        
        // If largest is not the parent, swap and continue heapifying
        if largest != i {
            arr.swapAt(i, largest)
            steps.append(
                HeapSortOperation(
                    array: arr,
                    highlightIndices: [i, largest],
                    description: "Swapped arr[\(i)] (\(arr[largest])) with arr[\(largest)] (\(arr[i]))"
                )
            )
            
            heapify(&arr, n, largest, &steps)
        } else {
            // Record that no swap was needed
            steps.append(
                HeapSortOperation(
                    array: arr,
                    highlightIndices: [i],
                    description: "No swap needed at index \(i)"
                )
            )
        }
    }
}

// MARK: - Heap Sort Animated View

struct HeapSortAnimatedView: View {
    // The list of steps describing the entire heap sort process
    @State private var steps: [HeapSortOperation] = []
    
    // Track the current step being displayed
    @State private var currentStepIndex: Int = 0
    
    // Example default input
    @State private var inputText: String = "11, 5, 12, 8, 7, 9, 2, 10, 1, 3, 6, 4"
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Heap Sort Animation")
                .font(.largeTitle)
                .padding(.top)
            
            // Text field to input the array
            TextField("Enter numbers separated by commas", text: $inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            // Button to run Heap Sort
            Button("Run Heap Sort") {
                runHeapSort()
            }
            .padding()
            .background(Color.blue.opacity(0.2))
            .cornerRadius(8)
            
            // Display the current step's description
            if !steps.isEmpty {
                Text(steps[currentStepIndex].description)
                    .font(.headline)
                    .padding(.horizontal)
            } else {
                Text("Enter data and tap 'Run Heap Sort' to see steps.")
                    .foregroundColor(.gray)
            }
            
            // Visualize the heap as a tree
            if !steps.isEmpty {
                let step = steps[currentStepIndex]
                let levels = heapLevels(for: step.array)
                
                VStack(spacing: 20) {
                    ForEach(levels.indices, id: \.self) { levelIndex in
                        HStack(spacing: 24) {
                            ForEach(levels[levelIndex], id: \.0) { (index, value) in
                                ZStack {
                                    // Highlight if index is in highlightIndices
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(step.highlightIndices.contains(index) ? Color.yellow : Color.blue)
                                        .frame(width: 40, height: 40)
                                    
                                    Text("\(value)")
                                        .foregroundColor(.white)
                                        .font(.headline)
                                }
                            }
                        }
                    }
                }
                .padding()
                .transition(.scale)
            }
            
            // Step navigation
            if !steps.isEmpty {
                HStack {
                    Button("Previous") {
                        guard currentStepIndex > 0 else { return }
                        withAnimation {
                            currentStepIndex -= 1
                        }
                    }
                    .disabled(currentStepIndex == 0)
                    
                    Spacer()
                    
                    Button("Next") {
                        guard currentStepIndex < steps.count - 1 else { return }
                        withAnimation {
                            currentStepIndex += 1
                        }
                    }
                    .disabled(currentStepIndex == steps.count - 1)
                }
                .padding(.horizontal)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Heap Sort")
    }
    
    /// Parses user input and runs the animated heap sort logic.
    private func runHeapSort() {
        let array = inputText
            .split(separator: ",")
            .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
        
        guard !array.isEmpty else { return }
        
        steps = HeapSortAnimatedLogic.animatedHeapSort(array)
        currentStepIndex = 0
    }
    
    /// Helper function to group the array into levels for tree visualization.
    /// Index 0 is the root, indices 1 and 2 are level 1, etc.
    private func heapLevels(for array: [Int]) -> [[(Int, Int)]] {
        var result = [[(Int, Int)]]()
        
        var levelStart = 0
        var levelSize = 1
        
        while levelStart < array.count {
            let levelIndices = levelStart..<min(levelStart + levelSize, array.count)
            let level = levelIndices.map { ($0, array[$0]) }
            
            result.append(level)
            levelStart += levelSize
            levelSize *= 2
        }
        
        return result
    }
}
