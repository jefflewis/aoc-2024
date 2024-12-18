import Algorithms
import Collections
import Parsing
import Foundation

struct Day17: AdventDay {
  var data: String
  
  func part1() async throws -> Any {
    var computer = try InputParser().parse(data)
    try await computer.run()
    return String(computer.results.map(String.init).joined(by: ","))
  }
  
  func part2() async throws -> Any {
    let initialComputer = try InputParser().parse(data)
    
    /*
     Printing output shows the result grows by one for every 3 bits in the inital A value.
     To get a result that has the same number of digits as the program, we will need a 16 digit / 48 bit number
     
     try:
          * all single digit octal numbers to see which ones generate the last digit of the program.
          * all the 2 digit octal numbers starting with the matching single digit octal numbers
          * >>> which ones result in the _last_ two numbers of the program?
     
     finally:
          * Repeat the process until we've expanded the potential register a values out to a full 16 digit / 48 bit number
          * one of these should generate the puzzle input.
     */
    
    // track values
    // * for the a register that we should consider
    // * coupled with index number of octal digit we're checking for
    var queue = Deque<(a: Int, index: Int)>()
    queue.append((a: 0, index: 1))
    
    while let (value, index) = queue.popFirst() {
      // check for each instruction index of the program
      for octalIndex in 0...7 {
        // shift the value 3 bits & the octal index we're looking for
        let next = value << 3 + octalIndex

        // create a new computer to run the program
        var computer = initialComputer

        // check the new A register value
        computer.registerA.value = next
        try await computer.run()
        
        // we have the the correct results up to the index we're looking for
        guard computer.results == computer.program.values.suffix(index)
        else { continue }
        
        // we have all of the digits! :tada:
        if computer.results == computer.program.values {
          return next
        }
        
        // check the next index
        queue.append((a: next, index: index + 1))
      }
    }
   
    
    return 0
  }
  
  enum InstructionError: Error {
    case skip(to: Int)
    case overflow
    case foundSpecial(Int)
  }
  
  struct Computer {
    var program: Program = .init(values: [])
    var registerA: RegisterA = .init(value: 0)
    var registerB: RegisterB = .init(value: 0)
    var registerC: RegisterC = .init(value: 0)
    
    var results: [Int] = []
    var currentInstruction: Instruction = .adv
    
    mutating func run() async throws {
      var currentInstructionCode = 0

      repeat {
        if Task.isCancelled {
          break
        }
        do {
          currentInstruction = Instruction(rawValue: program.values[currentInstructionCode])!
          try perform(operand: program.values[currentInstructionCode + 1])
          currentInstructionCode += 2
        } catch let InstructionError.skip(to: index) {
          currentInstructionCode = index
        } catch InstructionError.overflow {
          throw InstructionError.overflow
        }
        
      } while currentInstructionCode < program.values.count - 1
    }
    
    
    
    mutating func perform(operand value: Int) throws {
      switch currentInstruction {
      case .adv:
        let operand = Operand.combo(value)
        let denominator = Int (
          "\(pow(2.0, (try operand.value(for: self))))"
        )!
        registerA.value = registerA.value / denominator
      case .bxl:
        let operand = Operand.literal(value)
        registerB.value = registerB.value ^ (try operand.value(for: self))
      case .bst:
        let operand = Operand.combo(value)
        registerB.value = try operand.value(for: self) % 8
      case .jnz:
        if registerA.value == 0 {
          return
        }

        let operand = Operand.literal(value)
        throw InstructionError.skip(to: try operand.value(for: self))
      case .bxc:
        registerB.value = registerB.value ^ registerC.value
      case .out:
        let operand = Operand.combo(value)
        results.append(try operand.value(for: self) % 8)
      case .bdv:
        let operand = Operand.combo(value)
        let denominator = Int (
          "\(pow(2.0, (try operand.value(for: self))))"
        )!
        registerB.value = registerA.value / denominator
      case .cdv:
        let operand = Operand.combo(value)
        let denominator = Int (
          "\(pow(2.0, (try operand.value(for: self))))"
        )!
        registerC.value = registerA.value / denominator
      }
    }
  }
  
  struct Program {
    var values: [Int]
  }
  
  struct RegisterA {
    var value: Int
  }
  struct RegisterB {
    var value: Int
  }
  struct RegisterC {
    var value: Int
  }
  
  typealias OpCode = Int
  
  enum Operand {
    case literal(Int)
    case combo(Int)
    
    func value(for computer: Computer) throws -> Int {
      switch self {
      case .literal(let int): int
      case .combo(let int):
        switch int {
        case 0, 1, 2, 3: int
        case 4: computer.registerA.value
        case 5: computer.registerB.value
        case 6: computer.registerC.value
        case 7: fatalError("reserved")
        default: throw InstructionError.overflow
        }
      }
    }
  }
  
  enum Instruction: Int {
    case adv
    case bxl
    case bst
    case jnz
    case bxc
    case out
    case bdv
    case cdv
    
    var opCode: OpCode {
      self.rawValue
    }
    
    
  }
  
  struct InputParser: Parser {
    var body: some Parser<Substring, Computer> {
      Parse({ Computer(program: $3, registerA: $0, registerB: $1, registerC: $2) }) {
        RegisterAParser()
        Whitespace(1, .vertical)
        RegisterBParser()
        Whitespace(1, .vertical)
        RegisterCParser()
        Whitespace(2, .vertical)
        ProgramParser()
        Skip {
          Rest()
        }
      }
    }
  }
  
  struct RegisterAParser: Parser {
    var body: some Parser<Substring, RegisterA> {
      Parse(RegisterA.init) {
        "Register A:"
        Whitespace(1, .horizontal)
        Digits()
      }
    }
  }
  
  struct RegisterBParser: Parser {
    var body: some Parser<Substring, RegisterB> {
      Parse(RegisterB.init) {
        "Register B:"
        Whitespace(1, .horizontal)
        Digits()
      }
    }
  }
  
  struct RegisterCParser: Parser {
    var body: some Parser<Substring, RegisterC> {
      Parse(RegisterC.init) {
        "Register C:"
        Whitespace(1, .horizontal)
        Digits()
      }
    }
  }
  
  struct ProgramParser: Parser {
    var body: some Parser<Substring, Program> {
      Parse(Program.init) {
        Skip {
          Whitespace(.horizontal)
        }
        "Program"
        ":"
        Whitespace(1, .horizontal)
        Many {
          Digits()
        } separator: {
          ","
        }
      }
    }
  }
}

