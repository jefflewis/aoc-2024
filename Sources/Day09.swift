//
//  Day09.swift
//  AdventOfCode
//
//  Created by Jeffrey Lewis on 12/4/24.
//

import Algorithms
import Foundation

struct Day09: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
  
  struct File: Hashable, Identifiable {
    let id: Int
    let size: Int
  }
  
  struct FreeSpace: Hashable {
    let size: Int
  }

  struct DiskMap {
    internal init(files: [Day09.File] = [], freespace: [Day09.FreeSpace] = []) {
      self.files = files
      self.freespace = freespace
    }
    
    var files: [File] = []
    var freespace: [FreeSpace] = []
    
    var blocks: [DiskBlock] {
      files.flatMap({ file in
        file.id < freespace.count
        ? [.file(file), .free(freespace[file.id].size)]
        : [.file(file)]
      })
    }
    
    static func from(data: String) -> DiskMap {
      data.characterArray.enumerated().reduce(
        into: DiskMap(),
        { partialResult, next in
          guard let value = Int(String(next.element)) else {
            return
          }
          
          if next.offset % 2 == 0 {
            partialResult.files.append(
              File(id: partialResult.files.count, size: value)
            )
          } else {
            partialResult.freespace.append(FreeSpace(size: value))
          }
        })
    }
    
    enum DiskBlock: Equatable{
      case file(File)
      case free(Int)
      
      var expanded: [Int] {
        switch self {
        case let .file(file): (0..<file.size).map({ _ in file.id })
        case let .free(space): (0..<space).map({ _ in 0 })
        }
      }
    }
  }
 
  func part1() -> Any {
    let diskmap = DiskMap.from(data: data)
    var blocks = diskmap.blocks
    defragment(&blocks)
    return blocks.checksum
  }

  func part2() -> Any {
    let diskmap = DiskMap.from(data: data)
    var blocks = diskmap.blocks
    defragment(&blocks, fragments: false)
    return blocks.checksum
  }
  
  func defragment(
    _ blocks: inout [Day09.DiskMap.DiskBlock],
    fragments: Bool = true
  ) -> Void {
    var targetSpace = 1
    while targetSpace <= 9 {
      // find first available space to be filled
      guard let freeIndex = blocks.freeSpace(for: targetSpace),
            case let .free(space) = blocks[freeIndex]
      else { break }
      
      guard let fileIndex = blocks.lastFile(with: fragments ? .max : space) else {
        continue
      }
      
      guard freeIndex < fileIndex else {
        // files must be moved to earlier position
        guard !fragments else { break }
        // - try subsequent free blocks instead
        targetSpace += 1
        continue
      }
      
      guard case .file(let file) = blocks[fileIndex] else {
        fatalError("block at index is not a file")
      }
      
      // put file in the free space:
      blocks[freeIndex] = .file(File(id: file.id, size: min(file.size, space)))
      
      let remainingSpace = space - file.size
      // clear up the file that has been copied
      blocks[fileIndex] = .free(min(space, file.size))
      
      // remainder of file
      if file.size > space {
        blocks.insert(.file(File(id: file.id, size: file.size - space)), at: fileIndex + 1)
      }
      
      if remainingSpace > 0 {
        blocks.insert(.free(remainingSpace), at: freeIndex + 1)
      }
    }

  }
}

extension Array where Element == Day09.DiskMap.DiskBlock {
  var checksum: Int {
    flatMap(\.expanded).enumerated().map(*).reduce(0, +)
  }

  func freeSpace(for atLeastSize: Int) -> Int? {
    firstIndex(where: { block in
      switch block {
      case .file: false
      case .free(let space): space >= atLeastSize
      }
    })
  }
  
  func lastFile(with atMostSize: Int) -> Int? {
    lastIndex(where: { block in
      switch block {
      case .file(let file): file.size <= atMostSize
      case .free: false
      }
    })
  }
}
