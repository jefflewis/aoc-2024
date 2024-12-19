import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.


struct Day19Tests {
  let testData = """
  r, wr, b, g, bwu, rb, gb, br
  
  brwrr
  bggr
  gbbr
  rrbgbr
  ubwu
  bwurrg
  brgr
  bbrgwb
  
  """
  
  @Test
  func testPart1() async throws {
    let challenge1 = Day19(data: testData)
    let result = try await challenge1.part1() as! Int
    #expect(result == 6)
  }
  
  @Test
  func testPart2() async throws {
    let challenge = Day19(data: testData)
    let result = try await challenge.part2() as! Int
    #expect(result == 16)
  }
}







