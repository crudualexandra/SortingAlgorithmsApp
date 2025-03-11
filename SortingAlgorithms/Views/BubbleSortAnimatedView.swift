import SwiftUI

/// If you already have a `SortOperation` struct in your project,
/// you can delete this definition and reuse the existing one.
/// Just make sure the property names match.


/// A new Bubble Sort logic struct to avoid naming conflicts
/// with any existing `BubbleSort` struct in your project.
struct BubbleSortAnimatedLogic {
    static func animatedSortOperations(_ array: [Int]) -> [SortOperation] {
        var arr = array
        var steps = [SortOperation]()
        
        // Record the initial state
        steps.append(
            SortOperation(array: arr,
                          highlightIndices: [],
                          description: "Initial array")
        )
        
        for i in 0..<arr.count {
            for j in 0..<arr.count - i - 1 {
                // Record the comparison
                steps.append(
                    SortOperation(array: arr,
                                  highlightIndices: [j, j+1],
                                  description: "Comparing indices \(j) and \(j+1)")
                )
                
                // Swap if needed
                if arr[j] > arr[j+1] {
                    arr.swapAt(j, j+1)
                    steps.append(
                        SortOperation(array: arr,
                                      highlightIndices: [j, j+1],
                                      description: "Swapped indices \(j) and \(j+1)")
                    )
                } else {
                    // Record no swap
                    steps.append(
                        SortOperation(array: arr,
                                      highlightIndices: [j, j+1],
                                      description: "No swap at indices \(j) and \(j+1)")
                    )
                }
            }
        }
        
        return steps
    }
}

/// A SwiftUI view that shows the animated bubble sort visualization.
struct BubbleSortAnimatedView: View {
    @State private var steps: [SortOperation] = []
    @State private var currentStepIndex: Int = 0
    @Namespace private var animationNamespace
    
    /// A default example input. You can change this as needed.
    @State private var inputText: String = "8, 5, 2, 9, 1, 6"
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Bubble Sort Animation")
                .font(.largeTitle)
                .padding(.top)
            
            // Text field to enter array data
            TextField("Enter numbers separated by commas", text: $inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            // Button to run the animated bubble sort
            Button("Run Bubble Sort") {
                runBubbleSort()
            }
            .padding()
            .background(Color.blue.opacity(0.2))
            .cornerRadius(8)
            
            // Current step description
            if !steps.isEmpty {
                Text(steps[currentStepIndex].description)
                    .font(.headline)
                    .padding()
            }
            
            // Visualization of the current array state
            if !steps.isEmpty {
                HStack(spacing: 16) {
                    ForEach(Array(steps[currentStepIndex].array.enumerated()), id: \.offset) { (index, value) in
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(
                                    steps[currentStepIndex].highlightIndices.contains(index)
                                    ? Color.yellow
                                    : Color.blue
                                )
                                .frame(width: 50, height: 50)
                            
                            Text("\(value)")
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                        // Use matchedGeometryEffect for smooth transitions
                        .matchedGeometryEffect(id: "\(value)-\(index)", in: animationNamespace)
                    }
                }
                .padding()
                // Animate changes in the array
                .animation(.easeInOut, value: steps[currentStepIndex].array)
            }
            
            // Navigation between steps
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
        .navigationTitle("Bubble Sort")
    }
    
    /// Parses input text, generates sort steps, and resets the current step.
    private func runBubbleSort() {
        let array = inputText
            .split(separator: ",")
            .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
        
        guard !array.isEmpty else { return }
        
        steps = BubbleSortAnimatedLogic.animatedSortOperations(array)
        currentStepIndex = 0
    }
}
