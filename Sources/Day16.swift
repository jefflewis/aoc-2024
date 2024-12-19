import Algorithms
import Collections
import HeapModule

struct Day16: AdventDay {
  var data: String
  
  func part1() async throws -> Any {
    let maze = Maze(data: data)
    return maze.minScore
  }

  func part2() async throws -> Any {
    let maze = Maze(data: data)
    return maze.bestPoints.count
  }
  
  struct Maze {
    var queue = Heap<Path>()
    var board: [Point:Cell] = [:]
    var visited: [Point: [Direction:Int]] = [:]
    var end: Point
    
    init(data: String) {
      var visited: [Point: [Direction:Int]] = [:]
      var board: [Point:Cell] = [:]
      var queue = Heap<Path>()
      var end = Point(x: 0, y: 0)
      
      for (row, columns) in data.characterGrid.enumerated() {
        for (column, cell) in columns.compactMap(Cell.init).enumerated() {
          let position = Point(x: column, y: row)
          board[position] = cell
          visited[position] = [
            .north: .max,
            .south: .max,
            .east: .max,
            .west: .max
          ]
          var path = Path(start: position)
          if cell == .start {
            path.move(to: path.start)
            path.direction = .east
            queue.insert(path)
          } else if cell == .end {
            end = position
          }
        }
      }
      
      self.board = board
      self.visited = visited
      self.queue = queue
      self.end = end
    }
    
    mutating func traverse(from path: Path) {
      // traverse path in current direction
      var currentPath = path
      traverse(&currentPath)
      
      // traverse left path
      var turnLeftPath = path.turning(.left)
      traverse(&turnLeftPath)
      
      // traverse right path
      var turnRightPath = path.turning(.right)
      traverse(&turnRightPath)
    }
    
    private mutating func traverse(_ path: inout Path) {
      var lastPoint = path.end
      lastPoint.move(path.direction)
      path.move(to: lastPoint)
      if board[lastPoint] != .wall,
         let visitedScore = visited[lastPoint]?[path.direction],
         path.score <= visitedScore  {
        visited[lastPoint]![path.direction] = path.score
        queue.insert(path)
      }
    }
    
    var minScore: Int {
      var maze = self
      while !maze.queue.isEmpty {
        let path = maze.queue.popMin()!
        if path.end == maze.end {
          return path.score
        } else {
          maze.traverse(from: path)
        }
      }

      fatalError("maze has no path to end")
    }
    
    var bestPoints: Set<Point> {
      var maze = self
      var bestScore = Int.max
      var moves = Set<Point>()
      
      while !maze.queue.isEmpty {
        let path = maze.queue.popMin()!
        if path.end == maze.end {
          switch path.score {
          case 0..<bestScore:
            bestScore = path.score
            moves.formUnion(path.moves)
          case bestScore:
            moves.formUnion(path.moves)
          default:
            return moves
          }
        } else {
          maze.traverse(from: path)
        }
      }
      
      fatalError("maze has no path to end")
    }
  }
  
  
  struct Point: Hashable {
    var x: Int
    var y: Int
    
    mutating func move(_ direction: Direction) {
      switch direction {
      case .east: x+=1
      case .south: y-=1
      case .west: x-=1
      case .north: y+=1
      }
    }
  }
  
  enum Direction: Character, Hashable, CaseIterable {
    case north = "^"
    case south = "v"
    case east = "<"
    case west = ">"
  }
  
  enum Cell: Character, Hashable {
    case wall = "#"
    case open = "."
    case start = "S"
    case end = "E"
  }
  
  enum Turn {
    case left, right
  }
  
  struct Path : Comparable {
    var start: Point
    var turns: [Turn] = []
    var moves: [Point] = []
    
    var end: Point {
      moves.last ?? start
    }
    
    var direction: Direction = .east
    var score: Int {
      moves.count - 1 + turns.count * 1000
    }
    
    mutating func move(to point: Point) {
      moves.append(point)
    }
    
    func turning(_ turn: Turn) -> Path {
      var path = self
      path.turns.append(turn)

      path.direction = switch direction {
      case .east: turn == .left ? .north : .south
      case .south: turn == .left ? .east : .west
      case .west: turn == .left ? .south : .north
      case .north: turn == .left ? .west : .east
      }
      
      return path
    }
    
    static func < (lhs: Path, rhs: Path) -> Bool {
      lhs.score < rhs.score
    }
    
    static func == (lhs: Path, rhs: Path) -> Bool {
      lhs.score == rhs.score
    }
  }
}

