import Algorithms
import Foundation
import Parsing

struct Day03: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
  
  func part1() -> Any {
    let muls = try! Part1InputParser().parse(data[...])
    return muls.reduce(0) { partialResult, mul in
      partialResult + mul()
    }
  }
  
  func part2() -> Any {
    let muls = try! Part2InputParser().parse(data[...])
    return muls.reduce(0) { partialResult, mul in
      partialResult + mul()
    }
  }
  
  
  struct Mul {
    let x: Int
    let y: Int
    
    func callAsFunction() -> Int {
      x * y
    }
  }
 
  struct PrefixUpToMatch<
    Input: Collection,
    Target: Parser,
    Enable: Parser,
    Disable: Parser
  >: Parser where Target.Input == Input,
                  Enable.Input == Input,
                  Disable.Input == Input,
                  Input.SubSequence == Input {
    let target: Target
    let enable: Enable
    let disable: Disable
    
    init(
      @ParserBuilder<Input> target: () -> Target,
      @ParserBuilder<Input> enable: () -> Enable,
      @ParserBuilder<Input> disable: () -> Disable
    ) {
      self.target = target()
      self.enable = enable()
      self.disable = disable()
    }
    
    func parse(_ input: inout Input) throws -> Input {
      let original = input
      var index = original.startIndex
      
      var enabled = true
      
      while index != original.endIndex {
        var suffix = original[index...]

        if enabled {
          do {
            _ = try disable.parse(&suffix)
            enabled = false
            index = original.index(after: index)
            input.removeFirst()
            continue
          } catch {
          }
          
          do {
            _ = try target.parse(&suffix)
            return original[..<index]
          } catch {
            index = original.index(after: index)
          }
        } else {
          do {
            _ = try enable.parse(&suffix)
            enabled = true
          } catch {
          }
          index = original.index(after: index)
          input.removeFirst()
          continue
        }
        
        input.removeFirst()
      }
      
      return original
    }
  }
 
  
  struct Part1InputParser: Parser {
    var body: some Parser<Substring, [Mul]> {
      Skip {
        PrefixUpToMatch {
          MulParser()
        } enable: {
          Parse {
            UUID().uuidString
          }
        } disable: {
          Parse {
            UUID().uuidString
          }
        }
      }
      
      Many {
        MulParser()
      } separator: {
        PrefixUpToMatch {
          MulParser()
        } enable: {
          Parse {
            UUID().uuidString
          }
        } disable: {
          Parse {
            UUID().uuidString
          }
        }
      }
      
      Skip {
        Rest()
      }
    }
  }
  
  struct Part2InputParser: Parser {
    var body: some Parser<Substring, [Mul]> {
      Skip {
        PrefixUpToMatch {
          MulParser()
        } enable: {
          EnableParser()
        } disable: {
          DisableParser()
        }
      }
      
      Many {
        MulParser()
      } separator: {
        PrefixUpToMatch {
          MulParser()
        } enable: {
          EnableParser()
        } disable: {
          DisableParser()
        }
      }
      
      Skip {
        Rest()
      }
    }
  }
  
  struct DisableParser: Parser {
    var body: some Parser<Substring, Void> {
      "don't()"
    }
  }
  
  struct EnableParser: Parser {
    var body: some Parser<Substring, Void> {
      "do()"
    }
  }
    
  struct MulParser: Parser {
    var body: some Parser<Substring, Mul> {
      Parse(Mul.init) {
        "mul("
        Int.parser()
        ","
        Int.parser()
        ")"
      }
    }
  }
}
