import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day12Tests {
  

  
  let testData = """
    RRRRIICCFF
    RRRRIICCCF
    VVRRRCCFFF
    VVRCCCJFFF
    VVVVCJJCFE
    VVIVCCJJEE
    VVIIICJJEE
    MIIIIIJJEE
    MIIISIJEEE
    MMMISSJEEE
  """
  
  @Test func testPart1() async throws {
    let challenge = Day12()
    let result = try await challenge.part1() as! Int
    #expect(result == 1477762)
    
//    let challenge = Day12(data: testData)
//    let result = try await challenge.part1() as! Int
//    #expect(result == 1930)
    
//    let testData2 = """
//    OOOOO
//    OXOXO
//    OOOOO
//    OXOXO
//    OOOOO
//    """
//    let challenge2 = Day12(data: testData2)
//    let result2 = try await challenge2.part1() as! Int
//    #expect(result2 == 772)
//    
//    let testData3 = """
//    AAAA
//    BBCD
//    BBCC
//    EEEC
//    """
//    let challenge3 = Day12(data: testData3)
//    let result3 = try await challenge3.part1() as! Int
//    #expect(result3 == 140)
  }
  
  @Test func testPart2() async throws {
//    let challenge = Day12(data: testData)
//    let count = try await challenge.part2() as! Int
//    #expect(count == 1206)
    
    let challenge = Day12()
    let result = try await challenge.part2() as! Int
    #expect(result == 923480)
  }
}







