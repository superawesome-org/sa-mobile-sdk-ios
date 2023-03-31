//
//  SettingsItem.swift
//  SuperAwesomeExample
//
//  Created by Myles Eynon on 30/03/2023.
//

import PureLayout
import UIKit

protocol SettingsItemViewDelegate: AnyObject {
    func didUpdateSettingItem(setting: Settings, option: SettingsItemOption)
}

class SettingsItemView: ConstraintView {
    private let insets: CGFloat = 16.0
    private let textSize: CGFloat = 16.0
    private let buttonInset: CGFloat = 1.0
    private let buttonSize = CGSize(width: 80.0, height: 30.0)

    private var setting: Settings!
    private var value: Any!

    weak var delegate: SettingsItemViewDelegate?

    private lazy var stackView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .fill
        view.axis = .horizontal
        view.distribution = .fill
        view.accessibilityIdentifier = "SettingsItem.\(setting.identifier).Views.StackView"
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = setting.name
        label.accessibilityIdentifier = "SettingsItem.\(setting.identifier).Labels.Title"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: textSize)
        return label
    }()

    private func createButton(option: SettingsItemOption) -> UIView {
        let container = UIView(frame: .zero)
        container.translatesAutoresizingMaskIntoConstraints = false

        let button = TappableButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "SettingsItem.\(setting.identifier).Button.\(option.identifier)"
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: textSize)
        button.setTitle(option.name, for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.setBackgroundColor(color: .lightGray, forState: .selected)
        if let uValue = value {
            button.isSelected = areEqual(first: option.value, second: uValue)
        }
        button.onTap = { [weak self] in
            guard !button.isSelected else { return }
            guard let strongSelf = self else { return }
            strongSelf.updateSelection()
            button.isSelected = true
            strongSelf.delegate?.didUpdateSettingItem(setting: strongSelf.setting, option: option)
        }
        container.addSubview(button)
        button.autoSetDimensions(to: buttonSize)
        NSLayoutConstraint.autoSetPriority(.defaultLow) {
            button.autoPinEdgesToSuperviewEdges(
                with: UIEdgeInsets(top: buttonInset, left: buttonInset, bottom: buttonInset, right: buttonInset)
            )
        }
        return container
    }

    init(setting: Settings, value: Any) {
        self.setting = setting
        self.value = value
        super.init(frame: .zero)
        accessibilityIdentifier = "SettingsItem.\(setting.identifier)"
    }

    required init?(coder aDecoder: NSCoder) {
        self.setting = .bumper
        super.init(coder: aDecoder)
    }

    override func addSubViews() {
        super.addSubViews()
        stackView.addArrangedSubview(titleLabel)

        for option in setting.options {
            stackView.addArrangedSubview(createButton(option: option))
        }

        addSubview(stackView)
    }

    override func addConstraints() {
        super.addConstraints()
        NSLayoutConstraint.autoSetPriority(.defaultLow) {
            titleLabel.autoMatch(.width, to: .width, of: stackView)
        }
        stackView.autoPinEdgesToSuperviewEdges()
    }

    private func updateSelection() {
        for view in stackView.arrangedSubviews {
            for subView in view.subviews {
                if let button = subView as? UIButton {
                    button.isSelected = false
                }
            }
        }
    }
}
