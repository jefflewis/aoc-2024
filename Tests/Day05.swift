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
struct Day05Tests {
  let testData = """
    47|53
    97|13
    97|61
    97|47
    75|29
    61|13
    75|53
    29|13
    97|29
    53|29
    61|53
    97|53
    61|29
    47|13
    75|47
    97|75
    47|61
    75|61
    47|29
    75|13
    53|13
    
    75,47,61,53,29
    97,61,53,29,13
    75,29,13
    75,97,47,61,53
    61,13,29
    97,13,75,29,47
  """
  
  @Test func testPart1() async throws {
    let challenge = Day05(data: testData)
    #expect(challenge.part1() as! Int == 143)
  }
  
  @Test func testPart2() async throws {
    let challenge = Day05(data: testData)
    #expect(challenge.part2() as! Int == 123)
  }
}
