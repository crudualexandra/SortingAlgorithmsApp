import SwiftUI
import Charts

struct CompareAlgorithmsView: View {
    // Results for integer data
    @State private var allIntResults: [DetailedMetrics] = []
    // Results for float data
    @State private var allFloatResults: [DetailedMetrics] = []
    
    // Input sizes for both int and float
    let sizesToTest = [50, 100, 500, 1000]
    
    // Instrumented sorts for Int
    private let intAlgorithmRunners: [(String, ([Int]) -> DetailedMetrics)] = [
        ("QuickSort",  { arr in InstrumentedQuickSort.run(array: arr) }),
        ("MergeSort",  { arr in InstrumentedMergeSort.run(array: arr) }),
        ("HeapSort",   { arr in InstrumentedHeapSort.run(array: arr) }),
        ("BubbleSort", { arr in InstrumentedBubbleSort.run(array: arr) })
    ]
    
    // Instrumented sorts for Float
    private let floatAlgorithmRunners: [(String, ([Double]) -> DetailedMetrics)] = [
        ("QuickSort",  { arr in InstrumentedQuickSortFloat.run(array: arr) }),
        ("MergeSort",  { arr in InstrumentedMergeSortFloat.run(array: arr) }),
        ("HeapSort",   { arr in InstrumentedHeapSortFloat.run(array: arr) }),
        ("BubbleSort", { arr in InstrumentedBubbleSortFloat.run(array: arr) })
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Compare Sorting Algorithms (Multiple Input Sizes)")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                
                Button("Run Analysis") {
                    runAnalysis()
                }
                .buttonStyle(.borderedProminent)
                
                // --- Integer Section ---
                if allIntResults.isEmpty {
                    Text("No integer results yet. Tap 'Run Analysis'.")
                        .foregroundColor(.gray)
                } else {
                    Text("Integer Data Analysis")
                        .font(.headline)
                    
                    intTableAndChart()
                }
                
                // --- Float Section ---
                if allFloatResults.isEmpty {
                    Text("No float results yet. Tap 'Run Analysis'.")
                        .foregroundColor(.gray)
                } else {
                    Text("Float Data Analysis")
                        .font(.headline)
                    
                    floatTableAndChart()
                }
            }
            .padding()
        }
        .navigationTitle("Compare Algorithms")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Table + Chart for INT
    @ViewBuilder
    private func intTableAndChart() -> some View {
        // Multi-axis scrollable table
        ScrollView([.horizontal, .vertical]) {
            VStack(alignment: .leading, spacing: 4) {
                // Header
                HStack(spacing: 4) {
                    Text("Algorithm").bold().frame(width: 100, alignment: .leading)
                    Text("Size").bold().frame(width: 60, alignment: .trailing)
                    Text("Time (s)").bold().frame(width: 80, alignment: .trailing)
                    Text("Ops").bold().frame(width: 80, alignment: .trailing)
                    Text("Swaps").bold().frame(width: 80, alignment: .trailing)
                    Text("Depth").bold().frame(width: 60, alignment: .trailing)
                }
                .font(.headline)
                
                Divider()
                
                // Rows
                ForEach(allIntResults) { metrics in
                    HStack(spacing: 4) {
                        Text(metrics.algorithm)
                            .frame(width: 100, alignment: .leading)
                        Text("\(metrics.inputSize)")
                            .frame(width: 60, alignment: .trailing)
                        Text(String(format: "%.6f", metrics.timeElapsed))
                            .frame(width: 80, alignment: .trailing)
                        Text("\(metrics.operations)")
                            .frame(width: 80, alignment: .trailing)
                        Text("\(metrics.swaps)")
                            .frame(width: 80, alignment: .trailing)
                        Text("\(metrics.recursionDepth)")
                            .frame(width: 60, alignment: .trailing)
                    }
                    .font(.caption)
                    .lineLimit(1)
                }
            }
            .padding(4)
        }
        .frame(maxHeight: 220) // Constrain visible area; scroll to see more content
        
        // Chart
        Chart {
            ForEach(allIntResults) { entry in
                LineMark(
                    x: .value("Input Size", entry.inputSize),
                    y: .value("Time (s)", entry.timeElapsed),
                    series: .value("Algorithm", entry.algorithm)
                )
                .symbol(by: .value("Algorithm", entry.algorithm))
            }
        }
        .chartForegroundStyleScale([
            "QuickSort": .blue,
            "MergeSort": .blue,
            "HeapSort":  .blue,
            "BubbleSort": .blue
        ])
        .chartLegend(.visible)
        .frame(height: 200)
        .padding(.vertical, 4)
    }
    
    // MARK: - Table + Chart for FLOAT
    @ViewBuilder
    private func floatTableAndChart() -> some View {
        // Multi-axis scrollable table
        ScrollView([.horizontal, .vertical]) {
            VStack(alignment: .leading, spacing: 4) {
                // Header
                HStack(spacing: 4) {
                    Text("Algorithm").bold().frame(width: 100, alignment: .leading)
                    Text("Size").bold().frame(width: 60, alignment: .trailing)
                    Text("Time (s)").bold().frame(width: 80, alignment: .trailing)
                    Text("Ops").bold().frame(width: 80, alignment: .trailing)
                    Text("Swaps").bold().frame(width: 80, alignment: .trailing)
                    Text("Depth").bold().frame(width: 60, alignment: .trailing)
                }
                .font(.headline)
                
                Divider()
                
                // Rows
                ForEach(allFloatResults) { metrics in
                    HStack(spacing: 4) {
                        Text(metrics.algorithm)
                            .frame(width: 100, alignment: .leading)
                        Text("\(metrics.inputSize)")
                            .frame(width: 60, alignment: .trailing)
                        Text(String(format: "%.6f", metrics.timeElapsed))
                            .frame(width: 80, alignment: .trailing)
                        Text("\(metrics.operations)")
                            .frame(width: 80, alignment: .trailing)
                        Text("\(metrics.swaps)")
                            .frame(width: 80, alignment: .trailing)
                        Text("\(metrics.recursionDepth)")
                            .frame(width: 60, alignment: .trailing)
                    }
                    .font(.caption)
                    .lineLimit(1)
                }
            }
            .padding(4)
        }
        .frame(maxHeight: 220)
        
        // Chart
        Chart {
            ForEach(allFloatResults) { entry in
                LineMark(
                    x: .value("Input Size", entry.inputSize),
                    y: .value("Time (s)", entry.timeElapsed),
                    series: .value("Algorithm", entry.algorithm)
                )
                .symbol(by: .value("Algorithm", entry.algorithm))
            }
        }
        .chartForegroundStyleScale([
            "QuickSort": .blue,
            "MergeSort": .blue,
            "HeapSort":  .blue,
            "BubbleSort": .blue
        ])
        .chartLegend(.visible)
        .frame(height: 200)
        .padding(.vertical, 4)
    }
    
    // MARK: - Master runAnalysis
    private func runAnalysis() {
        allIntResults.removeAll()
        allFloatResults.removeAll()
        
        // --- 1) Int arrays ---
        for size in sizesToTest {
            let array = (0..<size).map { _ in Int.random(in: 0...10_000) }
            for (_, runner) in intAlgorithmRunners {
                let result = runner(array)
                allIntResults.append(result)
            }
        }
        
        // --- 2) Float arrays ---
        for size in sizesToTest {
            let floatArray = (0..<size).map { _ in Double.random(in: 0...10_000) }
            for (_, floatRunner) in floatAlgorithmRunners {
                let result = floatRunner(floatArray)
                allFloatResults.append(result)
            }
        }
    }
}
