import Algorithms
import Collections
import Foundation

struct Day12: AdventDay {
  var data: String
  
  struct Plot : Hashable {
    var plant: Character
    var id: Int = 0
    var corners: Int = 0
    var fences: Set<Fence> = []
    
    enum Fence {
      case top, bottom, left, right
    }
  }
  
  struct Region: Hashable {
    let plant: Character
    var positions: Set<Position> = []
    
    var area: Int {
      positions.count
    }
 
    func draw() -> String {
      let horizontal = positions.minAndMax { $0.x < $1.x }
      let veritcal = positions.minAndMax { $0.y < $1.y}
      return (
        veritcal!.min.y-1...veritcal!.max.y+1
      ).flatMap({ row in
        var rows = (horizontal!.min.x-1...horizontal!.max.x+1).compactMap { column in
          if self.positions.contains(Position(x:column, y: row, plant: plant)) {
            return String(plant)
          }
          
          return "•"
        }
        
        rows.append("\n")
        
        return rows
      }).joined()
    }
  }
  
  struct Position: Hashable {
    var x: Int
    var y: Int
    let plant: Character
    
    enum Direction: CaseIterable {
      case north, south, east, west
      
      var opposite: Direction {
        switch self {
        case .north: .south
        case .south: .north
        case .east: .west
        case .west: .east
        }
      }
    }
    
    func neighbors(on grid: [[Character]]) -> [Position] {
      ((max(0, y-1))...min(y+1, grid.count - 1)).flatMap { row in
        (max(0,x-1)...min(x+1, grid[0].count - 1)).compactMap { column in
          Position(x: column, y: row, plant: grid[row][column])
        }
      }
    }
  }

  func part1() async throws -> Any {
    let (result, _) = results(for: data)
    
    return result
  }
  
  func part2() async throws -> Any {
    let (_, result) = results(for: data)
    
    return result
  }
  
  func results(for input: String) -> (Int, Int) {
    let grid = input.characterGrid
    
    var garden = grid.enumerated().map { (row, columns) in
      columns.map { Plot(plant: $0) }
    }

    // insert fences into each plot
    fences(for: &garden)
    
    // insert region ID into each plot
    regions(for: &garden)
    
    // insert corner count into each plot
    corners(for: &garden)

    var areas: [Int:Int] = [:]
    var perimeters: [Int:Int] = [:]
    var corners: [Int:Int] = [:]
        
    for columns in garden {
      for plot in columns {
        guard let area = areas[plot.id],
              let perimeter = perimeters[plot.id],
              let corner = corners[plot.id]
        else {
          areas[plot.id] = 1
          perimeters[plot.id] = plot.fences.count
          corners[plot.id] = plot.corners
          continue
        }

        areas[plot.id] = area + 1
        perimeters[plot.id] = perimeter + plot.fences.count
        corners[plot.id] = corner + plot.corners
      }
    }
    
    return areas.reduce(into: (0, 0), { partialResult, next in
      let (id, area) = next
      partialResult.0 += area * perimeters[id]!
      partialResult.1 += area * corners[id]!
    })
  }
  
  func fences(for garden: inout [[Plot]]) {
    for row in garden.indices {
      for column in garden[row].indices {
        // is top or one above is not in plot
        if row == 0 || garden[row][column].plant != garden[row-1][column].plant {
          garden[row][column].fences.insert(.top)
        }
        // is bottom or one below is not in plot
        if row == garden.count - 1 || garden[row][column].plant != garden[row + 1][column].plant {
          garden[row][column].fences.insert(.bottom)
        }
        // is leading or one left is not in plot
        if column == 0 || garden[row][column].plant != garden[row][column - 1].plant {
          garden[row][column].fences.insert(.left)
        }
        // is trailing or one right is not in plot
        if column == garden[row].count-1 || garden[row][column].plant != garden[row][column + 1].plant {
          garden[row][column].fences.insert(.right)
        }
      }
    }
  }
  
  func regions(for garden: inout [[Plot]]) {
    var queue = Deque<(y: Int, x: Int)>()
    var currentRegion = 0
    var row = 0
    while row < garden.count {
      var column = 0
      while column < garden[row].count {
        if garden[row][column].id == 0 {
          currentRegion += 1
          queue.append((row, column))
          while !queue.isEmpty {
            let (y, x) = queue.popFirst()!
            if garden[y][x].id == 0 {
              garden[y][x].id = currentRegion
              if !garden[y][x].fences.contains(.left) {
                queue.append((y, x - 1))
              }
              if !garden[y][x].fences.contains(.right) {
                queue.append((y, x + 1))
              }
              if !garden[y][x].fences.contains(.top) {
                queue.append((y - 1, x))
              }
              if !garden[y][x].fences.contains(.bottom) {
                queue.append((y + 1, x))
              }
            }
          }
        }
        column += 1
      }
      row += 1
    }
  }
  
  func corners(for garden: inout [[Plot]]) {
    for y in garden.indices {
      for x in garden[y].indices {
        var plot = garden[y][x]
        let fences = plot.fences
        
        // Start with the corners from the fences
        plot.corners = fences.corners
        
        // Find outside corners
        
        // top left
        if x > 0 && y > 0 &&
            !fences.contains(.top) &&
            !fences.contains(.left) &&
            plot.plant != garden[y - 1][x - 1].plant {
          plot.corners += 1
        }
        
        // top right
        if  x < garden[y].count - 1 && y > 0 &&
              !fences.contains(.top) &&
              !fences.contains(.right) &&
              plot.plant != garden[y - 1][x + 1].plant {
          plot.corners += 1
        }
        
        // bottom left
        if x > 0 && y < garden.count-1 &&
            !fences.contains(.bottom) &&
            !fences.contains(.left) &&
            plot.plant != garden[y + 1][x - 1].plant {
          plot.corners += 1
        }
        
        // bottom right
        if x < garden[y].count - 1 && y < garden.count - 1 &&
            !fences.contains(.bottom) &&
            !fences.contains(.right) &&
            plot.plant != garden[y + 1][x + 1].plant {
          plot.corners += 1
        }
        garden[y][x] = plot
      }
    }
  }
}

extension Set where Element == Day12.Plot.Fence {
  var corners: Int {
    switch self {
      // single or no fence
    case [], [.top], [.left], [.right], [.bottom]: 0
      // fenced on two opposite sides
    case [.top, .bottom], [.left, .right]: 0
      // corner fenced on two adjacent sides
    case [.bottom, .left], [.bottom, .right], [.top, .left], [.top, .right]: 1
      // fenced on three sides
    case [.top, .right, .bottom],
      [.right, .bottom, .left],
      [.bottom, .left, .top],
      [.left, .top, .right]: 2
      // fenced on all sides
    case [.top, .left, .right, .bottom]: 4
    default: 0
    }
  }
}
