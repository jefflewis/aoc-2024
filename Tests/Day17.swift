import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.


struct Day17Tests {
  @Test
  func testInstructions() async throws {
    
    var computer = Day17.Computer(
      program: .init(values: []),
      registerA: .init(value: 0),
      registerB: .init(value: 0),
      registerC: .init(value: 0)
    )
    
    // If register C contains 9, the program 2,6 would set register B to 1.
    computer.registerC.value = 9
    computer.program = .init(values: [2, 6])
    try await computer.run()
    #expect(computer.registerB.value == 1)
    
    computer = Day17.Computer()
    
    // If register A contains 10, the program 5,0,5,1,5,4 would output 0,1,2.
    computer.registerA.value = 10
    computer.program = .init(values: [5, 0, 5, 1, 5, 4])
    try await computer.run()
    #expect(computer.results == [0, 1, 2])
    
    computer = Day17.Computer()
    
    // If register A contains 2024, the program 0,1,5,4,3,0 would output 4,2,5,6,7,7,7,7,3,1,0 and leave 0 in register A.
    computer.registerA.value = 2024
    computer.program = .init(values: [0, 1, 5, 4, 3, 0])
    try await computer.run()
    #expect(computer.results == [4,2,5,6,7,7,7,7,3,1,0])
    #expect(computer.registerA.value == 0)
    
    computer = Day17.Computer()

    // If register B contains 29, the program 1,7 would set register B to 26.
    computer.registerB.value = 29
    computer.program = .init(values: [1, 7])
    try await computer.run()
    #expect(computer.registerB.value == 26)
    
    computer = Day17.Computer()

    // If register B contains 2024 and register C contains 43690, the program 4,0 would set register B to 44354.
    computer.registerB.value = 2024
    computer.registerC.value = 43690
    computer.program = .init(values: [4, 0])
    try await computer.run()
    #expect(computer.registerB.value == 44354)
  }
  
  @Test(
    arguments: [
      (
        data: """
              Register A: 2024
              Register B: 0
              Register C: 0

              Program: 0,3,5,4,3,0
              
              """,
        expected: 117440
      )
    ]
  )
  func testPart1(data: String, expected: Int) async throws {
    let challenge1 = Day17(data: data)
    let result = try await challenge1.part1() as! Int
    #expect(result == expected)
  }
  
  @Test
  func testPart2() async throws {
    let challenge = Day17()
    let result = try await challenge.part2() as! Int
    #expect(result > 0)
  }
}







