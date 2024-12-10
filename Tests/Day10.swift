
//
//  Day10.swift
//  AdventOfCode
//
//  Created by Jeffrey Lewis on 12/4/24.
//

import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day10Tests {
  let testData = """
  89010123
  78121874
  87430965
  96549874
  45678903
  32019012
  01329801
  10456732
  """

  @Test func testPart1() async throws {
    let challenge = Day10(data: testData)
    #expect(challenge.part1() as! Int == 36)
  }

  @Test func testPart2() async throws {
    let challenge = Day10(data: testData)
    #expect(challenge.part2() as! Int == 81)
  }
}
