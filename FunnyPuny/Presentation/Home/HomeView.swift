// HomeView.swift
// Created by Zlata Guseva on 12.10.2022.

import SwiftyGif
import UIKit

class HomeView: UIView {
    private var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to FunnyPuny!"
        label.textColor = .primaryText
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()

    private var gifImageView: UIImageView = {
        do {
            let gif = try UIImage(gifName: "test.gif")
            let imageView = UIImageView(gifImage: gif)
            return imageView
        } catch {
            print(error)
        }
        return UIImageView()
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        addSubviews()
        makeConstraints()
    }

    private func addSubviews() {
        addSubview(gifImageView)
        addSubview(mainLabel)
    }

    private func makeConstraints() {
        gifImageView.snp.makeConstraints { make in
            make.width.height.equalTo(300)
            make.center.equalTo(self)
        }

        mainLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(256)
        }
    }
}