import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day15Tests {
  let testData1 = """
  ########
  #..O.O.#
  ##@.O..#
  #...O..#
  #.#.O..#
  #...O..#
  #......#
  ########
  
  <^^>>>vv<v>>v<<
  
  """

  let testData2 = """
  ##########
  #..O..O.O#
  #......O.#
  #.OO..O.O#
  #..O@..O.#
  #O#..O...#
  #O..O..O.#
  #.OO.O.OO#
  #....O...#
  ##########
  
  <vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
  vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
  ><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
  <<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
  ^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
  ^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
  >^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
  <><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
  ^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
  v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^
    
  """
  
  let testData3 = """
  #######
  #...#.#
  #.....#
  #..OO@#
  #..O..#
  #.....#
  #######
  
  <vv<<^^<<^^

  """
  
  let testData4 = """
  ##########
  #...##O..#
  #.OO.##OO#
  #.OOO.O.##
  #.#.O..O.#
  #O...@.#O#
  ##..##...#
  ##..O....#
  #....#OO.#
  ##########
  
  ^vvv>^>><<^^>^^^v>>^
  
  """
  
  let testData5 = """
  #####
  #...#
  #.O@#
  #OO.#
  #O#.#
  #...#
  #####
  
  <^<<v
  
  """
  
  let testData6 = """
  #####
  #...#
  #.O@#
  #OO.#
  ##O.#
  #...#
  #####

  <^<<v
  
  """
  
  let testData7 = """
  ##########
  #..O..O.O#
  #......O.#
  #.OO..O.O#
  #..O@..O.#
  #O#..O...#
  #O..O..O.#
  #.OO.O.OO#
  #....O...#
  ##########
  
  <vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
  vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
  ><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
  <<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
  ^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
  ^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
  >^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
  <><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
  ^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
  v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^
  
  """
  
  let testData8 = """
  ######
  #....#
  #..#.#
  #....#
  #.O..#
  #.OO@#
  #.O..#
  #....#
  ######
  
  <vv<<^^^
  """
  
  let testData9 = """
  #######
  #.....#
  #.OO@.#
  #.....#
  #######
  
  <<
  """
  
  @Test func testPart1() async throws {
    let challenge = Day15(data: testData1)
    let result = try await challenge.part1() as! Int
    #expect(result == 2028)
    
    let challenge2 = Day15(data: testData2)
    let result2 = try await challenge2.part1() as! Int
    #expect(result2 == 10092)
  }
  
  @Test func testPart2() async throws {
//    let challenge = Day15(data: testData3)
//    let count = try await challenge.part2() as! Int
//    #expect(count == 105)
//    let challenge = Day15(data: testData2)
//    let count = try await challenge.part2() as! Int
//    #expect(count == 9021)
//    
//    let challenge2 = Day15(data: testData4)
//    let count2 = try await challenge2.part2() as! Int
//    #expect(count2 == 6358)
//    
//    let challenge3 = Day15(data: testData5)
//    let count3 = try await challenge3.part2() as! Int
//    #expect(count3 == 1211)
//    
//    let challenge4 = Day15(data: testData6)
//    let count4 = try await challenge4.part2() as! Int
//    #expect(count4 == 1213)
//    
////    let challenge5 = Day15(data: testData7)
////    let count5 = try await challenge5.part2() as! Int
////    #expect(count5 == 1430)
//    
//    let challenge6 = Day15(data: testData8)
//    let count6 = try await challenge6.part2() as! Int
//    #expect(count6 == 1216)
//    
//    let challenge7 = Day15(data: testData9)
//    let count7 = try await challenge7.part2() as! Int
//    #expect(count7 == 406)
    
    let final = Day15()
    let finalCount = try await final.part2() as! Int
    #expect(finalCount == 1437468)

  }
}







