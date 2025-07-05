import DataModel
import SwiftUI
import Lego

public struct MediaDetailInformationView: View {
    private let detail: any MediaDetail

    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet

    public init(detail: any MediaDetail) {
        self.detail = detail
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: styleSheet.spacing.spacing200) {
            if hasInformationSection {
                informationSection
            }

            if hasLanguagesSection {
                languagesSection
            }

            if hasAccessibilitySection {
                accessibilitySection
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Sections

    private var informationSection: some View {
        VStack(alignment: .leading, spacing: styleSheet.spacing.spacing200) {
            LegoText("Information", style: styleSheet.text(.title))

            infoRow(title: "Released", value: detail.releaseDateText)

            if let runtime = detail.runtimeInMinutes {
                infoRow(title: "Run Time", value: formatRuntime(runtime))
            }

            if !detail.originCountry.isEmpty {
                infoRow(
                    title: "Region of Origin",
                    value: detail.originCountry.joined(separator: ", ")
                )
            }
        }.padding(.vertical, styleSheet.spacing.spacing100)
    }

    private var languagesSection: some View {
        let spokenLanguages = detail.spokenLanguages
        let audioLanguages = spokenLanguages.map(\.name).filter { !$0.isEmpty }
        let audioLanguagesText = audioLanguages.joined(separator: ", ")
        let subtitles = audioLanguagesText.isEmpty ? nil : audioLanguagesText + " (SDH)"
        let originalAudio = spokenLanguages.first?.englishName.nonEmpty

        return VStack(alignment: .leading, spacing: styleSheet.spacing.spacing200) {
            LegoText("Languages", style: styleSheet.text(.title))

            if let original = originalAudio {
                infoRow(title: "Original Audio", value: original)
            }

            if !audioLanguagesText.isEmpty {
                infoRow(title: "Audio", value: audioLanguagesText)
            }

            if let subtitles = subtitles {
                infoRow(title: "Subtitles", value: subtitles)
            }
        }
    }

    private var accessibilitySection: some View {
        VStack(alignment: .leading, spacing: styleSheet.spacing.spacing100) {
            LegoText("Accessibility", style: styleSheet.text(.title))

            LegoText("SDH", style: styleSheet.text(.callout)) {
                $0.bold().padding(.vertical, styleSheet.spacing.spacing50)
            }

            LegoText(
                "Subtitles for the deaf and hard of hearing (SDH) refer to subtitles in the original language with the addition of relevant non-dialogue information.",
                style: styleSheet.text(.caption)
            )
        }
    }

    // MARK: - Visibility Conditions

    private var hasInformationSection: Bool {
        !detail.releaseDateText.isEmpty ||
        detail.runtimeInMinutes != nil ||
        !detail.originCountry.isEmpty
    }

    private var hasLanguagesSection: Bool {
        let hasOriginal = detail.spokenLanguages.first?.englishName.isEmpty == false
        let hasAudio = detail.spokenLanguages.contains { !$0.name.isEmpty }
        return hasOriginal || hasAudio
    }

    private var hasAccessibilitySection: Bool {
        !detail.spokenLanguages.isEmpty
    }

    // MARK: - Helpers

    @ViewBuilder
    private func infoRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: styleSheet.spacing.spacing50) {
            LegoText(title, style: styleSheet.text(.caption)) {
                $0.foregroundColor(.white)
            }

            LegoText(value, style: styleSheet.text(.caption))
        }
    }

    private func formatRuntime(_ minutes: Int) -> String {
        let hours = minutes / 60
        let mins = minutes % 60
        return "\(hours) hr \(mins) min"
    }
}

// MARK: - Utilities

private extension String {
    var nonEmpty: String? {
        isEmpty ? nil : self
    }
}
