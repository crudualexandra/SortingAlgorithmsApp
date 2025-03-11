import SwiftUI

// MARK: - Data Model for Merge Sort Steps


struct MergeOperation {
    let left: [Int]
    let right: [Int]
    let merged: [Int]
    let description: String
}

// MARK: - Merge Sort Logic (Animated)

/// A new struct to avoid conflicts with any existing MergeSort logic in your code.
struct MergeSortAnimatedLogic {
    
    /// Generates a list of `MergeOperation` steps that describe
    /// how Merge Sort splits and merges the array.
    static func animatedMergeSort(_ array: [Int]) -> [MergeOperation] {
        var steps = [MergeOperation]()
        
        // We call our recursive helper, which fills `steps` along the way.
        _ = mergeSortRecursive(array, steps: &steps)
        
        return steps
    }
    
    /// Recursively splits the array, then merges sub-results while recording steps.
    private static func mergeSortRecursive(_ array: [Int],
                                           steps: inout [MergeOperation]) -> [Int] {
        // Base case: if the array has 0 or 1 elements, it's already sorted.
        guard array.count > 1 else { return array }
        
        let mid = array.count / 2
        let left = mergeSortRecursive(Array(array[..<mid]), steps: &steps)
        let right = mergeSortRecursive(Array(array[mid...]), steps: &steps)
        
        // Merge the two sorted halves and record the step.
        let merged = merge(left, right, steps: &steps)
        return merged
    }
    
    /// Merges two sorted sub-arrays into one sorted array.
    /// Appends a `MergeOperation` to `steps` to visualize each merge.
    private static func merge(_ left: [Int],
                              _ right: [Int],
                              steps: inout [MergeOperation]) -> [Int] {
        
        var result: [Int] = []
        var leftIndex = 0
        var rightIndex = 0
        
        // Merge by comparing front elements of `left` and `right`.
        while leftIndex < left.count, rightIndex < right.count {
            if left[leftIndex] < right[rightIndex] {
                result.append(left[leftIndex])
                leftIndex += 1
            } else {
                result.append(right[rightIndex])
                rightIndex += 1
            }
        }
        
        // Append any remaining elements.
        if leftIndex < left.count {
            result.append(contentsOf: left[leftIndex...])
        }
        if rightIndex < right.count {
            result.append(contentsOf: right[rightIndex...])
        }
        
        // Record a step showing the merge of `left` and `right` into `result`.
        let description = "Merging \(left) and \(right) → \(result)"
        let operation = MergeOperation(
            left: left,
            right: right,
            merged: result,
            description: description
        )
        steps.append(operation)
        
        return result
    }
}

// MARK: - Merge Sort Animated View

struct MergeSortAnimatedView: View {
    // The list of steps we generate after calling `animatedMergeSort(_:)`.
    @State private var steps: [MergeOperation] = []
    
    // Track the current step being displayed.
    @State private var currentStepIndex: Int = 0
    
    // Example default input
    @State private var inputText: String = "3,7,8,5,2,6,4,1"
    
    // For a fancier approach, you can use matchedGeometryEffect, but here
    // we'll keep it simpler and just do step-based transitions.
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Merge Sort Animation")
                .font(.largeTitle)
                .padding(.top)
            
            // Text field to input the array
            TextField("Enter numbers separated by commas", text: $inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            // Button to run Merge Sort
            Button("Run Merge Sort") {
                runMergeSort()
            }
            .padding()
            .background(Color.blue.opacity(0.2))
            .cornerRadius(8)
            
            // Show the current step's description
            if !steps.isEmpty {
                Text(steps[currentStepIndex].description)
                    .font(.headline)
                    .padding(.horizontal)
            } else {
                Text("Enter data and tap 'Run Merge Sort' to see the steps.")
                    .foregroundColor(.gray)
            }
            
            // Show the sub-arrays and the merged result
            if !steps.isEmpty {
                let step = steps[currentStepIndex]
                
                VStack(spacing: 8) {
                    // Left array
                    Text("Left Sub-array")
                    HStack {
                        ForEach(step.left, id: \.self) { num in
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.green)
                                .frame(width: 40, height: 40)
                                .overlay(Text("\(num)").foregroundColor(.white))
                        }
                    }
                    
                    // Right array
                    Text("Right Sub-array")
                    HStack {
                        ForEach(step.right, id: \.self) { num in
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.orange)
                                .frame(width: 40, height: 40)
                                .overlay(Text("\(num)").foregroundColor(.white))
                        }
                    }
                    
                    // Merged array
                    Text("Merged Result")
                    HStack {
                        ForEach(step.merged, id: \.self) { num in
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.blue)
                                .frame(width: 40, height: 40)
                                .overlay(Text("\(num)").foregroundColor(.white))
                        }
                    }
                }
                .padding(.vertical)
                .transition(.scale) // Simple transition
            }
            
            // Navigation for steps
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
        .navigationTitle("Merge Sort")
    }
    
    /// Reads the user input, parses it into an array, and generates merge sort steps.
    private func runMergeSort() {
        let array = inputText
            .split(separator: ",")
            .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
        
        guard !array.isEmpty else { return }
        
        steps = MergeSortAnimatedLogic.animatedMergeSort(array)
        currentStepIndex = 0
    }
}
