
//
//  Day08.swift
//  AdventOfCode
//
//  Created by Jeffrey Lewis on 12/4/24.
//

import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day08Tests {
  let testData = """
    ............
    ........0...
    .....0......
    .......0....
    ....0.......
    ......A.....
    ............
    ............
    ........A...
    .........A..
    ............
    ............
  """

  @Test func testPart1() async throws {
    let challenge = Day08(data: testData)
    #expect(challenge.part1() as! Int == 14)
  }

  @Test func testPart2() async throws {
    let challenge = Day08(data: testData)
    #expect(challenge.part2() as! Int == 34)
  }
}
