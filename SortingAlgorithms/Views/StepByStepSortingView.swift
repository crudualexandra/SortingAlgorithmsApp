import SwiftUI

struct StepByStepSortingView: View {
    @State private var userInput: String = ""
    @State private var selectedAlgorithm: String = "QuickSort"
    @State private var steps: [SortOperation] = []
    @State private var currentStepIndex: Int = 0
    
    let algorithms = ["QuickSort", "MergeSort", "HeapSort", "BubbleSort"]
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Step-by-Step Sorting")
                .font(.title2)
                .padding(.top)
            
            // User input
            TextField("Enter numbers separated by commas", text: $userInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            // Algorithm picker
            Picker("Algorithm", selection: $selectedAlgorithm) {
                ForEach(algorithms, id: \.self) { algo in
                    Text(algo)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            // Sort button
            Button("Sort") {
                performSort()
            }
            .padding()
            
            // Main visualization
            if steps.isEmpty {
                Text("Enter data and tap Sort to see steps.")
                    .foregroundColor(.gray)
            } else {
                // Show the current step's description
                Text(steps[currentStepIndex].description)
                    .font(.headline)
                    .padding(.bottom, 8)
                
                // Display the array elements horizontally
                HStack(spacing: 8) {
                    ForEach(steps[currentStepIndex].array.indices, id: \.self) { index in
                        Text("\(steps[currentStepIndex].array[index])")
                            .padding()
                            .background(
                                steps[currentStepIndex].highlightIndices.contains(index)
                                    ? Color.yellow
                                    : Color.clear
                            )
                            .cornerRadius(8)
                            // Animate the changes
                            .animation(.easeInOut, value: steps[currentStepIndex].array)
                    }
                }
                
                // Step navigation
                HStack {
                    Button("Previous") {
                        if currentStepIndex > 0 {
                            withAnimation {
                                currentStepIndex -= 1
                            }
                        }
                    }
                    .disabled(currentStepIndex == 0)
                    
                    Spacer()
                    
                    Button("Next") {
                        if currentStepIndex < steps.count - 1 {
                            withAnimation {
                                currentStepIndex += 1
                            }
                        }
                    }
                    .disabled(currentStepIndex == steps.count - 1)
                }
                .padding(.horizontal)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Step-by-Step Sorting")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func performSort() {
        // Convert comma-separated input to an array of Int
        let array = userInput
            .split(separator: ",")
            .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
        
        steps.removeAll()
        currentStepIndex = 0
        
        guard !array.isEmpty else { return }
        
        // Use the new "sortOperations" function for each algorithm
        switch selectedAlgorithm {
        case "QuickSort":
            steps = QuickSort.sortOperations(array)
        case "MergeSort":
            steps = MergeSort.sortOperations(array)
        case "HeapSort":
            steps = HeapSort.sortOperations(array)
        case "BubbleSort":
            steps = BubbleSort.sortOperations(array)
        default:
            break
        }
        
        // If no steps or the array was empty, at least show the original
        if steps.isEmpty {
            steps = [SortOperation(
                array: array,
                highlightIndices: [],
                description: "No changes recorded."
            )]
        }
    }
}

struct StepByStepSortingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            StepByStepSortingView()
        }
    }
}
