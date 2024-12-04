//
//  Day04.swift
//  AdventOfCode
//
//  Created by Jeffrey Lewis on 12/4/24.
//

import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day04Tests {
  let testData = """
    MMMSXXMASM
    MSAMXMSMSA
    AMXSXMAAMM
    MSAMASMSMX
    XMASAMXAMM
    XXAMMXXAMA
    SMSMSASXSS
    SAXAMASAAA
    MAMMMXMMMM
    MXMXAXMASX
  """
  
  @Test func testPart1() async throws {
    let challenge = Day04(data: testData)
    #expect(challenge.part1() as! Int == 18)
  }
  
  @Test func testPart2() async throws {
    let challenge = Day04(data: testData)
    #expect(challenge.part2() as! Int == 9)
  }
}
