import Foundation

enum Direction {
    case up, down, left, right
}

struct GameModel {
    private(set) var board: [[Int]]
    private(set) var score: Int
    private var previousBoard: [[Int]]
    private var previousScore: Int
    private let size: Int

    init(size: Int = 4) {
        self.size = size
        self.board = Array(repeating: Array(repeating: 0, count: size), count: size)
        self.previousBoard = board
        self.previousScore = 0
        self.score = 0
        spawnTile()
        spawnTile()
    }

    mutating func reset() {
        previousBoard = board
        previousScore = score
        board = Array(repeating: Array(repeating: 0, count: size), count: size)
        score = 0
        spawnTile()
        spawnTile()
    }

    mutating func undo() {
        board = previousBoard
        score = previousScore
    }

    mutating func move(_ direction: Direction) -> Bool {
        previousBoard = board
        previousScore = score
        var moved = false

        switch direction {
        case .up:
            for col in 0..<size {
                let result = mergeLine(extractColumn(col))
                moved = moved || result.moved
                setColumn(col, result.line)
            }
        case .down:
            for col in 0..<size {
                let result = mergeLine(extractColumn(col).reversed())
                moved = moved || result.moved
                setColumn(col, result.line.reversed())
            }
        case .left:
            for row in 0..<size {
                let result = mergeLine(board[row])
                moved = moved || result.moved
                board[row] = result.line
            }
        case .right:
            for row in 0..<size {
                let result = mergeLine(board[row].reversed())
                moved = moved || result.moved
                board[row] = result.line.reversed()
            }
        }

        if moved {
            spawnTile()
        }

        return moved
    }

    private mutating func spawnTile() {
        let emptyTiles = board.indices.flatMap { row in
            board[row].indices.compactMap { col in board[row][col] == 0 ? (row, col) : nil }
        }

        guard let randomTile = emptyTiles.randomElement() else { return }
        board[randomTile.0][randomTile.1] = Int.random(in: 1...10) <= 9 ? 2 : 4
    }

    private func extractColumn(_ col: Int) -> [Int] {
        return board.map { $0[col] }
    }

    private mutating func setColumn(_ col: Int, _ column: [Int]) {
        for row in 0..<size {
            board[row][col] = column[row]
        }
    }

    private mutating func mergeLine(_ line: [Int]) -> (line: [Int], moved: Bool) {
        let filteredLine = line.filter { $0 != 0 }
        var mergedLine: [Int] = []
        var moved = false

        var skip = false
        for i in 0..<filteredLine.count {
            if skip {
                skip = false
                continue
            }
            if i < filteredLine.count - 1 && filteredLine[i] == filteredLine[i + 1] {
                mergedLine.append(filteredLine[i] * 2)
                score += filteredLine[i] * 2
                skip = true
                moved = true
            } else {
                mergedLine.append(filteredLine[i])
            }
        }

        while mergedLine.count < size {
            mergedLine.append(0)
        }

        return (mergedLine, moved || mergedLine != line)
    }
    
    var isGameOver: Bool {
        for row in 0..<size {
            for col in 0..<size {
                if board[row][col] == 0 {
                    return false
                }
                if col < size - 1 && board[row][col] == board[row][col + 1] {
                    return false
                }
                if row < size - 1 && board[row][col] == board[row + 1][col] {
                    return false
                }
            }
        }
        return true
    }
}
