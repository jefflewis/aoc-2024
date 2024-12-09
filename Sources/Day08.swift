//
//  Day08.swift
//  AdventOfCode
//
//  Created by Jeffrey Lewis on 12/4/24.
//

import Algorithms
import Foundation
import Parsing
import Accelerate

struct Day08: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
  
  struct Position: Hashable {
    let x: Int
    let y: Int
    
    func previous(from position: Position) -> Position {
      Position(
        x: position.x - (x - position.x),
        y: position.y - (y - position.y)
      )
    }
    
    func next(from position: Position) -> Position {
      Position(
        x: x + (x - position.x),
        y: y + (y - position.y)
      )
    }
  }

  func part1() -> Any {
    let grid = data.characterGrid
    var stations: Set<Character> = Set(grid.flatMap({ $0.map({ $0 }) } ))
    stations.remove(".")
    
    let stationTowers: [Character: Set<Position>] = stations.reduce(
      [:] as [Character: Set<Position>],
      { partial, station in
        var partial = partial
        partial[station] = Set(
          grid.indices.flatMap { row in
            grid[row].indices.compactMap { column in
              if grid[row][column] == station {
                return Position(x: column, y: row)
              }
              return nil
            }
          }
        )
        
        return partial
      }
    )
    
    
    var antinodes: [Character:Set<Position>] = [:]
    
    for (station, towers) in stationTowers {
      antinodes[station] = []
      for tower in towers {
        var otherTowers = towers
        otherTowers.remove(tower)
        for otherTower in otherTowers {
          // previous
          var next = otherTower.x >= tower.x && otherTower.y >= tower.y ? otherTower : tower
          var current = next == tower ? otherTower : tower
          for antinode in [
            next.previous(from: current),
            next.next(from: current)
          ] {
            // bounds check
            if antinode.x >= 0,
               antinode.y >= 0,
               antinode.x < grid.first!.count,
               antinode.y < grid.count {
              antinodes[station]!.insert(antinode)
            }
          }
        }
      }
    }

    return Set(antinodes.values.flatMap({ $0 })).count
  }

  func part2() -> Any {
    let grid = data.characterGrid
    var stations: Set<Character> = Set(grid.flatMap({ $0.map({ $0 }) } ))
    stations.remove(".")
    
    let stationTowers: [Character: Set<Position>] = stations.reduce(
      [:] as [Character: Set<Position>],
      { partial, station in
        var partial = partial
        partial[station] = Set(
          grid.indices.flatMap { row in
            grid[row].indices.compactMap { column in
              if grid[row][column] == station {
                return Position(x: column, y: row)
              }
              return nil
            }
          }
        )
        
        return partial
      }
    )
    
    
    var antinodes: [Character:Set<Position>] = [:]
    
    for (station, towers) in stationTowers {
      antinodes[station] = []
      for tower in towers {
        var otherTowers = towers
        otherTowers.remove(tower)
        for otherTower in otherTowers {
          // previous
          var next = otherTower.x >= tower.x && otherTower.y >= tower.y ? otherTower : tower
          var current = next == tower ? otherTower : tower
          var previous = next.previous(from: current)
          
          repeat {
            // bounds check
            if previous.x >= 0, previous.y >= 0, previous.x < grid.first!.count,
               previous.y < grid.count  {
              antinodes[station]!.insert(previous)
            }

            next = current
            current = previous
            previous = next.previous(from: current)
          } while previous.x >= 0 && previous.y >= 0
          
          next = otherTower.x >= tower.x && otherTower.y >= tower.y ? otherTower : tower
          current = next == tower ? otherTower : tower
          previous = next.previous(from: current)

          repeat {
            // bounds check
            if next.x >= 0,
               next.y >= 0,
              next.x < grid.first!.count,
              next.y < grid.count {
              antinodes[station]!.insert(next)
            }
            
            previous = current
            current = next
            next = next.next(from: previous)

          } while next.x < grid.first!.count && next.y < grid.count
        }
      }
    }
    
    
    return Set(
      antinodes.values.flatMap({ $0 })
    ).union(
      stationTowers.values.flatMap({ $0 })
    ).count
  }
}
