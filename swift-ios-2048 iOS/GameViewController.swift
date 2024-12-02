import UIKit

class GameViewController: UIViewController {
    private var game = Game2048()
    private var boardViews: [[UILabel]] = []
    private let size = 4

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGestures() // Добавляем жесты
        updateUI()
    }
    
    private func setupGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard gesture.state == .ended else { return }

        let translation = gesture.translation(in: view)
        let direction: Direction?

        // Определяем направление свайпа
        if abs(translation.x) > abs(translation.y) {
            direction = translation.x > 0 ? .right : .left
        } else {
            direction = translation.y > 0 ? .down : .up
        }

        if let direction = direction {
            let moved = game.move(direction)
            if moved {
                updateUI()
            }
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        let gridSize: CGFloat = 300
        let tileSize = gridSize / CGFloat(size)
        let grid = UIView(frame: CGRect(x: 50, y: 100, width: gridSize, height: gridSize))
        grid.backgroundColor = .gray
        view.addSubview(grid)
        
        for row in 0..<size {
            var rowViews: [UILabel] = []
            for col in 0..<size {
                let tile = UILabel(frame: CGRect(x: CGFloat(col) * tileSize, y: CGFloat(row) * tileSize, width: tileSize, height: tileSize))
                tile.backgroundColor = .lightGray
                tile.textAlignment = .center
                tile.font = UIFont.boldSystemFont(ofSize: 24)
                tile.text = "0"
                grid.addSubview(tile)
                rowViews.append(tile)
            }
            boardViews.append(rowViews)
        }
        
        let resetButton = UIButton(frame: CGRect(x: 50, y: 420, width: 100, height: 40))
        resetButton.setTitle("RESET", for: .normal)
        resetButton.backgroundColor = .blue
        resetButton.addTarget(self, action: #selector(resetGame), for: .touchUpInside)
        view.addSubview(resetButton)
        
        let undoButton = UIButton(frame: CGRect(x: 200, y: 420, width: 100, height: 40))
        undoButton.setTitle("UNDO", for: .normal)
        undoButton.backgroundColor = .red
        undoButton.addTarget(self, action: #selector(undoMove), for: .touchUpInside)
        view.addSubview(undoButton)
    }
    
    @objc private func resetGame() {
        game.reset()
        updateUI()
    }
    
    @objc private func undoMove() {
        game.undo()
        updateUI()
    }
    
    private func updateUI() {
        for row in 0..<size {
            for col in 0..<size {
                let value = game.board[row][col]
                boardViews[row][col].text = value == 0 ? "" : "\(value)"
                boardViews[row][col].backgroundColor = value == 0 ? .lightGray : .orange
            }
        }
    }
}
