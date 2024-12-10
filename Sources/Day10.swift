//
//  Day10.swift
//  AdventOfCode
//
//  Created by Jeffrey Lewis on 12/4/24.
//

import Algorithms
import Collections
import Foundation

struct Day10: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
  
  struct Position: Hashable {
    let x: Int
    let y: Int
    let height: Int

    func neighbors(on grid: [[Int]]) -> [Position] {
      (0...min(y+1, grid.count - 1)).flatMap { row in
        (0...min(x+1, grid[0].count - 1)).compactMap { column in
          guard column == x && abs(row - y) == 1 || row == y && abs(column - x) == 1
          else { return nil }
          
          return Position(x: column, y: row, height: grid[row][column])
        }
      }
    }
  }
  
  struct TrailHead {
    var ends: Set<Position> = []
    var position: Position
    var rating: Int = 0
  }

  func part1() -> Any {
    let grid = data
      .characterGrid
      .map { row in row.map { Int(String($0))! } }
      
    return trailheads(for: grid).map(\.ends.count).reduce(0, +)
  }

  func part2() -> Any {
    let grid = data
      .characterGrid
      .map { row in row.map { Int(String($0))! } }
    
    return trailheads(for: grid).map(\.rating).reduce(0, +)
  }
  
  private func trailheads(for grid: [[Int]]) -> [TrailHead] {
    grid.indices.flatMap { row in
      grid[row].indices.compactMap { column in
        guard grid[row][column] == 0 else {
          // not a trailhead
          return nil
        }
        
        var trailhead = TrailHead(position: Position(x: column, y: row, height: 0))
        var possibleNextPaths: [Position] = [trailhead.position]
        
        repeat {
          let currentPosition = possibleNextPaths.removeLast()
          
          for nextPosition in currentPosition.neighbors(on: grid) {
            guard nextPosition.height - currentPosition.height == 1 else {
              continue
            }

            if nextPosition.height == 9 {
              trailhead.ends.insert(nextPosition)
              trailhead.rating += 1
            }

            possibleNextPaths.append(nextPosition)
          }
        } while !possibleNextPaths.isEmpty
        
        return trailhead
      }
    }
  }
}
