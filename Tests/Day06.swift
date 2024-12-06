//
//  Day05.swift
//  AdventOfCode
//
//  Created by Jeffrey Lewis on 12/4/24.
//

import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day06Tests {
  let testData = """
    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#..^.....
    ........#.
    #.........
    ......#...
  """
  
  @Test func testPart1() async throws {
    let challenge = Day06(data: testData)
    #expect(challenge.part1() as! Int == 41)
    
    let testData2 = """
      .....
      ..#..
      ..^.#
      ...#.
      .....
    """
    let challenge2 = Day06(data: testData2)
    #expect(challenge2.part1() as! Int == 4)
    
    let testData3 = """
      ....#
      ...#.
      ..^..
      .....
      ..#..
    """
    let challenge3 = Day06(data: testData3)
    #expect(challenge3.part1() as! Int == 3)
    
    let testData4 = """
      .....
      ..#..
      #.^..
      .....
      .....
    """
    let challenge4 = Day06(data: testData4)
    #expect(challenge4.part1() as! Int == 3)
  }
  
  @Test func testPart2() async throws {
    let challenge = Day06(data: testData)
    #expect(challenge.part2() as! Int == 6)
  }
}
