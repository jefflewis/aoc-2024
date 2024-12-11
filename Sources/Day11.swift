//
//  Day11.swift
//  AdventOfCode
//
//  Created by Jeffrey Lewis on 12/11/24.
//

import Algorithms
import Collections
import Foundation

struct Day11: AdventDay {
  var data: String

  struct Cache {
    var stones: [StoneCount: Int] = [:]
  }
  
  struct StoneCount: Hashable {
    let stone: Int
    let blinks: Int
  }
  
  func part1() async throws -> Any {
    return try await count(input: data, after: 25)
  }
  
  func part2() async throws -> Any {
    return try await count(input: data, after: 75)
  }

  func count(input: String, after blinks: Int) async throws -> Int {
    count(
      stones: input
        .trimmingCharacters(in: .newlines)
        .split(separator: .horizontalWhitespace)
        .map(String.init)
        .compactMap(Int.init),
      after: blinks
    )
  }
  
  func count(stones: [Int], after blinks: Int) -> Int {
    var cache = Cache()
    return  stones.map { stone in
      count(stone: stone, remaining: blinks, with: &cache)
    }.reduce(0, +)
  }

  func count(stone: Int, remaining blinks: Int, with cache: inout Cache) -> Int {
    if blinks == 0 {
      return 1
    }
    
    let cacheKey = StoneCount(stone: stone, blinks: blinks)
    if let cached = cache.stones[cacheKey] {
      return cached
    }

    let rearranged = arrange(stone: stone, remaining: blinks - 1, with: &cache)
    cache.stones[cacheKey] = rearranged
    return rearranged
  }
  
  func arrange(stone: Int, remaining: Int, with cache: inout Cache) -> Int {
    switch stone {
    case 0: count(stone: 1, remaining: remaining, with: &cache)
      
    case let stone where "\(stone)".characterArray.count % 2 == 0:
      "\(stone)"
        .characterArray
        .enumerated()
        .reduce(into: ["", ""]) { stones, next in
          if next.offset < "\(stone)".characterArray.count / 2 {
            stones[0].append(next.element)
          } else {
            stones[1].append(next.element)
          }
        }
        .compactMap(Int.init)
        .map({ count(stone: $0, remaining: remaining, with: &cache) })
        .reduce(0, +)
      
    default:
      count(stone: 2024 * stone, remaining: remaining, with: &cache)
    }
  }
}
