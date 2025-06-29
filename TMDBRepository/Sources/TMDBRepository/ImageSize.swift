public enum ImageSize: String, CaseIterable, Sendable {
    case w45 = "w45"
    case w92 = "w92"
    case w154 = "w154"
    case w185 = "w185"
    case w300 = "w300"
    case w500 = "w500"
    case w780 = "w780"
    case w1280 = "w1280"
    case h632 = "h632"
    case w342 = "w342"
    case original = "original"
}

public enum BackdropSize: String, CaseIterable, Sendable {
    case w300, w780, w1280, original
}

public enum LogoSize: String, CaseIterable, Sendable {
    case w45, w92, w154, w185, w300, w500, original
}

public enum PosterSize: String, CaseIterable, Sendable {
    case w92, w154, w185, w342, w500, w780, original
}

public enum ProfileSize: String, CaseIterable, Sendable {
    case w45, w185, h632, original
}

public enum StillSize: String, CaseIterable, Sendable {
    case w92, w185, w300, original
}
