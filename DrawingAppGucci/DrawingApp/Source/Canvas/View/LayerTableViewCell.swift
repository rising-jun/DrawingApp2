//
//  LayerTableViewCell.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/08/11.
//

import UIKit
import SnapKit

final class LayerTableViewCell: UITableViewCell {
    
    let title: UILabel = UILabel()
    let shapeImageView = UIImageView()
    var shapeIndex: Int = Int.max

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        title.textColor = .label
        
        [shapeImageView, title].forEach {
            contentView.addSubview($0)
        }
        
        shapeImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(20)
            $0.height.equalTo(shapeImageView.snp.width)
        }
        
        title.snp.makeConstraints {
            $0.leading.equalTo(shapeImageView.snp.trailing).offset(5)
            $0.centerY.equalToSuperview()
        }
    }
    
    func setUp(with blueprint: ShapeBlueprint, at index: Int, printNumber number: Int) {
        shapeIndex = index
        title.text = "\(blueprint.rawValue) \(number)"
        switch blueprint {
        case .rectangle:
            shapeImageView.image = UIImage(systemName: "rectangle")
        case .photo:
            shapeImageView.image = UIImage(systemName: "photo")
        case .text:
            shapeImageView.image = UIImage(systemName: "t.square")
        }
    }
}
