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
        
        title.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        shapeImageView.snp.makeConstraints {

            $0.leading.equalToSuperview().offset(30)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(title)
            $0.width.equalTo(shapeImageView.snp.height)
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
