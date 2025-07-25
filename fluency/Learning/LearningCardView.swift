import SnapKit
import SwiftUI
import UIKit

final class LearningCardView: UIView {
    // MARK: - Types

    enum CardType {
        case inProgress
        case completed
    }

    struct ViewState {
        let titleText: String
        let channelName: String
        let lastLearnedTime: String
        let progress: Float?
    }

    // MARK: - Properties

    private let cardType: CardType

    var viewState: ViewState? {
        didSet {
            guard let viewState else { return }
            render(viewState)
        }
    }

    // Common components
    private let contentStackView = UIStackView()
    private let headerView = UIView()
    private let titleStackView = UIStackView()
    private let titleLabel = UILabel()
    private let channelLabel = UILabel()
    private let lastLearnedLabel = UILabel()

    // Type-specific components
    private var playButton: UIButton?
    private var doneLabel: UILabel?
    private var bottomView: UIView?
    private var timeRemainingLabel: UILabel?
    private var progressView: UIProgressView?

    // MARK: - Initialization

    private init(cardType: CardType) {
        self.cardType = cardType
        super.init(frame: .zero)
        setupViews()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Factory Methods

    static func inProgressCard() -> LearningCardView {
        LearningCardView(cardType: .inProgress)
    }

    static func completedCard() -> LearningCardView {
        LearningCardView(cardType: .completed)
    }

    // MARK: - Private Methods

    private func render(_ viewState: ViewState) {
        titleLabel.text = viewState.titleText
        channelLabel.text = viewState.channelName
        lastLearnedLabel.text = "Last learned: \(viewState.lastLearnedTime)"

        switch cardType {
        case .inProgress:
            if let progress = viewState.progress {
                progressView?.progress = progress
            }
            timeRemainingLabel?.text = viewState.lastLearnedTime
        case .completed:
            break
        }
    }

    // MARK: Setup

    private func setupViews() {
        setupBaseView()
        setupCommonViews()

        // Only create components we need
        switch cardType {
        case .inProgress:
            setupInProgressComponents()
        case .completed:
            setupCompletedComponents()
        }
    }

    private func setupBaseView() {
        // Different styling based on card type
        switch cardType {
        case .inProgress:
            backgroundColor = .black
            layer.cornerRadius = 16
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowOpacity = 0.3
            layer.shadowRadius = 8

        case .completed:
            backgroundColor = .white
            layer.cornerRadius = 16
            layer.borderWidth = 1
            layer.borderColor = UIColor.systemGray5.cgColor
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 1)
            layer.shadowOpacity = 0.05
            layer.shadowRadius = 4
        }

        layer.masksToBounds = false
    }

    private func setupCommonViews() {
        contentStackView.axis = .vertical
        contentStackView.spacing = 12
        contentStackView.alignment = .fill
        contentStackView.distribution = .fill

        titleStackView.axis = .vertical
        titleStackView.spacing = 4
        titleStackView.alignment = .leading
        titleStackView.distribution = .fill

        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)

        channelLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        channelLabel.numberOfLines = 1
        channelLabel.lineBreakMode = .byTruncatingTail
        channelLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)

        lastLearnedLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lastLearnedLabel.numberOfLines = 1
        lastLearnedLabel.lineBreakMode = .byTruncatingTail
        lastLearnedLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)

        // Set colors based on card type
        switch cardType {
        case .inProgress:
            titleLabel.textColor = .white
            channelLabel.textColor = UIColor.white.withAlphaComponent(0.7)
            lastLearnedLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        case .completed:
            titleLabel.textColor = UIColor.systemGray3
            channelLabel.textColor = UIColor.systemGray4
            lastLearnedLabel.textColor = UIColor.systemGray4
        }

        // Add common components to hierarchy
        [titleLabel, channelLabel, lastLearnedLabel].forEach { titleStackView.addArrangedSubview($0) }
        headerView.addSubview(titleStackView)
        contentStackView.addArrangedSubview(headerView)
    }

    private func setupInProgressComponents() {
        // Create bottom view for progress components
        let bottom = UIView()
        bottomView = bottom
        contentStackView.addArrangedSubview(bottom)

        // Create play button (white circle with black play icon)
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 4
        let playImage = UIImage(systemName: "play.fill")
        button.setImage(playImage, for: .normal)
        button.tintColor = .black
        button.imageView?.contentMode = .scaleAspectFit
        playButton = button
        headerView.addSubview(button)

        // Create progress view with gradient colors
        let progress = UIProgressView()
        progress.progressTintColor = UIColor.systemOrange
        progress.trackTintColor = UIColor.white.withAlphaComponent(0.2)
        progress.layer.cornerRadius = 2
        progress.clipsToBounds = true
        progressView = progress
        bottom.addSubview(progress)

        // Time remaining label (white text for dark background)
        let timeLabel = UILabel()
        timeLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        timeLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        timeLabel.textAlignment = .right
        timeRemainingLabel = timeLabel
        bottom.addSubview(timeLabel)
    }

    private func setupCompletedComponents() {
        // Create done label with green background and checkmark
        let label = UILabel()
        label.text = "✓ Done"
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = UIColor.systemGreen
        label.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.1)
        label.textAlignment = .center
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        doneLabel = label
        headerView.addSubview(label)
    }

    private func setupLayout() {
        addSubview(contentStackView)

        // Common constraints
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }

        titleStackView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }

        // Type-specific constraints
        switch cardType {
        case .inProgress:
            setupInProgressLayout()
        case .completed:
            setupCompletedLayout()
        }
    }

    private func setupInProgressLayout() {
        guard let playButton,
              let bottomView,
              let progressView,
              let timeRemainingLabel else { return }

        // Header
        titleStackView.snp.makeConstraints { make in
            make.trailing.equalTo(playButton.snp.leading).offset(-16)
        }

        playButton.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }

        // Bottom view
        progressView.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview()
            make.trailing.equalTo(timeRemainingLabel.snp.leading).offset(-12)
            make.centerY.equalToSuperview()
            make.height.equalTo(4)
        }

        timeRemainingLabel.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.greaterThanOrEqualTo(80)
        }
    }

    private func setupCompletedLayout() {
        guard let doneLabel else { return }

        titleStackView.snp.makeConstraints { make in
            make.trailing.equalTo(doneLabel.snp.leading).offset(-16)
        }

        doneLabel.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(24)
        }
    }
}

#if DEBUG
    @available(iOS 13.0, *)
    struct LearningCardView_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                // In-Progress Card Preview
                UIViewPreview {
                    let cardView = LearningCardView.inProgressCard()
                    cardView.viewState = LearningCardView.ViewState(
                        titleText: "React Hooks Deep Dive - Advanced Patterns and Best Practices",
                        channelName: "Frontend Development Academy",
                        lastLearnedTime: "2 hours ago",
                        progress: 0.7
                    )
                    return cardView
                }
                .previewLayout(.fixed(width: 350, height: 140))
                .previewDisplayName("In Progress Card")

                // Completed Card Preview
                UIViewPreview {
                    let cardView = LearningCardView.completedCard()
                    cardView.viewState = LearningCardView.ViewState(
                        titleText: "JavaScript Performance Optimization Techniques",
                        channelName: "Very Long Channel Name That Will Also Truncate",
                        lastLearnedTime: "3 days ago",
                        progress: nil
                    )
                    return cardView
                }
                .previewLayout(.fixed(width: 350, height: 100))
                .previewDisplayName("Completed Card")
            }
        }
    }

    // Helper struct to wrap UIView in SwiftUI
    @available(iOS 13.0, *)
    struct UIViewPreview<View: UIView>: UIViewRepresentable {
        let view: View

        init(_ builder: @escaping () -> View) {
            view = builder()
        }

        // MARK: - UIViewRepresentable

        func makeUIView(context _: Context) -> some UIView {
            view
        }

        func updateUIView(_ view: UIViewType, context _: Context) {
            view.setContentHuggingPriority(.defaultHigh, for: .vertical)
            view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        }
    }
#endif
