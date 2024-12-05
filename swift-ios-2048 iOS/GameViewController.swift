import UIKit
import AVFoundation

class GameViewController: UIViewController {
    private var gameModel: GameModel!
    private var boardView: BoardView!
    private var scoreLabel: UILabel!
    private var resetButton: UIButton!
    private var undoButton: UIButton!
    private var tileSoundPlayer: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGame()

        // Добавляем жест для обработки мыши
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panGesture)
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .ended {
            let velocity = gesture.velocity(in: view)
            let absX = abs(velocity.x)
            let absY = abs(velocity.y)

            let direction: Direction
            if absX > absY {
                direction = velocity.x > 0 ? .right : .left
            } else {
                direction = velocity.y > 0 ? .down : .up
            }

            if gameModel.move(direction) {
                playSound(for: "Merge")
                updateUI()
            } else {
                playSound(for: "Add")
            }

            if gameModel.isGameOver {
                showAlert(message: "Game Over!")
            }
        }
    }

    private func setupGame() {
        gameModel = GameModel()
        updateUI()
    }

    private func setupUI() {
        view.backgroundColor = .white

        // Настройка метки для очков
        scoreLabel = UILabel()
        scoreLabel.textAlignment = .center
        scoreLabel.text = "Score: 0"
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 24)
        scoreLabel.frame = CGRect(x: 0, y: 40, width: view.bounds.width, height: 50)
        view.addSubview(scoreLabel)

        // Настройка игрового поля
        let boardSize = view.bounds.width - 40
        boardView = BoardView(frame: CGRect(x: 20, y: 100, width: boardSize, height: boardSize))
        boardView.backgroundColor = .gray
        view.addSubview(boardView)

        // Настройка кнопки Reset
        resetButton = UIButton(type: .system)
        resetButton.setTitle("Reset", for: .normal)
        resetButton.frame = CGRect(x: 20, y: view.bounds.height - 100, width: 100, height: 50)
        resetButton.addTarget(self, action: #selector(resetGame), for: .touchUpInside)
        view.addSubview(resetButton)

        // Настройка кнопки Undo
        undoButton = UIButton(type: .system)
        undoButton.setTitle("Undo", for: .normal)
        undoButton.frame = CGRect(x: view.bounds.width - 120, y: view.bounds.height - 100, width: 100, height: 50)
        undoButton.addTarget(self, action: #selector(undoMove), for: .touchUpInside)
        view.addSubview(undoButton)
    }


    private func playSound(for action: String) {
        guard let soundURL = Bundle.main.url(forResource: action, withExtension: "mp3") else {
            print("Файл \(action).mp3 не найден в бандле.")
            return
        }

        do {
            tileSoundPlayer = try AVAudioPlayer(contentsOf: soundURL)
            tileSoundPlayer?.play()
        } catch {
            print("Ошибка воспроизведения звука: \(error)")
        }
    }

    @objc private func resetGame() {
        gameModel.reset()
        updateUI()
    }

    @objc private func undoMove() {
        gameModel.undo()
        updateUI()
    }

    private func updateUI() {
        scoreLabel.text = "Score: \(gameModel.score)"
        boardView.update(with: gameModel.board)
    }


    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        let direction: Direction
        switch gesture.direction {
        case .up: direction = .up
        case .down: direction = .down
        case .left: direction = .left
        case .right: direction = .right
        default: return
        }

        if gameModel.move(direction) {
            playSound(for: "Merge")
            updateUI()
        } else {
            playSound(for: "Add")
        }

        if gameModel.isGameOver {
            showAlert(message: "Game Over!")
        }
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

}
