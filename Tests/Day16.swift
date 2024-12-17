import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
let testData1 = """
  ###############
  #.......#....E#
  #.#.###.#.###.#
  #.....#.#...#.#
  #.###.#####.#.#
  #.#.#.......#.#
  #.#.#####.###.#
  #...........#.#
  ###.#.#####.#.#
  #...#.....#.#.#
  #.#.#.###.#.#.#
  #.....#...#.#.#
  #.###.#.#.#.#.#
  #S..#.....#...#
  ###############
  
  """

let testData2 = """
  #################
  #...#...#...#..E#
  #.#.#.#.#.#.#.#.#
  #.#.#.#...#...#.#
  #.#.#.#.###.#.#.#
  #...#.#.#.....#.#
  #.#.#.#.#.#####.#
  #.#...#.#.#.....#
  #.#.#####.#.###.#
  #.#.#.......#...#
  #.#.###.#####.###
  #.#.#...#.....#.#
  #.#.#.#####.###.#
  #.#.#.........#.#
  #.#.#.#########.#
  #S#.............#
  #################
  
  """

struct Day16Tests {
  @Test(arguments: [(data: testData1, expected: 7036), (data: testData2, expected: 11048)])
  func testPart1(data: String, expected: Int) async throws {
    let challenge1 = Day16(data: data)
    let result = try await challenge1.part1() as! Int
    #expect(result == expected)
  }
  
  @Test(arguments: [(data: testData1, expected: 45), (data: testData2, expected: 64)])
  func testPart2(data: String, expected: Int) async throws {
    let challenge = Day16(data: data)
    let result = try await challenge.part2() as! Int
    #expect(result == expected)
  }
}







