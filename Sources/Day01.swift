import Algorithms
import Foundation
import RegexBuilder

struct Day01: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
  
  // Splits input data into its component parts and convert from string.
  var entities: ChunksOfCountCollection<[Int]> {
    data.split(separator: .newlineSequence)
      .flatMap {
        $0.components(separatedBy: .whitespaces).compactMap { Int($0) }
      }
      .chunks(ofCount: 2)
  }
  
  /*
   Pair up the smallest number in the left list with the smallest number in the right list, then the second-smallest left number with the second-smallest right number,
   */
  func part1() -> Any {
    return zip(
      entities.compactMap({ $0.first }).sorted(),
      entities.compactMap({ $0.last }).sorted()
    )
    .reduce(0) { partialResult, pair in
      abs(pair.0 - pair.1) + partialResult
    }
  }
  
  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    entities.compactMap(\.first).reduce(0) { partialResult, num in
      partialResult + num * entities.map(\.last).count(where: { $0 == num })
    }
  }
}
