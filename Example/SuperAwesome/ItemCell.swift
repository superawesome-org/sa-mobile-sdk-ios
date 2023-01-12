//
//  ItemCell.swift
//  SuperAwesomeExample
//
//  Created by Tom O'Rourke on 12/01/2023.
//

import UIKit

class ItemCell: UITableViewCell {

    var placementItem: PlacementItem? {
        didSet {
            guard let item = placementItem else { return }
            nameLabel.text = item.fullName
        }
    }

    private let stack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 8.0
        view.alignment = .fill
        view.distribution = .fill
        return view
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.addSubview(stack)
        stack.addArrangedSubview(nameLabel)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: self.contentView.safeLeadingAnchor, constant: 16.0),
            stack.trailingAnchor.constraint(equalTo: self.contentView.safeTrailingAnchor, constant: -16.0),
            stack.topAnchor.constraint(equalTo: self.contentView.safeTopAnchor, constant: 8.0),
            stack.bottomAnchor.constraint(equalTo: self.contentView.safeBottomAnchor, constant: -8.0)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
