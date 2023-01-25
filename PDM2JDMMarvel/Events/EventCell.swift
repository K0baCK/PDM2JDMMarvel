//
//  EventCell.swift
//  PDM2-Project
//
//  Created by JJM on 15/11/2022.
//

import UIKit

class EventCell: UITableViewCell {
    
    var eventImageView = UIImageView()
    var eventTitleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(eventImageView)
        addSubview(eventTitleLabel)
        
        configureImageView()
        configureTitleLabel()
        setImageConstraints()
        setTitleLableConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(event: Result) {
        let stringToImage = (event.thumbnail.path ?? "")+"."+(event.thumbnail.thumbnailExtension ?? "")
        let httpsStringToImage = stringToImage.replacingOccurrences(of: "http", with: "https")
        setImage(urlString: httpsStringToImage)
        eventTitleLabel.text = event.title
    }
    
    func configureImageView() {
        eventImageView.layer.cornerRadius = 10
        eventImageView.clipsToBounds      = true
    }
    
    func configureTitleLabel() {
        eventTitleLabel.numberOfLines             = 0
        eventTitleLabel.adjustsFontSizeToFitWidth = true
    }
    
    func setImageConstraints() {
        eventImageView.translatesAutoresizingMaskIntoConstraints                                               = false
        eventImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive                               = true
        eventImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive                 = true
        eventImageView.heightAnchor.constraint(equalToConstant: 80).isActive                                   = true
        eventImageView.widthAnchor.constraint(equalTo: eventImageView.heightAnchor, multiplier: 16/9).isActive = true
    }
    
    func setTitleLableConstraints() {
        eventTitleLabel.translatesAutoresizingMaskIntoConstraints                                               = false
        eventTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive                               = true
        eventTitleLabel.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: 20).isActive = true
        eventTitleLabel.heightAnchor.constraint(equalToConstant: 80).isActive                                   = true
        eventTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive              = true
    }
    
    func setImage(urlString: String) {
        if let url = URL.init(string: urlString){
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    self.eventImageView.image = UIImage(data: data!)
                    super.layoutSubviews()
                }
            }
        }
    }
    
}

extension String {
    
}
