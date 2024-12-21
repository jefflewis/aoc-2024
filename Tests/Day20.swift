import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.


struct Day20Tests {
  let testData = """
  ###############
  #...#...#.....#
  #.#.#.#.#.###.#
  #S#...#.#.#...#
  #######.#.#.###
  #######.#.#...#
  #######.#.###.#
  ###..E#...#...#
  ###.#######.###
  #...###...#...#
  #.#####.#.###.#
  #.#...#.#.#...#
  #.#.#.#.#.#.###
  #...#...#...###
  ###############

  """
  
  @Test
  func testPart1() async throws {
    let challenge1 = Day20(data: testData)
    let result = try await challenge1.part1() as! Int
    let expected = (14 + 14 + 2 + 4 + 2 + 3 + 1 + 1 + 1 + 1 + 1)
    #expect(result == expected)
  }
  
  @Test
  func testPart2() async throws {
    let challenge = Day20(data: testData)
    let result = try await challenge.part2() as! Int
    let expected = 32 + 31 + 29 + 39 + 25 + 23 + 20 + 19 + 12 + 14 + 12 + 22 + 4 + 3
    #expect(result == expected)
  }
}







