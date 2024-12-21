import Algorithms
import Collections
import Foundation

struct Day20: AdventDay {
  var data: String
  func part1() async throws -> Any {
    let saving = data.characterGrid.count > 50 ? 100 : 1
    return try cheats(for: data, saving: saving, within: 2)
  }
  
  func part2() async throws -> Any {
    let saving = data.characterGrid.count > 50 ? 100 : 50
    return try cheats(for: data, saving: saving, within: 20)
  }
  
  func cheats(for data: String, saving: Int, within cheatDistance: Int) throws -> Int {
    var blocked: Set<Point> = []
    var start = Point(x: 0, y: 0)
    var end = Point(x: 0, y: 0)
    let gridMax = Point(
      x: data.characterGrid[0].count - 1,
      y: data.characterGrid.count - 1
    )
    
    for (row, columns) in data.characterGrid.enumerated() {
      for (column, value) in columns.enumerated() {
        let point = Point(x: column, y: row)
        switch value {
        case "#": blocked.insert(point)
        case "S":
          start = point
        case "E":
          end = point
        default:
          break
        }
      }
    }

    let standardPath = try Path.shortest(
      from: start,
      to: end,
      blocked: blocked,
      bounded: gridMax
    )

    let pathPoints = Array(([start] + standardPath.moves).enumerated())
    
    var cheats = [Int: Int]()
    for (index, point) in pathPoints {
      let candidates = pathPoints[index...].filter {
        $0.element.manhattanDistance(to: point) <= cheatDistance
      }
      for (offset, nextPoint) in candidates {
        let distance = point.manhattanDistance(to: nextPoint)
        if offset > index + distance {
          cheats[offset - index - distance, default: 0] += 1
        }
      }
    }
    
    return cheats.filter({ $0.key >= saving }).map(\.value).reduce(0, +)
  }
  
  struct Cheat: Hashable {
    let path: Path
    let savings: Int
  }
  
  struct Point: Hashable {
    let x: Int
    let y: Int
    
    func moved(in direction: Direction, step: Int = 1) -> Point {
      switch direction {
      case .east: Point(x: x + step, y: y)
      case .south: Point(x: x,y:  y + step)
      case .west: Point(x: x - step, y: y)
      case .north: Point(x: x, y: y - step)
      }
    }
    
    var neighbors: [Point] {
      Direction.allCases.map({ moved(in: $0) })
    }
    
    func manhattanDistance(to point: Point) -> Int{
      abs(y - point.y) + abs(x - point.x)
    }
  
    func within(bounds: Point) -> Bool {
      x < bounds.x &&
      y < bounds.y &&
      x > 0 &&
      y > 0
    }
  }
  
  enum Direction: Hashable, CaseIterable {
    case north
    case south
    case east
    case west
  }
  
  struct Path : Comparable, Hashable {
    var start: Point
    var moves: OrderedSet<Point> = []
    
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
 
    static func shortest(from: Point, to: Point, blocked: Set<Point>, bounded: Point) throws -> Path {
      var queue = Heap<Path>()
      
      queue.insert(Path(start: from))
      
      var visited = [Point: Int]()
      visited[from] = 0
      
      while !queue.isEmpty {
        let path = queue.popMin()!
        if path.end == to {
          return path
        } else {
          for direction in Direction.allCases {
            var nextPath = path
            nextPath.move(to: path.end.moved(in: direction))
            
            guard !blocked.contains(nextPath.end),
                  nextPath.end.within(bounds: bounded),
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
