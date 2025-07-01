import SwiftUI

@Observable
private final class LegoAsyncImageState {
    var imageData: Data?
    
    var uiImage: UIImage? {
        return imageData.flatMap(UIImage.init)
    }
}

/// A simple SwiftUI view that asynchronously loads and displays an image from a URL.
///
/// `LegoAsyncImage` provides a flexible and composable way to load remote images with support for placeholders during loading,
/// image caching, and custom image rendering.
///
/// - Parameters:
///   - Placeholder: A view that is displayed while the image is being loaded or if loading fails. Defaults to `EmptyView()`.
///   - ContentView: The type of view created to display the loaded image. Defaults to the standard `Image` view.
///
/// - Usage:
///   ```swift
///   LegoAsyncImage(
///       url: URL(string: "https://example.com/image.png")!,
///       placeholder: { LegoProgressView() },
///       imageViewBuilder: { image in
///           image.resizable().scaledToFit()
///       }
///   )
///   ```
///
/// The image is loaded on-demand and updates automatically if the URL changes.
/// Images are loaded via the environment's `ImageLoader`, supporting caching and inflight request de-duplication.
public struct LegoAsyncImage<Placeholder: View, ContentView: View>: View {

    private let url: URL
    private let placeholder: () -> Placeholder
    private let imageModifier: (Image) -> ContentView
    
    
    @Environment(\.imageLoader)
    private var imageLoader: ImageLoader
    
    @State
    private var state: LegoAsyncImageState = .init()
    
    @State
    private var isImageVisible = false
    
    public init(
        url: URL,
        placeholder: @escaping () -> Placeholder = {
            LegoProgressView(type: .small)
        },
        imageViewBuilder: @escaping (Image) -> ContentView = { $0 }
    ) {
        self.url = url
        self.placeholder = placeholder
        self.imageModifier = imageViewBuilder
    }
    
    public var body: some View {
        Group {
            if let uiimage = state.uiImage {
                imageModifier(Image(uiImage: uiimage))
                    .opacity(isImageVisible ? 1 : .zero)
                    .animation(.easeIn(duration: 0.3), value: isImageVisible)
                    .onAppear {
                        withAnimation {
                            isImageVisible = true
                        }
                    }
            } else {
                placeholder()
            }
        }
        .task(id: url) {
            state.imageData = try? await imageLoader.fetchImageData(for: url)
        }
    }
}

// MARK: - Image Loader

struct NetworkImageLoader {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchImage(url: URL) async throws -> Data {
        let (data, _) = try await session.data(for: .init(url: url))
        return data
    }
}

actor InflightImageRequest {
    private var requestMap: [URL: Task<Data, Error>] = [:]
    static let shared = InflightImageRequest()
    
    func addRequest(for url: URL, task: Task<Data, Error>) {
        requestMap[url] = task
    }
    
    func request(for url: URL) -> Task<Data, Error>? {
        requestMap[url]
    }
    
    func removeRequest(for url: URL) {
        requestMap[url]?.cancel()
        requestMap.removeValue(forKey: url)
    }
}

struct ImageLoader {
    private let networkImageLoader: NetworkImageLoader
    private let inflightImageRequest: InflightImageRequest
    
    init(
        networkImageLoader: NetworkImageLoader = .init(),
        inflightImageRequest: InflightImageRequest = .shared
    ) {
        self.networkImageLoader = networkImageLoader
        self.inflightImageRequest = inflightImageRequest
    }
    
    func fetchImageData(for url: URL) async throws -> Data? {
        guard !Task.isCancelled else {
            return nil
        }

        if let inFlightRequest = await inflightImageRequest.request(for: url) {
            return try await inFlightRequest.value
        }
                
        let task = Task {
            let data = try await networkImageLoader.fetchImage(url: url)
            await inflightImageRequest.removeRequest(for: url)
            return data
        }
        
        await inflightImageRequest.addRequest(for: url, task: task)
        return try await task.value
    }
}


struct ImageLoaderEnvironmentKey: EnvironmentKey {
    static let defaultValue: ImageLoader = .init()
}

extension EnvironmentValues {
    var imageLoader: ImageLoader {
        get {
            self[ImageLoaderEnvironmentKey.self]
        } set {
            self[ImageLoaderEnvironmentKey.self] = newValue
        }
    }
}

#Preview {
    VStack {
        LegoAsyncImage(
            url: URL(
                string: "https://lumiere-a.akamaihd.net/v1/images/solo-theatrical-poster_f98a86eb_62fc4b3c.jpeg"
            )!,
            placeholder: {
                LegoProgressView(type: .medium)
            },
            imageViewBuilder: { image in
                image.resizable().scaledToFit().frame(width: 200, height: 300)
            }
        )
    }
}
