//
//  ProfileImageView.swift
//  Chat
//
//  Created by Maria Myamlina on 25.09.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

@IBDesignable
class ProfileImageView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    
    private var touchPath: UIBezierPath {return UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius)}
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        let bundle = Bundle(for: ProfileImageView.self)
        bundle.loadNibNamed("ProfileImageView", owner: self, options: nil)
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
        
        profileImage.layer.cornerRadius = profileImage.bounds.size.width / 2
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return touchPath.contains(point)
    }

}
