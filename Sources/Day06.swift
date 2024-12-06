//
//  Day06.swift
//  AdventOfCode
//
//  Created by Jeffrey Lewis on 12/4/24.
//

import Algorithms
import Foundation
import Parsing
import Collections

struct Day06: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
  
  struct Player {
    var position: Position
    var direction: Direction = .up
    var steps: [Position] = []
    var turns: OrderedSet<Turn> = []
    
    var uniquePositions: Set<Position> {
      Set(steps)
    }
  }
    
  struct Position: Hashable {
    var x: Int
    var y: Int
  }
  
  struct Turn: Hashable {
    let direction: Direction
    let position: Position
  }
  
  //  If there is something directly in front of you, turn right 90 degrees.
  //  Otherwise, take a step forward.
  //  How many distinct positions will the guard visit before leaving the mapped area?
  func part1() -> Any {
    let grid = data.characterGrid
    guard let startY = grid.firstIndex(where: { $0.contains("^") }),
          let startX = grid[startY].firstIndex(of: "^") else {
      return 0
    }
    
    var player = Player(position: .init(x: startX, y: startY))
    
    while player.position.x < grid[0].count - 1,
          player.position.y < grid.count - 1,
          player.position.x - 1 >= 0,
          player.position.y - 1 >= 0 {
      try! move(player: &player, grid: grid)
    }

    return player.uniquePositions.count
  }
  
  func part2() -> Any {
    let grid = data.characterGrid
    guard let startY = grid.firstIndex(where: { $0.contains("^") }),
          let startX = grid[startY].firstIndex(of: "^") else {
      return 0
    }

    var loopedObstaclePlacements: [Position] = []
    
    for row in grid.indices {
      for column in grid[row].indices {
        var player = Player(position: .init(x: startX, y: startY))
        let obstacle = Position(x: column, y: row)
        guard obstacle != player.position else {
          continue
        }
          
        var gridWithObstacle = grid
        gridWithObstacle[row][column] = "#"
        do {
          while player.position.x < gridWithObstacle[0].count - 1,
                player.position.y < gridWithObstacle.count - 1,
                player.position.x - 1 >= 0,
                player.position.y - 1 >= 0 {
              try move(player: &player, grid: gridWithObstacle)
          }
        } catch {
          loopedObstaclePlacements.append(obstacle)
        }
      }
    }
    
    

    return loopedObstaclePlacements.count
  }
  
  func move(player: inout Player, grid: [[Character]]) throws {
    player.steps.append(player.position)

    let turnsTaken = player.turns.count
    
    switch player.direction {
    case .up:
      if grid[player.position.y - 1][player.position.x] == "#" {
        player.turns.append(Turn(direction: .up, position: player.position))
        if player.turns.count == turnsTaken {
          throw GridError.looped
        }
          
        player.direction = .right
        return
      }
      player.position.y -= 1
      
      case .down:
      if grid[player.position.y + 1][player.position.x] == "#" {
        player.turns.append(Turn(direction: .down, position: player.position))
        if player.turns.count == turnsTaken {
          throw GridError.looped
        }
        player.direction = .left
        return
      }
      player.position.y += 1
      
      case .left:
      if grid[player.position.y][player.position.x - 1] == "#" {
        player.turns.append(Turn(direction: .left, position: player.position))
        if player.turns.count == turnsTaken {
          throw GridError.looped
        }
        player.direction = .up
        return
      }
      player.position.x -= 1
      
      case .right:
      if grid[player.position.y][player.position.x + 1] == "#" {
        player.turns.append(Turn(direction: .right, position: player.position))
        if player.turns.count == turnsTaken {
          throw GridError.looped
        }
        player.direction = .down
        return
      }
      player.position.x += 1
    }
  }
  
  enum Direction: Hashable {
    case up, down, left, right
  }
  
  enum GridError: Error {
    case looped
  }
}

extension StringProtocol {

  var lines: [String] {
    components(separatedBy: .newlines).filter { !$0.isEmpty }
  }
  
  var characterArray: [Character] {
    filter { !$0.isWhitespace }
  }
  
  var characterGrid: [[Character]] {
    lines.map { $0.characterArray }
  }
}
