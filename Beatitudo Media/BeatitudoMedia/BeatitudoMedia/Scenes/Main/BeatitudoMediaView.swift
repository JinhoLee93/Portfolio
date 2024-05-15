//
//  BeatitudoMediaView.swift
//  BeatitudoMedia
//
//  Created by Jinho Lee on 5/1/24.
//

import SwiftUI
import Firebase

struct BeatitudoMediaView: View {
    @StateObject var viewModel = BeatitudoMediaViewModel()
    
    @State var currentSection: Int = 0
    
    @State private var presentingDestination: Bool = false
    @State private var destinationURL: String = ""
    @State private var presentingReportSheet: Bool = false
    
    @Namespace var namespace
    
    var body: some View {
        ZStack {
            Color.adaptiveBackground
            
            VStack(spacing: 0) {
                SectionBar(currentSectionIndex: $currentSection, namespace: namespace.self)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                
                Divider()
                    .background(.adaptiveView)
                
                SectionView(currentSection: $currentSection,
                            presentingDestination: $presentingDestination,
                            destinationURL: $destinationURL,
                            presentingReportSheet: $presentingReportSheet)
                    .ignoresSafeArea()
            }
            
            ReportSheetView(presentingReportSheet: $presentingReportSheet)
        }
        .environmentObject(viewModel)
        .analyticsScreen(name: "\(BeatitudoMediaView.self)")
        .navigationDestination(isPresented: $presentingDestination, destination: {
            NavigationStack {
                WebView(url: destinationURL)
            }
            .navigationTitle(Text(viewModel.tokenizeURLandReturnName(destinationURL)))
            .navigationBarTitleDisplayMode(.inline)
        })
    }
}

#Preview {
    BeatitudoMediaView()
}

