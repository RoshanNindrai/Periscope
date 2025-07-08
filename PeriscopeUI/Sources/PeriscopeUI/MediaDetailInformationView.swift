/// A SwiftUI view that displays detailed information, languages, and accessibility info for a given media item.

import DataModel
import SwiftUI
import Lego

/// A view that organizes various informational sections about a media item.
public struct MediaDetailInformationView: View {
    /// The detailed data for the media item to display.
    private let detail: any MediaDetail

    /// The StyleSheet environment value for consistent styling.
    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet

    /// Initializes the view with the provided media detail.
    /// - Parameter detail: The media detail to display information for.
    public init(detail: any MediaDetail) {
        self.detail = detail
    }

    // MARK: - Body

    /// Main layout for the details view including information, language, and accessibility sections (conditionally shown).
    public var body: some View {
        VStack(alignment: .leading, spacing: styleSheet.spacing.spacing100) {
            // Show information section if there is any relevant data.
            if hasInformationSection {
                informationSection
            }

            // Show languages section if there are spoken languages or original audio info.
            if hasLanguagesSection {
                languagesSection
            }

            // Show accessibility section if accessibility info is available.
            if hasAccessibilitySection {
                accessibilitySection
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Sections

    /// Section displaying general information about the media item.
    private var informationSection: some View {
        VStack(alignment: .leading, spacing: styleSheet.spacing.spacing100) {
            LegoText("Information", style: styleSheet.text(.title))

            VStack(alignment: .leading, spacing: styleSheet.spacing.spacing200) {
                // Display release date if available.
                if !detail.releaseDateText.isEmpty {
                    infoRow(title: "Released", value: detail.releaseDateText)
                }

                // Display runtime if available.
                if let runtime = detail.runtimeInMinutes {
                    infoRow(title: "Run Time", value: formatRuntime(runtime))
                }

                // Display origin country if available.
                if !detail.originCountry.isEmpty {
                    infoRow(
                        title: "Region of Origin",
                        value: detail.originCountry.joined(separator: ", ")
                    )
                }
            }
        }
    }

    /// Section displaying language-related information including original audio, audio languages, and subtitles.
    private var languagesSection: some View {
        let spokenLanguages = detail.spokenLanguages
        let audioLanguages = spokenLanguages.map(\.name).filter { !$0.isEmpty }
        let audioLanguagesText = audioLanguages.joined(separator: ", ")
        let subtitles = audioLanguagesText.isEmpty ? nil : audioLanguagesText + " (SDH)"
        let originalAudio = spokenLanguages.first?.englishName.nonEmpty

        return VStack(alignment: .leading, spacing: styleSheet.spacing.spacing100) {
            LegoText("Languages", style: styleSheet.text(.title))

            VStack(alignment: .leading, spacing: styleSheet.spacing.spacing200) {
                // Show original audio language if available.
                if let original = originalAudio {
                    infoRow(title: "Original Audio", value: original)
                }
                
                // Show audio languages if available.
                if !audioLanguagesText.isEmpty {
                    infoRow(title: "Audio", value: audioLanguagesText)
                }
                
                // Show subtitles info if available.
                if let subtitles = subtitles {
                    infoRow(title: "Subtitles", value: subtitles)
                }
            }
        }
    }

    /// Section explaining accessibility features related to SDH (Subtitles for the Deaf and Hard of Hearing).
    private var accessibilitySection: some View {
        VStack(alignment: .leading, spacing: styleSheet.spacing.spacing100) {
            LegoText("Accessibility", style: styleSheet.text(.title))

            VStack(alignment: .leading, spacing: styleSheet.spacing.spacing100) {
                LegoText("SDH", style: styleSheet.text(.callout)) {
                    $0.bold()
                }

                LegoText(
                    "Subtitles for the deaf and hard of hearing (SDH) refer to subtitles in the original language with the addition of relevant non-dialogue information.",
                    style: styleSheet.text(.caption)
                )
            }
        }
    }

    // MARK: - Visibility Conditions

    /// Determines if the information section should be shown.
    /// Returns true if any of release date, runtime, or origin country data exists.
    private var hasInformationSection: Bool {
        !detail.releaseDateText.isEmpty ||
        detail.runtimeInMinutes != nil ||
        !detail.originCountry.isEmpty
    }

    /// Determines if the languages section should be shown.
    /// Returns true if there is a non-empty original audio language or any non-empty audio languages.
    private var hasLanguagesSection: Bool {
        let hasOriginal = detail.spokenLanguages.first?.englishName.isEmpty == false
        let hasAudio = detail.spokenLanguages.contains { !$0.name.isEmpty }
        return hasOriginal || hasAudio
    }

    /// Determines if the accessibility section should be shown.
    /// Returns true if there are any spoken languages (implying accessibility info may be relevant).
    private var hasAccessibilitySection: Bool {
        !detail.spokenLanguages.isEmpty
    }

    // MARK: - Helpers

    /// Helper view to display a title and value in a vertically stacked format with spacing and styled text.
    /// - Parameters:
    ///   - title: The title text for the row.
    ///   - value: The value text for the row.
    @ViewBuilder
    private func infoRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: styleSheet.spacing.spacing50) {
            LegoText(title, style: styleSheet.text(.caption)) {
                $0.foregroundColor(.white)
            }

            LegoText(value, style: styleSheet.text(.caption))
        }
    }

    /// Formats the runtime in minutes to a human-readable string (e.g., "1 hr 45 min").
    /// - Parameter minutes: The runtime duration in minutes.
    /// - Returns: A formatted string representing hours and minutes.
    private func formatRuntime(_ minutes: Int) -> String {
        let hours = minutes / 60
        let mins = minutes % 60
        return "\(hours) hr \(mins) min"
    }
}

// MARK: - Utilities

/// Utility to return nil for empty strings.
private extension String {
    var nonEmpty: String? {
        isEmpty ? nil : self
    }
}

