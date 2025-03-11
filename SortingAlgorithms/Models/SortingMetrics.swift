import Foundation

struct SortingMetrics: Identifiable {
    let id = UUID()
    let algorithm: String
    let inputSize: Int
    let timeInSeconds: Double
}
