import Algorithms
import Collections
import Foundation

struct Day19: AdventDay {
  var data: String
  func part1() async throws -> Any {
    let (towels, designs) = input(for: data)
    
    var cache = [String: Int]()

    let matches = designs.filter {
      combinations(
        for: $0,
        with: towels,
        cached: &cache
      ) > 0
    }

    return matches.count
  }
  
  func part2() async throws -> Any {
    let (towels, designs) = input(for: data)
    
    var cache = [String: Int]()
    
    let matches = designs.map {
      combinations(
        for: $0,
        with: towels,
        cached: &cache
      )
    }
    
    return matches.reduce(0, +)
  }
  
  func combinations(
    for design: String,
    with towels: Set<String>,
    cached: inout [String: Int]
  ) -> Int {
    if design.isEmpty {
      return 1
    }
    
    if let count = cached[design] {
      return count
    }
    
    let count = towels.reduce(0) { partialResult, towel in
      if design.hasPrefix(towel) {
        partialResult + combinations(
          for: String(design.dropFirst(towel.count)),
          with: towels,
          cached: &cached
        )
      } else {
        partialResult
      }
    }

    cached[design] = count
    return count
  }
  
  func input(for data: String) -> (
    towels: Set<String>, designs: Set<String>
  ) {
    let towels = Set(
      data
        .split(separator: .newlineSequence)[0]
        .split(separator: ", ")
        .map(String.init)
    )
    
    let designs = Set(
      data
      .split(separator: .newlineSequence)
      .dropFirst()
      .filter({ !$0.isEmpty })
      .map(String.init)
    )
    
    return (towels: towels, designs: designs)
  }
}
