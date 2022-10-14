//
//  GalaxyTableViewCell.swift
//  GalaxyExplorer
//
//  Created by A118830248 on 14/10/22.
//

import UIKit
import CoreGraphics
import ImageIO

class GalaxyTableViewCell: UITableViewCell {
    @IBOutlet weak var galaxyImage: CustomImageView!
    @IBOutlet weak var titleLabel: UILabel!

    var reloadCallBack: (()-> Void)?
    
    var details: Planetary? {
        didSet {
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        galaxyImage.image = nil
        titleLabel.text = ""
    }

    func updateUI() {
        guard let urlString = details?.hdurl, let url = URL(string: urlString) else { return }
        
        galaxyImage.loadImageWithUrl(url, completion: { [weak self] image in
            self?.reloadCallBack?()
            
        })
        titleLabel.text = details?.title ?? ""
    }
}
