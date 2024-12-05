//
//  Day05.swift
//  AdventOfCode
//
//  Created by Jeffrey Lewis on 12/4/24.
//

import Algorithms
import Foundation
import Parsing

struct Day05: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
  
  struct PageOrderRule: Hashable {
    let x: Int
    let y: Int
  }
  
  struct PageUpdate {
    var pages: [Int]
    var middle: Int {
      pages.middle ?? 0
    }
  }
  
  enum Entry {
    case rule(PageOrderRule)
    case update(PageUpdate)
    case separator
  }
  
  var entries: [Entry] {
    return try! InputParser().parse(data)
  }
  
  var orderingRules: [PageOrderRule] {
    return entries.compactMap {
      switch $0 {
      case let .rule(rule): rule
      default: nil
      }
    }
  }
  
  var updates: [PageUpdate] {
    return entries.compactMap {
      switch $0 {
      case let .update(update): update
      default: nil
      }
    }
  }
  
  func part1() -> Any {
    let updates = updates.filter { update in
      orderingRules
        .filter({ rule in
          update.pages.contains(where: { rule.x == $0 }) &&
          update.pages.contains(where: { rule.y == $0 })
        })
        .allSatisfy({ rule in
          guard let firstXIndex = update.pages.firstIndex(of: rule.x),
                let firstYIndex = update.pages.firstIndex(of: rule.y),
                    firstXIndex < firstYIndex else { return false }
          
          return true
        })
    }

    return updates.map(\.middle).reduce(0, +)
  }
  
  func part2() -> Any {
    let updates = updates.filter({ update in
      orderingRules
        .filter({ rule in
          update.pages.contains(where: { rule.x == $0 }) &&
          update.pages.contains(where: { rule.y == $0 })
        })
        .count(where: { rule in
          guard let firstXIndex = update.pages.firstIndex(of: rule.x),
                let firstYIndex = update.pages.firstIndex(of: rule.y),
                firstXIndex > firstYIndex else { return false }
          
          return true
        }) > 0
    })
    .map({ update in
      let rules = orderingRules
        .filter({ rule in
          update.pages.contains(where: { rule.x == $0 }) &&
          update.pages.contains(where: { rule.y == $0 })
        })
      
      var update = update
      update.pages = update.pages.sorted(by: { first, second in
        rules.filter({ rule in
          (rule.x == first || rule.x == second) &&
          (rule.y == second || rule.y == first)
        }).allSatisfy {
          first <= $0.x && second <= $0.y
        }
      })

      return update
    })
    
    return updates.map(\.middle).reduce(0, +)
  }
  
  struct InputParser: Parser {
    var body: some Parser<Substring, [Entry]> {
      Many {
        Skip {
          Whitespace()
        }
        OneOf {
          PageOrderRuleParser()
          PageUpdateParser()
          Parse({ Entry.separator }) {
            Whitespace(1, .vertical)
          }
        }
      } separator: {
        OneOf {
          Whitespace(1, .vertical)
          Whitespace(2, .vertical)
        }
      }
    }
  }

  struct PageOrderRuleParser: Parser {
    var body: some Parser<Substring, Entry> {
      Parse({ Entry.rule(.init(x: $0, y: $1)) }) {
        Int.parser()
        "|"
        Int.parser()
      }
    }
  }
  
  
  struct PageUpdateParser: Parser {
    var body: some Parser<Substring, Entry> {
      Parse({ Entry.update(.init(pages: $0))  }) {
        Many {
          Int.parser()
        } separator: {
          ","
        }
      }
    }
  }

}

extension Array {
  var middle: Element? {
    guard count != 0 else { return nil }
    
    let middleIndex = (count > 1 ? count - 1 : count) / 2
    return self[middleIndex]
  }
  
}
