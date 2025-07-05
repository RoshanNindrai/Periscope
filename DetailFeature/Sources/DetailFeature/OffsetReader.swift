import SwiftUI

struct OffsetReader: UIViewRepresentable {
    
    @Binding
    private var offset: CGFloat
    
    init(offset: Binding<CGFloat>) {
        _offset = offset
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(offset: $offset)
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            if let scrollView = view.enclosingScrollView() {
                scrollView.delegate = context.coordinator
            }
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    class Coordinator: NSObject, UIScrollViewDelegate {
        
        @Binding
        private var offset: CGFloat

        init(offset: Binding<CGFloat>) {
            self._offset = offset
        }

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            DispatchQueue.main.async {
                self.offset = 0 - scrollView.contentOffset.y
            }
        }
    }
}

private extension UIView {
    func enclosingScrollView() -> UIScrollView? {
        var view = self.superview
        while let current = view {
            if let scrollView = current as? UIScrollView {
                return scrollView
            }
            view = current.superview
        }
        return nil
    }
}
