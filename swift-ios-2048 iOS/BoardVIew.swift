import UIKit

class BoardView: UIView {
    private var board: [[Int]] = []

    func update(with board: [[Int]]) {
        self.board = board
        setNeedsDisplay() // Перерисовка
    }

    override func draw(_ rect: CGRect) {
        guard !board.isEmpty else { return }

        let tileSize = rect.width / CGFloat(board.count)
        let context = UIGraphicsGetCurrentContext()

        for (rowIndex, row) in board.enumerated() {
            for (colIndex, value) in row.enumerated() {
                let x = CGFloat(colIndex) * tileSize
                let y = CGFloat(rowIndex) * tileSize
                let rect = CGRect(x: x, y: y, width: tileSize, height: tileSize)

                // Цвет плитки: серый для пустой и оранжевый для плиток с числами
                context?.setFillColor((value == 0 ? UIColor.lightGray : UIColor.orange).cgColor)
                context?.fill(rect)

                // Рисуем число
                if value > 0 {
                    let attributes: [NSAttributedString.Key: Any] = [
                        .font: UIFont.boldSystemFont(ofSize: 24),
                        .foregroundColor: UIColor.white
                    ]
                    let text = "\(value)"
                    let textSize = text.size(withAttributes: attributes)
                    let textRect = CGRect(
                        x: rect.midX - textSize.width / 2,
                        y: rect.midY - textSize.height / 2,
                        width: textSize.width,
                        height: textSize.height
                    )
                    text.draw(in: textRect, withAttributes: attributes)
                }
            }
        }
    }
    
    func getTileColor(for value: Int) -> UIColor {
        switch value {
        case 2:
            return UIColor(red: 0.93, green: 0.89, blue: 0.76, alpha: 1.0) // светлый желтый
        case 4:
            return UIColor(red: 0.93, green: 0.88, blue: 0.48, alpha: 1.0) // желтый
        case 8:
            return UIColor(red: 0.93, green: 0.53, blue: 0.22, alpha: 1.0) // оранжевый
        case 16:
            return UIColor(red: 0.93, green: 0.38, blue: 0.14, alpha: 1.0) // красный
        case 32:
            return UIColor(red: 0.88, green: 0.30, blue: 0.07, alpha: 1.0) // ярко-красный
        case 64:
            return UIColor(red: 0.88, green: 0.18, blue: 0.04, alpha: 1.0) // темно-красный
        case 128:
            return UIColor(red: 0.83, green: 0.73, blue: 0.39, alpha: 1.0) // светлый золотой
        case 256:
            return UIColor(red: 0.83, green: 0.60, blue: 0.23, alpha: 1.0) // золотой
        case 512:
            return UIColor(red: 0.76, green: 0.44, blue: 0.13, alpha: 1.0) // темно-золотой
        case 1024:
            return UIColor(red: 0.70, green: 0.31, blue: 0.04, alpha: 1.0) // светлый коричневый
        case 2048:
            return UIColor(red: 0.65, green: 0.24, blue: 0.03, alpha: 1.0) // темный коричневый
        default:
            return UIColor.lightGray // для плиток, которые пусты или с нулевым значением
        }
    }

}
