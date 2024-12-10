
//
//  Day09.swift
//  AdventOfCode
//
//  Created by Jeffrey Lewis on 12/4/24.
//

import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day09Tests {
  let testData = "2333133121414131402"

  @Test func testPart1() async throws {
    let challenge = Day09(data: testData)
    #expect(challenge.part1() as! Int == 1928)
  }

  @Test func testPart2() async throws {
    let challenge = Day09(data: testData)
    #expect(challenge.part2() as! Int == 2858)
  }
}
