import Algorithms
import Collections
import Foundation
import Parsing

struct Day14: AdventDay {
  var data: String
  
  func part1() async throws -> Any {
    var robots = try data
      .split(separator: .newlineSequence)
      .filter({ !$0.trimmingCharacters(in: .whitespaces).isEmpty })
      .map { try RobotParser().parse($0) }
    
    let bigBoard = robots.map(\.position.x).max(by: {$0 < $1})! < 50
    let max = bigBoard ? Point(x: 11, y: 7) : Point(x: 101, y: 103)

    for _ in 0..<100 {
      robots = robots.map({ $0.move(with: max) })
    }

    let grouped = robots.grouped { $0.quadrant(for: max) }
    
    return grouped
      .filter({ $0.key != .middle })
      .values
      .map(\.count)
      .reduce(1, *)
  }
  
  enum Quadrant: Hashable {
    case topLeft, topRight, bottomLeft, bottomRight, middle
  }
  
  func part2() async throws -> Any {
    var robots = try data
      .split(separator: .newlineSequence)
      .filter({ !$0.trimmingCharacters(in: .whitespaces).isEmpty })
      .map { try RobotParser().parse($0) }
    
    let bigBoard = robots.map(\.position.x).max(by: {$0 < $1})! < 50
    let max = bigBoard ? Point(x: 11, y: 7) : Point(x: 101, y: 103)

    var seconds = 0
    repeat {
      robots = robots.map({ $0.move(with: max) })
      seconds += 1

      // Are all the robots on their own space?
      if Set(robots.map(\.position)).count == robots.count {
        draw(robots: robots, with: max)
        return seconds
      }
    } while true
  }
  
  func draw(robots: [Robot], with max: Point) {
    var output = ""
    
    for row in 0...max.y {
      output += "\n"
      for column in 0...max.x {
        if robots.first(where: { $0.position.x == column && $0.position.y == row }) != nil {
          output += "🤖"
        } else {
          output += "・"
        }
      }
    }
    
    print(output)
  }
  
  struct Robot {
    var position: Point
    var velocity: Velocity
    
    func quadrant(for max: Point) -> Quadrant {
      switch position {
      case let position where position.x < max.x / 2 && position.y < max.y / 2:
        .topLeft
      case let position where position.x > max.x / 2 && position.y < max.y / 2:
        .topRight
      case let position where position.x < max.x / 2 && position.y > max.y / 2:
        .bottomLeft
      case let position where position.x > max.x / 2 && position.y > max.y / 2:
        .bottomRight
      default:
        .middle
      }
    }

    func move(with max: Point) -> Robot {
    var robot = self
     var targetX = (position.x + velocity.x) % max.x
      if targetX < 0 {
        targetX += max.x
      }

      var targetY = (position.y + velocity.y) % max.y
      if targetY < 0 {
        targetY += max.y
      }
      
      robot.position.x = targetX
      robot.position.y = targetY
      
      return robot
    }
  }
  
  struct Point: Hashable {
    var x: Int
    var y: Int
  }
  
  struct Velocity: Hashable {
    var x: Int
    var y: Int
  }

  struct RobotParser: Parser {
    var body: some Parser<Substring, Robot> {
      Parse({ Robot(position: $0, velocity: $1) }) {
        PointParser()
        Whitespace(.horizontal)
        VelocityParser()
      }
    }
  }
  
  struct CoordinateParser: Parser {
    var body: some Parser<Substring, (Int, Int)> {
      Parse(({ ($0, $1)  })) {
        Int.parser()
        ","
        Int.parser()
      }
    }
  }
  
  struct PointParser: Parser {
    var body: some Parser<Substring, Point> {
      Parse(Point.init) {
        "p="
        CoordinateParser()
      }
    }
  }
  
  struct VelocityParser: Parser {
    var body: some Parser<Substring, Velocity> {
      Parse(Velocity.init) {
        "v="
        CoordinateParser()
      }
    }
  }
}
