import Foundation

struct Game2048 {
    private(set) var board: [[Int]]
    private(set) var score: Int = 0
    private var previousBoard: [[Int]] = []
    private var previousScore: Int = 0
    
    let size = 4
    
    init() {
        board = Array(repeating: Array(repeating: 0, count: size), count: size)
        reset()
    }
    
    mutating func reset() {
        board = Array(repeating: Array(repeating: 0, count: size), count: size)
        score = 0
        addNewTile()
        addNewTile()
    }
    
    mutating func undo() {
        guard !previousBoard.isEmpty else { return }
        board = previousBoard
        score = previousScore
    }
    
    mutating func move(_ direction: Direction) -> Bool {
        savePreviousState()
        var moved = false
        
        switch direction {
        case .up:
            moved = moveUp()
        case .down:
            moved = moveDown()
        case .left:
            moved = moveLeft()
        case .right:
            moved = moveRight()
        }
        
        if moved {
            addNewTile()
        }
        return moved
    }
    
    private mutating func savePreviousState() {
        previousBoard = board
        previousScore = score
    }
    
    private mutating func addNewTile() {
        let emptyTiles = board.flatMap { $0.enumerated() }.enumerated().filter { $1.element == 0 }
        guard !emptyTiles.isEmpty else { return }
        
        let randomIndex = Int.random(in: 0..<emptyTiles.count)
        let position = emptyTiles[randomIndex].offset
        let value = Int.random(in: 0..<10) < 9 ? 2 : 4
        board[position / size][position % size] = value
    }
    
    private mutating func moveUp() -> Bool { return moveVertical(up: true) }
    private mutating func moveDown() -> Bool { return moveVertical(up: false) }
    private mutating func moveLeft() -> Bool { return moveHorizontal(left: true) }
    private mutating func moveRight() -> Bool { return moveHorizontal(left: false) }
    
    private mutating func moveVertical(up: Bool) -> Bool {
        var moved = false
        for col in 0..<size {
            var column = (0..<size).map { board[$0][col] }
            if up {
                column = mergeAndCompact(column)
            } else {
                column.reverse()
                column = mergeAndCompact(column)
                column.reverse()
            }
            for row in 0..<size {
                if board[row][col] != column[row] {
                    board[row][col] = column[row]
                    moved = true
                }
            }
        }
        return moved
    }
    
    private mutating func moveHorizontal(left: Bool) -> Bool {
        var moved = false
        for row in 0..<size {
            var line = board[row]
            if left {
                line = mergeAndCompact(line)
            } else {
                line.reverse()
                line = mergeAndCompact(line)
                line.reverse()
            }
            if board[row] != line {
                board[row] = line
                moved = true
            }
        }
        return moved
    }
    
    private func mergeAndCompact(_ line: [Int]) -> [Int] {
        var result: [Int] = []
        var skip = false
        for i in 0..<line.count {
            if skip {
                skip = false
                continue
            }
            if i + 1 < line.count && line[i] == line[i + 1] {
                result.append(line[i] * 2)
                skip = true
            } else {
                result.append(line[i])
            }
        }
        while result.count < size {
            result.append(0)
        }
        return result
    }
}

enum Direction {
    case up, down, left, right
}
