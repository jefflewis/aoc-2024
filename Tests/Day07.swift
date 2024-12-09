
//
//  Day07.swift
//  AdventOfCode
//
//  Created by Jeffrey Lewis on 12/4/24.
//

import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day07Tests {
  let testData = """
    190: 10 19
    3267: 81 40 27
    83: 17 5
    156: 15 6
    7290: 6 8 6 15
    161011: 16 10 13
    192: 17 8 14
    21037: 9 7 18 13
    292: 11 6 16 20

  """

  @Test func testPart1() async throws {
    let challenge = Day07(data: testData)
    #expect(challenge.part1() as! Int == 3749)

    let fullChallenge = Day07()
    #expect(fullChallenge.part1() as! Int == 7885693428401)
  }

  @Test func testPart2() async throws {
    let challenge = Day07(data: testData)
    #expect(challenge.part2() as! Int == 11387)
  }
}
