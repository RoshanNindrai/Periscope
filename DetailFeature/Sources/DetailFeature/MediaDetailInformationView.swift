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
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                informationSection
                languagesSection
                accessibilitySection
            }
            .padding(.horizontal)
            .padding(.top)
        }
    }

    // MARK: - Sections

    private var informationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            LegoText("Information", style: styleSheet.text(.title))

            infoRow(title: "Released", value: detail.releaseDateText)

            if let runtime = detail.runtimeInMinutes {
                infoRow(title: "Run Time", value: formatRuntime(runtime))
            }

            if !detail.originCountry.isEmpty {
                infoRow(title: "Region of Origin", value: detail.originCountry.joined(separator: ", "))
            }
        }
    }

    private var languagesSection: some View {
        let audioLanguages = detail.spokenLanguages.map(\.name).joined(separator: ", ")
        let subtitles = audioLanguages.isEmpty ? nil : audioLanguages + " (SDH)"
        let originalAudio = detail.spokenLanguages.first?.englishName

        return VStack(alignment: .leading, spacing: 16) {
            LegoText("Languages", style: styleSheet.text(.title))

            if let original = originalAudio {
                infoRow(title: "Original Audio", value: original)
            }

            if !audioLanguages.isEmpty {
                infoRow(title: "Audio", value: audioLanguages)
            }

            if let subtitles = subtitles {
                infoRow(title: "Subtitles", value: subtitles)
            }
        }
    }

    private var accessibilitySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            LegoText("Accessibility", style: styleSheet.text(.title))
            LegoText("SDH", style: styleSheet.text(.callout)) {
                $0.bold().padding(.vertical, 4)
            }
            LegoText("Subtitles for the deaf and hard of hearing (SDH) refer to subtitles in the original language with the addition of relevant non-dialogue information.", style: styleSheet.text(.caption))
        }
    }

    // MARK: - Helpers

    @ViewBuilder
    private func infoRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            LegoText(title, style: styleSheet.text(.caption)) { text in
                text.foregroundColor(.white)
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
