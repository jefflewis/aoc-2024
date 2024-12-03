import Algorithms
import Foundation
import RegexBuilder

struct Day02: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
  
  // Splits input data into its component parts and convert from string.
  var entities: [[Int]] {
    data.split(separator: .newlineSequence)
      .map {
        $0.components(separatedBy: .whitespaces).compactMap { Int($0) }
      }
      .filter { $0.count > 0 }
  }
  

  func part1() -> Any {
    return entities.filter(allIncreasingORDecreasing(_:)).count
  }
  
  func part2() -> Any {
    return entities.filter { report in
      if allIncreasingORDecreasing(report) {
        return true
      }

      for i in report.indices {
        var dampenedReport = report
        dampenedReport.remove(at: i)
        if allIncreasingORDecreasing(dampenedReport) {
          return true
        }
      }
      
      return false
    }.count
  }
  
  func allIncreasingORDecreasing(_ report: [Int]) -> Bool {
    allIncreasing(report) || allDecreasing(report)
  }
  
  func allIncreasing(_ report: [Int]) -> Bool {
    report.adjacentPairs().allSatisfy { 1...3 ~= ($1 - $0) }
  }
  
  func allDecreasing(_ report: [Int]) -> Bool {
    report.adjacentPairs().allSatisfy { 1...3 ~= ($0 - $1) }
  }
}
