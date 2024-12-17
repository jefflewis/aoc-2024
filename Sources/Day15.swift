import Algorithms
import Collections
import Foundation
import Parsing
import SwiftCurses

struct Day15: AdventDay {
  var data: String
  
  struct InputParser: Parser {
    var body: some Parser<Substring, [[Character]]> {
      Parse({ $0.map({ String($0).characterArray }) }) {
        Many {
          CharacterSet(arrayLiteral: ".", "#", "O", "@", "[", "]")
        } separator: {
          Whitespace(1, .vertical)
        }
        
        Skip {
          Rest()
        }
      }
    }
  }
  
  func part1() async throws -> Any {
    let grid = try InputParser().parse(data).filter({ !$0.isEmpty })
    let moves = data.characterArray.compactMap(Move.init)
    var wharehouse = Wharehouse(
      grid: grid,
      moves: moves
    )
    
    while wharehouse.moves.count > 0 {
      try wharehouse.move()
    }
    
    let sortedWharehouse = Wharehouse(grid: wharehouse.grid, moves: [])
    return sortedWharehouse.boxes
      .map { Point(x: $0.x, y: 100 * $0.y) }
      .map({ $0.x + $0.y })
      .reduce(0, +)
  }
  
  func part2() async throws -> Any {
    let widened = data
      .replacingOccurrences(of: "O", with: "[]")
      .replacingOccurrences(of: ".", with: "..")
      .replacingOccurrences(of: "@", with: "@.")
      .replacingOccurrences(of: "#", with: "##")
    let grid = try InputParser().parse(widened).filter({ !$0.isEmpty })

    var wharehouse = Wharehouse(grid: grid, moves: [])
   
//    try initScreen(
//      settings: [.colors, .noEcho, .raw],
//      windowSettings: [.keypad(true), .intrflush(true)]
//    ) { scr in
//      try wharehouse.draw(scr: scr)
//      outer: while true {
//       let char = try scr.getChar()
//        switch char {
//        case .code(KeyCode.left): wharehouse.moves.append(.left)
//        case .code(KeyCode.up): wharehouse.moves.append(.up)
//        case .code(KeyCode.right): wharehouse.moves.append(.right)
//        case .code(KeyCode.down): wharehouse.moves.append(.down)
//        default: break outer
//        }
//        try wharehouse.move()
//        try wharehouse.draw(scr: scr)
//      }
//    }

    let moves = data.characterArray.compactMap(Move.init)
    wharehouse = Wharehouse(grid: grid, moves: moves)
    while !wharehouse.moves.isEmpty {
      try wharehouse.move()
    }
      
    let sortedWharehouse = Wharehouse(grid: wharehouse.grid, moves: [])
        
    return sortedWharehouse.leftBoxes
      .map { Point(x: $0.x, y: 100 * $0.y) }
      .map({ $0.x + $0.y })
      .reduce(0, +)
  }

  enum Move: Character, Hashable, CaseIterable {
    case left = "<"
    case right = ">"
    case up = "^"
    case down = "v"
  }
  
  struct Wharehouse {
    var grid: [[Character]]
    var robot: Point
    var boxes: Set<Point>
    var walls: Set<Point>
    var moves: [Move]
    var leftBoxes: Set<Point>
    var rightBoxes: Set<Point>
    
    init(grid: [[Character]], moves: [Move]) {
      self.grid = grid
      let (robot, boxes, walls, leftBoxes, rightBoxes) = Wharehouse.position(on: grid)
      self.robot = robot
      self.boxes = boxes
      self.walls = walls
      self.moves = moves
      self.leftBoxes = leftBoxes
      self.rightBoxes = rightBoxes
    }
    
    mutating func moveRobot(to target: Point) {
      grid[target.y][target.x] = "@"
      grid[robot.y][robot.x] = "."
      self.robot = target
      
      #if DEBUG
//      print("moved robot to", target)
      #endif
    }
    
    mutating func move(
      box: Point,
      with movement: Move,
      pending boxes: inout Set<Point>,
      moved: inout [Point:Character]
    ) -> Bool {
      let temp = grid[box.y][box.x]
      
      // no box to move
      if temp == "." {
        return true
      }
      
      // can't move a wall
      if temp == "#" {
        return false
      }
      
      // box is already going to be moved
      if boxes.contains(box) {
        return true
      }
      
      boxes.insert(box)

      switch movement {
      case .left:
        let west = grid[box.y][box.x - 1]
        if west == "#" {
          return false
        }

        if ["[", "]", "O"].contains(west) {
          let westPoint = Point(x: box.x - 1, y: box.y)
          if !move(
            box: westPoint,
            with: movement,
            pending: &boxes,
            moved: &moved
          ) {
            return false
          }
        }

        moved[Point(x: box.x - 1, y: box.y)] = grid[box.y][box.x - 1]
        grid[box.y][box.x - 1] = temp
        grid[box.y][box.x] = "."
        moved[box] = temp
        return true
      case .right:
        let east = grid[box.y][box.x + 1]
        
        if east == "#" {
          return false
        }
        
        if ["[", "]", "O"].contains(east) {
          let eastPoint = Point(x: box.x + 1, y: box.y)
          if !move(
            box: eastPoint,
            with: movement,
            pending: &boxes,
            moved: &moved
          ) {
            return false
          }
        }

        moved[Point(x: box.x + 1, y: box.y)] = grid[box.y][box.x + 1]
        grid[box.y][box.x + 1] = temp
        grid[box.y][box.x] = "."
        moved[box] = temp
        return true
      case .up:
        let north = grid[box.y - 1][box.x]
        
        if north == "#" {
          return false
        }

        switch temp {
        case "[":
          let curr = grid[box.y - 1][box.x + 1]
          if curr == "#" {
            return false
          }
          let target = Point(x: box.x + 1, y: box.y)
          if !move(box: target, with: movement, pending: &boxes, moved: &moved) {
            return false
          }
         case "]":
          let curr = grid[box.y - 1][box.x - 1]
          if curr == "#" {
            return false
          }
          
          let target = Point(x: box.x - 1, y: box.y)
          
          if !move(box: target, with: movement, pending: &boxes, moved: &moved) {
            return false
          }
        default: break
        }
        
        if north == "]" {
          let movedNW = move(
            box: Point(x: box.x - 1, y: box.y - 1),
            with: movement,
            pending: &boxes,
            moved: &moved
          )
          if movedNW {
            let movedN = move(
              box: Point(x: box.x, y: box.y - 1),
              with: movement,
              pending: &boxes,
              moved: &moved
            )
            if !movedN {
              return false
            }
            
            moved[Point(x: box.x, y: box.y - 1)] = north
          } else {
            return false
          }
        }
        
        if north == "[" {
          let movedNE = move(
            box: Point(x: box.x + 1, y: box.y - 1),
            with: movement,
            pending: &boxes,
            moved: &moved
          )
          if movedNE {
            let movedN = move(
              box: Point(x: box.x, y: box.y - 1),
              with: movement,
              pending: &boxes,
              moved: &moved
            )
            if !movedN {
              for (point, value) in moved {
                grid[point.y][point.x] = value
              }
              return false
            }
          } else {
            return false
          }
        }
        
        if north == "O" {
          let movedN = move(
            box: Point(x: box.x, y: box.y - 1),
            with: movement,
            pending: &boxes,
            moved: &moved
          )
          if !movedN {
            return false
          }
        }
        
        moved[Point(x: box.x, y: box.y - 1)] = grid[box.y - 1][box.x]
        grid[box.y - 1][box.x] = temp
        grid[box.y][box.x] = "."
        moved[box] = temp

        return true

      case .down:
        let south = grid[box.y + 1][box.x]
        
        if south == "#" {
          return false
        }

        switch temp {
        case "[":
          let curr = grid[box.y + 1][box.x + 1]
          if curr == "#" {
            return false
          }
          let target = Point(x: box.x + 1, y: box.y)
          
          if !move(box: target, with: movement, pending: &boxes,
                   moved: &moved) {
            return false
          }
          
        case "]":
          let curr = grid[box.y + 1][box.x - 1]
          if curr == "#" {
            return false
          }
          
          let target = Point(x: box.x - 1, y: box.y)
          
          if !move(
            box: target,
            with: movement,
            pending: &boxes,
            moved: &moved
          ) {
            return false
          }
        default: break
        }
        

        switch temp {
        case "[":
          if [south, grid[box.y + 1][box.x + 1]].contains("#") {
            return false
          }
        case "]":
          if [south, grid[box.y + 1][box.x - 1]].contains("#") {
            return false
          }
        default: break
        }
        
        if south == "]" {
          let movedSW = move(
            box: Point(x: box.x - 1, y: box.y + 1),
            with: movement,
            pending: &boxes,
            moved: &moved
          )
          if movedSW {
            let movedS = move(
              box: Point(x: box.x, y: box.y + 1),
              with: movement,
              pending: &boxes,
              moved: &moved
            )
            if !movedS {
              return false
            }
          } else {
            return false
          }
        }
        
        if south == "[" {
          let movedSE = move(
            box: Point(x: box.x + 1, y: box.y + 1),
            with: movement,
            pending: &boxes,
            moved: &moved
          )
          if movedSE {
            let movedS = move(
              box: Point(x: box.x, y: box.y + 1),
              with: movement,
              pending: &boxes,
              moved: &moved
            )
            if !movedS {
              return false
            }
          } else {
            return false
          }
        }
        
        if south == "O" {
          let movedS = move(
            box: Point(x: box.x, y: box.y + 1),
            with: movement,
            pending: &boxes,
            moved: &moved
          )
          if !movedS {
            return false
          }
        }

        moved[Point(x: box.x, y: box.y + 1)] = grid[box.y + 1][box.x]
        grid[box.y + 1][box.x] = temp
        grid[box.y][box.x] = "."
        moved[box] = temp
        return true
      }
    }
  
    mutating func move() throws {
      let next = moves.removeFirst()
      #if DEBUG
//      print("moving", next)
      #endif
      
      let box = switch next {
      case .left: Point(x: robot.x - 1,  y: robot.y)
      case .right: Point(x: robot.x + 1,  y: robot.y)
      case .up: Point(x: robot.x,  y: robot.y - 1)
      case .down: Point(x: robot.x,  y: robot.y + 1)
      }
      
      var pending: Set<Point> = []
      var moved: [Point:Character] = [:]
      let currentGrid = grid
      
      if grid[box.y][box.x] == "." || move(
        box: box,
        with: next,
        pending: &pending,
        moved: &moved
      ) {
        moveRobot(to: box)
      } else {
        self.grid = currentGrid
      }

//      draw()
    }
    
    func draw(scr: Window) throws {
      scr.clear()
      for (row, columns) in grid.enumerated() {
        try scr.addStr("\n")
        for (column, character) in columns.enumerated() {
          try scr.addChar(row: Int32(row), col: Int32(column), character)
        }
      }
      scr.refresh()

      
    }

    func draw() -> String {
      var output = ""
      for columns in grid {
        output += "\n"
        for cell in columns {
          output += String(cell)
        }
      }
      
//      output += "\n\n"
      
      return output

//      #if DEBUG
//      print(output, terminator: "\n\n")
//      #endif
    }
    
    enum MoveError: Error {
      case invalid
    }
    
    static func position(on grid: [[Character]]) -> (
      robot: Point,
      boxes: Set<Point>,
      walls: Set<Point>,
      leftBoxes: Set<Point>,
      rightBoxes: Set<Point>
    ) {
      var robot = Point(x: 0, y: 0)
      var boxes: Set<Point> = []
      var leftBoxes: Set<Point> = []
      var rightBoxes: Set<Point> = []
      var walls: Set<Point> = []
      for (row, columns) in grid.enumerated() {
        for (column, cell) in columns.enumerated() {
          let point = Point(x: column, y: row)
          switch cell {
          case "@": robot = point
          case "O": boxes.insert(point)
          case "#": walls.insert(point)
          case "[": leftBoxes.insert(point)
          case "]": rightBoxes.insert(point)
          default: continue
          }
        }
      }
      
      return (
        robot: robot,
        boxes: boxes,
        walls: walls,
        leftBoxes: leftBoxes,
        rightBoxes: rightBoxes
      )
    }
  }

  struct Point: Hashable {
    let x: Int
    let y: Int
  }
}
