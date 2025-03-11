import Foundation

struct SampleData {
    /// Generate an array of random integers of a given size
    static func randomArray(size: Int, range: ClosedRange<Int> = 0...100000) -> [Int] {
        (0..<size).map { _ in Int.random(in: range) }
    }
}
