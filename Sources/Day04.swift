//
//  Day04.swift
//  AdventOfCode
//
//  Created by Jeffrey Lewis on 12/4/24.
//

import Algorithms
import Foundation
import RegexBuilder

struct Day04: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
  
  struct Point: Hashable {
    let x: Int
    let y: Int
  }
  
  func part1() -> Any {
    var searchData: [Point: Character] = [:]

    for (row, line) in data.split(separator: .newlineSequence).enumerated() {
      for (column, char) in line.trimmingCharacters(in: .whitespaces).enumerated() {
        searchData[Point(x: column, y: row)] = char
      }
    }
    
    var matches: [Point] = []
    
    for point in searchData.filter({ $0.value == "X" }).map(\.key) {
      if let nextM = searchData[Point(x: point.x + 1, y: point.y)],
         nextM == "M",
         let nextA = searchData[Point(x: point.x + 2, y: point.y)],
         nextA == "A",
         let nextS = searchData[Point(x: point.x + 3, y: point.y)],
         nextS == "S" {
        matches.append(point)
      }
      
      if let nextM = searchData[Point(x: point.x - 1, y: point.y)],
         nextM == "M",
         let nextA = searchData[Point(x: point.x - 2, y: point.y)],
         nextA == "A",
         let nextS = searchData[Point(x: point.x - 3, y: point.y)],
         nextS == "S" {
        matches.append(point)
      }
      
      if let nextM = searchData[Point(x: point.x, y: point.y + 1)],
         nextM == "M",
         let nextA = searchData[Point(x: point.x, y: point.y + 2)],
         nextA == "A",
         let nextS = searchData[Point(x: point.x, y: point.y + 3)],
         nextS == "S" {
        matches.append(point)
      }
      
      if let nextM = searchData[Point(x: point.x, y: point.y - 1)],
         nextM == "M",
         let nextA = searchData[Point(x: point.x, y: point.y - 2)],
         nextA == "A",
         let nextS = searchData[Point(x: point.x, y: point.y - 3)],
         nextS == "S" {
        matches.append(point)
      }
      
      if let nextM = searchData[Point(x: point.x + 1, y: point.y + 1)],
         nextM == "M",
         let nextA = searchData[Point(x: point.x + 2, y: point.y + 2)],
         nextA == "A",
         let nextS = searchData[Point(x: point.x + 3, y: point.y + 3)],
         nextS == "S" {
        matches.append(point)
      }
      
      if let nextM = searchData[Point(x: point.x + 1, y: point.y - 1)],
         nextM == "M",
         let nextA = searchData[Point(x: point.x + 2, y: point.y - 2)],
         nextA == "A",
         let nextS = searchData[Point(x: point.x + 3, y: point.y - 3)],
         nextS == "S" {
        matches.append(point)
      }
      
      if let nextM = searchData[Point(x: point.x - 1, y: point.y + 1)],
         nextM == "M",
         let nextA = searchData[Point(x: point.x - 2, y: point.y + 2)],
         nextA == "A",
         let nextS = searchData[Point(x: point.x - 3, y: point.y + 3)],
         nextS == "S" {
        matches.append(point)
      }
      
      if let nextM = searchData[Point(x: point.x - 1, y: point.y - 1)],
         nextM == "M",
         let nextA = searchData[Point(x: point.x - 2, y: point.y - 2)],
         nextA == "A",
         let nextS = searchData[Point(x: point.x - 3, y: point.y - 3)],
         nextS == "S" {
        matches.append(point)
      }
    }
    
    return matches.count
  }
  
  func part2() -> Any {
    var searchData: [Point: Character] = [:]

    for (row, line) in data.split(separator: .newlineSequence).enumerated() {
      for (column, char) in line.trimmingCharacters(in: .whitespaces).enumerated() {
        searchData[Point(x: column, y: row)] = char
      }
    }
    
    var matches: [Point] = []
    
    for point in searchData.filter({ $0.value == "A" }).map(\.key) {
      if let topRightS = searchData[Point(x: point.x + 1, y: point.y + 1)],
         topRightS == "S",
         let bottomLeftM = searchData[Point(x: point.x - 1, y: point.y - 1)],
         bottomLeftM == "M",
         
          let bottomRightS = searchData[Point(x: point.x + 1, y: point.y - 1)],
         bottomRightS == "S",
         let topLeftM = searchData[Point(x: point.x - 1, y: point.y + 1)],
         topLeftM == "M" {
        matches.append(point)
    }
        
      
      if let bottomLeftS = searchData[Point(x: point.x - 1, y: point.y - 1)],
          bottomLeftS == "S",
         let topRightM = searchData[Point(x: point.x + 1, y: point.y + 1)],
         topRightM == "M",
         let topLeftS = searchData[Point(x: point.x - 1, y: point.y + 1)],
          topLeftS == "S",
         let bottomRightM = searchData[Point(x: point.x + 1, y: point.y - 1)],
             bottomRightM == "M" {
        matches.append(point)
      }
      
      if let bottomLeftS = searchData[Point(x: point.x - 1, y: point.y - 1)],
          bottomLeftS == "S",
         let topRightM = searchData[Point(x: point.x + 1, y: point.y + 1)],
         topRightM == "M",
         let  bottomRightS = searchData[Point(x: point.x + 1, y: point.y - 1)],
            bottomRightS == "S",
         let topLeftM = searchData[Point(x: point.x - 1, y: point.y + 1)],
             topLeftM == "M" {
        matches.append(point)
      }
      
      if let topLeftS = searchData[Point(x: point.x - 1, y: point.y + 1)],
          topLeftS == "S",
         let bottomRightM = searchData[Point(x: point.x + 1, y: point.y - 1)],
         bottomRightM == "M",
         let topRightS = searchData[Point(x: point.x + 1, y: point.y + 1)],
            topRightS == "S",
         let bottomLeftM = searchData[Point(x: point.x - 1, y: point.y - 1)],
             bottomLeftM == "M" {
        matches.append(point)
      }
    }
    
    return matches.count
  }
}
