//
//  CustomPageControl.swift
//  FakeNFT
//

import UIKit

final class CustomPageControl: UIView {
    // MARK: - Properties
    var numberOfPages: Int = 0 {
        didSet {
            setupViews()
        }
    }

    var currentPage: Int = 0 {
        didSet {
            updateProgress()
        }
    }

    private var progressViews: [UIProgressView] = []
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()

        let progressViewWidth = (bounds.width - CGFloat(numberOfPages - 1) * 8) / CGFloat(numberOfPages)
        let progressViewHeight = bounds.height

        for (index, progressView) in progressViews.enumerated() {
            let progressViewX = CGFloat(index) * (progressViewWidth + 8)
            progressView.frame = CGRect(x: progressViewX,
                                        y: 0,
                                        width: progressViewWidth,
                                        height: progressViewHeight)
        }
    }
    // MARK: - Private functions
    private func setupViews() {
        progressViews = []
        for _ in 0..<numberOfPages {
            let progressView = UIProgressView(progressViewStyle: .bar)
            progressView.progress = 0
            progressView.progressTintColor = .black
            progressView.trackTintColor = .white
            addSubview(progressView)
            progressViews.append(progressView)
        }

        if numberOfPages > 0 {
            currentPage = 0
        }
    }

    private func updateProgress() {
        for (index, progressView) in progressViews.enumerated() {
            progressView.progress = 0
            progressView.progressTintColor = index == currentPage ? .white : .black
            progressView.trackTintColor = index != currentPage ? .white : .black
        }

        if currentPage < progressViews.count {
            let currentProgress = self.progressViews[self.currentPage].progress
            self.progressViews[self.currentPage].setProgress(currentProgress, animated: true)
        }
    }
}
