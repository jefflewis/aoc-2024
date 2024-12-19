import Algorithms
import Collections
import Foundation

struct Day18: AdventDay {
  var data: String
  func part1() async throws -> Any {
    let maze = Maze(data: data)
    let blocked =  Set(maze.fallenBytes.prefix(maze.end.x == 70 ? 1024 : 12 ))
    return try maze
      .shortestPath(from: Point(x: 0, y: 0), blocked: blocked)
      .score
  }
  
  func part2() async throws -> Any {
    let maze = Maze(data: data)
    for (index, fallenByte) in maze.fallenBytes.enumerated() {
      let blocked = Set(maze.fallenBytes.prefix(through: index))
      do {
        _ = try maze.shortestPath(from: Point(x: 0, y: 0), blocked: blocked)
      } catch MazeError.cannotExit {
        return "\(fallenByte.x),\(fallenByte.y)"
      }
    }
    
    throw MazeError.cannotExit
  }
  
  struct Point: Hashable {
    let x: Int
    let y: Int

    func moved(in direction: Direction) -> Point {
      switch direction {
      case .east: Point(x: x + 1, y: y)
      case .south: Point(x: x,y:  y + 1)
      case .west: Point(x: x - 1, y: y)
      case .north: Point(x: x, y: y - 1)
      }
    }
    
    func within(bounds: Point) -> Bool {
      x <= bounds.x &&
      y <= bounds.y &&
      x >= 0 &&
      y >= 0
    }
  }

  enum Direction: Hashable, CaseIterable {
    case north
    case south
    case east
    case west
  }

  struct Path : Comparable {
    var start: Point
    var moves: [Point] = []
    
    var end: Point {
      moves.last ?? start
    }
    
    var score: Int {
      moves.count
    }
    
    var direction: Direction = .south
    
    mutating func move(to point: Point) {
      moves.append(point)
    }

    static func < (lhs: Path, rhs: Path) -> Bool {
      lhs.score < rhs.score
    }
    
    static func == (lhs: Path, rhs: Path) -> Bool {
      lhs.score == rhs.score
    }
  }
  
  struct Maze {
    var end: Point
    let fallenBytes: [Point]

    init(data: String) {
      self.fallenBytes = data.split(separator: .newlineSequence)
        .map({
          $0
            .trimmingCharacters(in: .whitespaces)
            .split(separator: ",")
            .map(String.init)
            .compactMap(Int.init)
        })
        .map({ Point(x: $0[0], y: $0[1]) })

      let gridSize = max(
        fallenBytes.map(\.x).max() ?? 0,
        fallenBytes.map(\.y).max() ?? 0
      )
      self.end = Point(x: gridSize, y: gridSize)
    }

    func shortestPath(from: Point, blocked: Set<Point>) throws -> Path {
      var queue = Heap<Path>()
      
      queue.insert(Path(start: from))
      
      var visited = [Point: Int]()
      visited[from] = 0
      
      while !queue.isEmpty {
        let path = queue.popMin()!
        if path.end == end {
          return path
        } else {
          for direction in Direction.allCases {
            var nextPath = path
            nextPath.move(to: path.end.moved(in: direction))

            guard !blocked.contains(nextPath.end),
                  nextPath.end.within(bounds: end),
                  (visited[nextPath.end] == nil || visited[nextPath.end]! > nextPath.score)
            else { continue }

            visited[nextPath.end] = nextPath.score
            queue.insert(nextPath)
          }
        }
      }
      
      throw MazeError.cannotExit
    
    }
  }
  
  enum MazeError: Error {
    case cannotExit
  }
}

