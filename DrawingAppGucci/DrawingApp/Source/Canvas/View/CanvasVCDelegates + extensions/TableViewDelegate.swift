//
//  TableViewDelegate.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/08/16.
//

import UIKit

extension CanvasViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shape = plane[indexPath.row]
        beforeSelectedView = shapeFrameViews[indexPath.row]
        
        //MARK: - 상태창에 알림
        if let rectangle = shape as? Rectangle {
            self.informSelectedViewToStatus(color: rectangle.color, alpha: shape.alpha, type: .rectangle)
        } else {
            self.informSelectedViewToStatus(color: Color(r: 0, g: 0, b: 0), alpha: shape.alpha, type: .photo)
        }
        tableView.cellForRow(at: indexPath)?.isSelected = false
        return
    }
    
    //TODO: - 20줄 이내 줄이기
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [unowned self] suggestedActions in
            let backMostAction =
            UIAction(title: NSLocalizedString("맨 뒤로 보내기", comment: ""),
                     image: UIImage(systemName: "arrow.up.to.line")) { [unowned self] action in
                self.plane.moveFormost(with: indexPath.row)
                var index = indexPath.row
                while index > 0 {
                    self.moveViewForward(with: index)
                    index -= 1
                }
                tableView.reloadData()
            }
            let backwardAction =
            UIAction(title: NSLocalizedString("뒤로 보내기", comment: ""),
                     image: UIImage(systemName: "arrow.up.square")) { [unowned self] action in
                self.plane.moveforward(with: indexPath.row)
                self.moveViewForward(with: indexPath.row)
                tableView.reloadData()
            }
            let forwardAction =
            UIAction(title: NSLocalizedString("앞으로 보내기", comment: ""),
                     image: UIImage(systemName: "arrow.down.square")) { [unowned self] action in
                self.plane.moveBackward(with: indexPath.row)
                self.moveViewBackward(with: indexPath.row)
                tableView.reloadData()
            }
            let foreMostAction =
            UIAction(title: NSLocalizedString("맨 앞으로 보내기", comment: ""),
                     image: UIImage(systemName: "arrow.down.to.line")) { [unowned self] action in
                self.plane.moveBackmost(with: indexPath.row)
                var index = indexPath.row
                while index < shapeFrameViews.count - 1 {
                    moveViewBackward(with: index)
                    index += 1
                }
                tableView.reloadData()
            }
            
            return UIMenu(title: "", children: [backMostAction, backwardAction, forwardAction, foreMostAction])
        }
    }
}
