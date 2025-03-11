import Foundation

/// Represents one step (operation) in a sorting algorithm:
/// - array: the current state of the array
/// - highlightIndices: which elements to highlight (e.g., the swapped items)
/// - description: a short textual explanation of the operation
struct SortOperation: Identifiable {
    let id = UUID()
    let array: [Int]
    let highlightIndices: [Int]
    let description: String
}
