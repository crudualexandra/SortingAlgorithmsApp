import SwiftUI

// MARK: - Data Model for Quick Sort Steps
/// Each step records the current array state, which index is the pivot,
/// which indices were just compared or swapped, and a description.
struct QuickSortOperation {
    let array: [Int]
    let pivotIndex: Int
    let highlightIndices: [Int]
    let description: String
}

// MARK: - Quick Sort Logic (Animated)
/// A new struct to avoid conflicts with any existing QuickSort in your project.
struct QuickSortAnimatedLogic {
    
    /// Public method to run Quick Sort on the given array and return all steps.
    static func animatedQuickSort(_ array: [Int]) -> [QuickSortOperation] {
        var arr = array
        var steps = [QuickSortOperation]()
        
        // Record the initial state.
        steps.append(
            QuickSortOperation(
                array: arr,
                pivotIndex: -1,
                highlightIndices: [],
                description: "Initial array"
            )
        )
        
        quickSortHelper(&arr, low: 0, high: arr.count - 1, steps: &steps)
        return steps
    }
    
    /// Recursive helper for quicksort.
    private static func quickSortHelper(_ arr: inout [Int],
                                        low: Int,
                                        high: Int,
                                        steps: inout [QuickSortOperation]) {
        guard low < high else { return }
        
        let pivotPos = partition(&arr, low: low, high: high, steps: &steps)
        quickSortHelper(&arr, low: low, high: pivotPos - 1, steps: &steps)
        quickSortHelper(&arr, low: pivotPos + 1, high: high, steps: &steps)
    }
    
    /// Partitions the array around the pivot (chosen here as `arr[high]`).
    private static func partition(_ arr: inout [Int],
                                  low: Int,
                                  high: Int,
                                  steps: inout [QuickSortOperation]) -> Int {
        let pivotValue = arr[high]
        var i = low
        
        for j in low..<high {
            // Record the comparison step (comparing arr[j] with pivot).
            steps.append(
                QuickSortOperation(
                    array: arr,
                    pivotIndex: high,
                    highlightIndices: [j],
                    description: "Comparing arr[\(j)] (\(arr[j])) with pivot (\(pivotValue))"
                )
            )
            
            if arr[j] < pivotValue {
                // Swap arr[i] and arr[j]
                arr.swapAt(i, j)
                steps.append(
                    QuickSortOperation(
                        array: arr,
                        pivotIndex: high,
                        highlightIndices: [i, j],
                        description: "Swapped arr[\(i)] and arr[\(j)]"
                    )
                )
                i += 1
            }
        }
        
        // Move the pivot to its correct position.
        arr.swapAt(i, high)
        steps.append(
            QuickSortOperation(
                array: arr,
                pivotIndex: i,
                highlightIndices: [i, high],
                description: "Placed pivot at index \(i)"
            )
        )
        
        return i
    }
}

// MARK: - Quick Sort Animated View
struct QuickSortAnimatedView: View {
    // The list of steps after running `animatedQuickSort(_:)`.
    @State private var steps: [QuickSortOperation] = []
    
    // Track the current step being displayed.
    @State private var currentStepIndex: Int = 0
    
    // Example default input.
    @State private var inputText: String = "8, 3, 7, 4, 9, 2, 6, 5"
    
    // For matchedGeometryEffect-based animations, you can add @Namespace here,
    // but we'll keep it simpler for this example.
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Quick Sort Animation")
                .font(.largeTitle)
                .padding(.top)
            
            // Text field to input array data
            TextField("Enter numbers separated by commas", text: $inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            // Button to run Quick Sort
            Button("Run Quick Sort") {
                runQuickSort()
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
                Text("Enter data and tap 'Run Quick Sort' to see steps.")
                    .foregroundColor(.gray)
            }
            
            // Visualization of the array at the current step
            if !steps.isEmpty {
                let step = steps[currentStepIndex]
                
                HStack(spacing: 16) {
                    ForEach(Array(step.array.enumerated()), id: \.offset) { (index, value) in
                        ZStack {
                            // Decide which color to use:
                            // - Red for pivot
                            // - Yellow for highlightIndices
                            // - Blue for normal
                            if index == step.pivotIndex {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.red)
                                    .frame(width: 50, height: 50)
                            } else if step.highlightIndices.contains(index) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.yellow)
                                    .frame(width: 50, height: 50)
                            } else {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.blue)
                                    .frame(width: 50, height: 50)
                            }
                            
                            // Show the number
                            Text("\(value)")
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                    }
                }
                .padding()
                .transition(.slide)
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
        .navigationTitle("Quick Sort")
    }
    
    /// Parse user input, run quick sort, and reset the step index.
    private func runQuickSort() {
        let array = inputText
            .split(separator: ",")
            .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
        
        guard !array.isEmpty else { return }
        
        steps = QuickSortAnimatedLogic.animatedQuickSort(array)
        currentStepIndex = 0
    }
}
