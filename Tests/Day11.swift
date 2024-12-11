//
//  Day11.swift
//  AdventOfCode
//
//  Created by Jeffrey Lewis on 12/4/24.
//

import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day11Tests {
  let testData = """
  125 17

"""
  
  @Test func testPart1() async throws {
    let challenge = Day11(data: testData)
    let count = try await challenge.part1() as! Int
    #expect(count == 55312)
  }
  
  @Test func testPart2() async throws {
    let challenge = Day11(data: testData)
    let count = try await challenge.part2() as! Int
    #expect(count == 65601038650482)
  }
}
