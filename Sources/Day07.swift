//
//  Day07.swift
//  AdventOfCode
//
//  Created by Jeffrey Lewis on 12/4/24.
//

import Algorithms
import Foundation
import Parsing
import Accelerate

struct Day07: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  func part1() -> Any {
    let equations = try! InputParser().parse(data)
    
    return equations
      .filter({ $0.isValid(for: [(+), (*)]) })
      .map(\.testValue)
      .reduce(0, +)
  }

  func part2() -> Any {
    let equations = try! InputParser().parse(data)
    
    return equations
      .filter({ $0.isValid(for: [(+), (*), (||)]) })
      .map(\.testValue)
      .reduce(0, +)
  }
  
  struct Equation {
    var testValue: Int
    var input: [Int]
    
    func isValid(for operators: [(Int, Int) -> Int]) -> Bool {
      input
        .dropFirst()
        .reduce([input.first ?? 0]) { partialResult, next in
          partialResult
            .filter { $0 <= testValue }
            .flatMap { value in
              operators.map { $0(value, next) }
            }
        }
        .contains(testValue)
    }
  }
  
  struct InputParser: Parser {
    var body: some Parser<Substring, [Equation]> {
      Many {
        EquationParser()
      } separator: {
        Whitespace(1, .vertical)
      }
      
      Skip {
        Rest()
      }
    }
  }
  
  struct EquationParser: Parser {
    var body: some Parser<Substring, Equation> {
      Parse(Equation.init) {
        Skip {
          Whitespace()
        }

        Digits()
        ":"
        Whitespace(1)
        Many {
          Digits()
        } separator: {
          Whitespace(1, .horizontal)
        }
      }
    }
  }
}

extension Int {
  static func || (lhs: Int, rhs: Int) -> Int {
    guard let value = Int("\(lhs)\(rhs)") else {
      fatalError()
    }
    return value
  }
}

