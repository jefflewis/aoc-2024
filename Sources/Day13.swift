import Algorithms
import Collections
import Foundation
import Parsing

struct Day13: AdventDay {
  var data: String
 
  func part1() async throws -> Any {
    let machines = try InputParser().parse(data)
    return machines.map(\.tokens).reduce(0, +)
  }
  
  func part2() async throws -> Any {
    let machines = try InputParser().parse(data)
    return machines
      .map({
        Machine(
          a: $0.a,
          b: $0.b,
          prize: Point(x: 10000000000000 + $0.prize.x, y: 10000000000000 + $0.prize.y)
        )
      })
      .map(\.tokens).reduce(0, +)
  }
  
  struct Machine {
    let a: Button
    let b: Button
    let prize: Point
    
    var tokens: Int {
      let ax = Decimal(a.movements.x)
      let ay = Decimal(a.movements.y)
      let bx = Decimal(b.movements.x)
      let by = Decimal(b.movements.y)
      let px = Decimal(prize.x)
      let py = Decimal(prize.y)
      
      let n = (by*px - bx*py) / (ax * by - ay * bx)
      let m = (py - n * ay) / by
      
      if let aPresses = Int(n.description), let bPresses = Int(m.description) {
        return a.press * aPresses + b.press * bPresses
      }
      
      return 0
    }
  }
  
  struct Movements: Hashable {
    let x: Int
    let y: Int
  }
  
  struct Point: Hashable {
    let x: Int
    let y: Int
  }
  
  enum Button: Hashable {
    case a(Movements)
    case b(Movements)
    
    var movements: Movements {
      switch self {
      case let .a(movements), let .b(movements): movements
      }
    }
    
    var press: Int {
      switch self {
      case .a: 3
      case .b: 1
      }
    }
  }
  
  struct InputParser: Parser {
    var body: some Parser<Substring, [Machine]> {
      Parse([Machine].init) {
        Many {
          Skip {
            Whitespace()
          }
          MachineParser()
        } separator: {
          Whitespace(2, .vertical)
        }
        
        Skip {
          Whitespace(1, .vertical)
        }
      }
    }
  }
  
  struct MachineParser: Parser {
    var body: some Parser<Substring, Machine> {
      Parse(Machine.init) {
        Skip {
          Whitespace()
        }
        AButtonParser()
        Whitespace(1, .vertical)
        BButtonParser()
        Whitespace(1, .vertical)
        "Prize: "
        PointParser()
      }
    }
  }
  
  struct AButtonParser: Parser {
    var body: some Parser<Substring, Button> {
      Parse(Button.a) {
        "Button A: "
        MovementsParser()
      }
    }
  }
  
  struct BButtonParser: Parser {
    var body: some Parser<Substring, Button> {
      Parse(Button.b) {
        "Button B: "
        MovementsParser()
      }
    }
  }
  
  struct PointParser: Parser {
    var body: some Parser<Substring, Point> {
      Parse(Point.init) {
        "X="
        Digits()
        ", Y="
        Digits()
      }
    }
  }
  
 
  struct MovementsParser: Parser {
    var body: some Parser<Substring, Movements> {
      Parse(Movements.init) {
        "X+"
        Digits()
        ", Y+"
        Digits()
      }
    }
  }
}
