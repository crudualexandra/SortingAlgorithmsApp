import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Sorting Algorithms")
                    .font(.largeTitle)
                    .padding()

                // Compare Algorithms
                NavigationLink(destination: CompareAlgorithmsView()) {
                    Text("Compare Algorithms")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                }
                
                // Step-by-Step Sorting
//                NavigationLink(destination: StepByStepSortingView()) {
//                    Text("Step-by-Step Sorting")
//                        .font(.headline)
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(Color.green.opacity(0.2))
//                        .cornerRadius(8)
//                }

                // NEW LINK: Bubble Sort Animation
                NavigationLink(destination: BubbleSortAnimatedView()) {
                    Text("Animated Bubble Sort")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange.opacity(0.2))
                        .cornerRadius(8)
                }
                NavigationLink(destination: MergeSortAnimatedView()) {
                                    Text("Merge Sort Animation")
                                        .font(.headline)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.purple.opacity(0.2))
                                        .cornerRadius(8)
                                }
                NavigationLink(destination: QuickSortAnimatedView()) {
                                    Text("Quick Sort Animation")
                                        .font(.headline)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.red.opacity(0.2))
                                        .cornerRadius(8)
                                }
                NavigationLink(destination: HeapSortAnimatedView()) {
                                    Text("Heap Sort Animation")
                                        .font(.headline)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.yellow.opacity(0.2))
                                        .cornerRadius(8)
                                }

                Spacer()
            }
            .padding()
            .navigationTitle("Home")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
