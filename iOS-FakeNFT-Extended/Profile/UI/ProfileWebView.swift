//
//  ProfileWebView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олеся Орленко on 17.02.2026.
//

import SwiftUI
import WebKit

struct ProfileWebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView(frame: .zero)
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        if webView.url != url {
            webView.load(URLRequest(url: url))
        }
    }
}
