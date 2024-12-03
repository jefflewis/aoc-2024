import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day02Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    7 6 4 2 1
    1 2 7 8 9
    9 7 6 2 1
    1 3 2 4 5
    8 6 4 4 1
    1 3 6 7 9
    48 46 47 49 51 54 56
    1 1 2 3 4 5
    1 2 3 4 5 5
    5 1 2 3 4 5
    1 6 7 8 9
    9 8 7 6 7
    1 2 3 4 3
    1 4 3 2 1
    7 10 8 10 11
    29 28 27 25 26 25 22 20
    8 9 10 11
  """
    
  @Test func testPart1() async throws {
    let challenge = Day02(data: testData)
    #expect(challenge.part1() as! Int == 3)
  }
  
  @Test func testPart2() async throws {
    let challenge = Day02(data: testData)
    #expect(challenge.part2() as! Int == 15)
  }
}
