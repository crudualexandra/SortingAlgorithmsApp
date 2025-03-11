import Foundation

struct DetailedMetrics: Identifiable {
    let id = UUID()
    let algorithm: String
    let inputSize: Int
    let timeElapsed: Double
    let operations: Int
    let swaps: Int
    let recursionDepth: Int
}
