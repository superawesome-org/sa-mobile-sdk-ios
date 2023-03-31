//
//  SettingsView.swift
//  SuperAwesomeExample
//
//  Created by Myles Eynon on 30/03/2023.
//

import PureLayout
import UIKit


protocol SettingsViewDelegate: AnyObject {
    func didUpdateSettings(settings: SettingsModel)
}

class SettingsView: ConstraintView {

    private let inset: CGFloat = 16.0
    private let titleFontSize: CGFloat = 20.0
    private let animationDuration: TimeInterval = 0.3
    private let titleLabelHeight: CGFloat = 26.0
    private let settingSpacing: CGFloat = 4.0
    private let closeButtonSize = CGSize(width: 30.0, height: 30.0)

    private var settingsModel = SettingsModel()

    weak var delegate: SettingsViewDelegate?

    private lazy var backingView: TappableView = {
        let view = TappableView(frame: .zero)
        view.accessibilityIdentifier = "Settings.Views.Backing"
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.85)
        view.onTap = { [weak self] in
            self?.hide()
        }
        return view
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.accessibilityIdentifier = "Settings.Views.ScrollView"
        scrollView.backgroundColor = .white
        return scrollView
    }()

    private lazy var containerView: UIView = {
        let view = UIView(frame: .zero)
        view.accessibilityIdentifier = "Settings.Views.Container"
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = NSLocalizedString("Settings.Labels.Title", comment: "Settings")
        label.accessibilityIdentifier = "Settings.Labels.Title"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: titleFontSize)
        return label
    }()

    private lazy var resetButton: TappableButton = {
        let button = TappableButton()
        button.accessibilityIdentifier = "Settings.Buttons.Reset"
        button.setImage(UIImage(named: "ico_refresh"), for: .normal)
        button.tintColor = .darkGray
        button.onTap = { [weak self] in
            let settings = SettingsModel()
            self?.settingsModel = settings
            self?.updateSettingsItems()
            self?.delegate?.didUpdateSettings(settings: settings)
        }
        return button
    }()

    private lazy var closeButton: TappableButton = {
        let button = TappableButton()
        button.accessibilityIdentifier = "Settings.Buttons.Close"
        button.setImage(UIImage(named: "ico_close"), for: .normal)
        button.tintColor = .darkGray
        button.onTap = { [weak self] in
            self?.hide()
        }
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.accessibilityIdentifier = "Settings.Views.StackView"
        return stackView
    }()

    private func createSettingItem(setting: Settings) -> SettingsItemView {
        let view = SettingsItemView(setting: setting, value: settingsModel.getValue(forSetting: setting))
        view.delegate = self
        return view
    }

    private func updateSettingsItems() {
        stackView.subviews.forEach { $0.removeFromSuperview() }
        Settings.all.forEach { stackView.addArrangedSubview(createSettingItem(setting: $0)) }
    }

    override func addSubViews() {
        super.addSubViews()

        updateSettingsItems()

        containerView.addSubview(titleLabel)
        containerView.addSubview(resetButton)
        containerView.addSubview(closeButton)
        containerView.addSubview(stackView)

        scrollView.addSubview(containerView)
        backingView.addSubview(scrollView)

        addSubview(backingView)
    }

    override func addConstraints() {
        super.addConstraints()
        let insets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)

        backingView.autoPinEdgesToSuperviewEdges()

        scrollView.autoCenterInSuperview()
        scrollView.autoMatch(.width, to: .width, of: self, withMultiplier: 0.95)
        scrollView.autoMatch(.height, to: .height, of: self, withMultiplier: 0.8)

        containerView.autoPinEdge(.top, to: .top, of: scrollView)
        containerView.autoPinEdge(.leading, to: .leading, of: scrollView)
        containerView.autoMatch(.width, to: .width, of: scrollView)

        titleLabel.autoPinEdgesToSuperviewEdges(with: insets, excludingEdge: .bottom)
        titleLabel.autoSetDimension(.height, toSize: titleLabelHeight)

        resetButton.autoAlignAxis(.horizontal, toSameAxisOf: titleLabel)
        resetButton.autoSetDimensions(to: closeButtonSize)

        closeButton.autoPinEdge(.leading, to: .trailing, of: resetButton, withOffset: inset)
        closeButton.autoAlignAxis(.horizontal, toSameAxisOf: titleLabel)
        closeButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: inset)
        closeButton.autoSetDimensions(to: closeButtonSize)

        stackView.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: inset)
        stackView.autoPinEdgesToSuperviewEdges(with: insets, excludingEdge: .top)
    }

    func show() {
        UIView.animate(withDuration: animationDuration, delay: 0.0) { [weak self] in
            self?.alpha = 1.0
        }
    }

    func hide() {
        UIView.animate(withDuration: animationDuration, delay: 0.0) { [weak self] in
            self?.alpha = 0.0
        }
    }
}

// MARK: SettingsItemViewDelegate

extension SettingsView: SettingsItemViewDelegate {
    func didUpdateSettingItem(setting: Settings, option: SettingsItemOption) {
        settingsModel.setValue(forSetting: setting, value: option.value)
        delegate?.didUpdateSettings(settings: settingsModel)
    }
}
