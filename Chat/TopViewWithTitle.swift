//
//  TopViewWithTitle.swift
//  Chat
//
//  Created by Maria Myamlina on 28.09.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class TopViewWithTitle: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        let bundle = Bundle(for: TopViewWithTitle.self)
        bundle.loadNibNamed("TopViewWithTitle", owner: self, options: nil)
        
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        profileImage.contentMode = .scaleAspectFill
        
        let currentTheme = Theme.current.themeOptions
        nameLabel.textColor = currentTheme.inputAndCommonTextColor
    }
}
