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
        label.text = "Hello, Simbo!"
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        return label
    }()
    
    private let detail: UILabel = {
        let label = UILabel()
        label.text = "Life is like riding a bicycle. To keep your balance, you must keep moving. - Albert Einstein"
        label.numberOfLines = 3
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    public func configure(){
        backgroundColor = .systemTeal
        layer.cornerRadius = 10
        addSubview(label)
        addSubview(detail)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 16, y: -40, width: frame.size.width, height: frame.size.height)
        detail.frame = CGRect(x: 16, y: 20, width: frame.size.width, height: frame.size.height)
    }
}
