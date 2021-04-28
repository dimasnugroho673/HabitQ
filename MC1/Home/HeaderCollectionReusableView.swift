//
//  HeaderCollectionReusableView.swift
//  MC1
//
//  Created by Maitri Vira on 28/04/21.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "HeaderCollectionReusableView"
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "header"
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    private let detail: UILabel = {
        let label = UILabel()
        label.text = "detail"
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    public func configure(){
        backgroundColor = .systemTeal
        addSubview(label)
        addSubview(detail)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 16, y: -40, width: frame.size.width, height: frame.size.height)
        detail.frame = CGRect(x: 16, y: 20, width: frame.size.width, height: frame.size.height)
    }
}
