//
//  BeatitudoMediaView.swift
//  BeatitudoMedia
//
//  Created by Jinho Lee on 5/1/24.
//

import SwiftUI
import Firebase

struct BeatitudoMediaView: View {
    @StateObject var viewModel: BeatitudoMediaViewModel = BeatitudoMediaViewModel()
    
    @State var currentSection: Int = 0
    
    @State private var presentingDestination: Bool = false
    @State private var destinationURL: String      = ""
    @State private var presentingReportSheet: Bool = false
    @State private var showStatusPage: Bool        = false
    
    @Namespace var namespace
    
    var body: some View {
        ZStack {
            Color.adaptiveBackground
            
            Button {
                viewModel.refreshSections()
            } label: {
                VStack {
                    Image(systemName: "arrow.circlepath")
                        .rotationEffect(.degrees(-90))
                    Text("reload")
                        .bold()
                }
                .foregroundStyle(.black)
            }
            .opacity(viewModel.sections.isEmpty ? 1 : 0)

            VStack(spacing: 0) {
                StatusView(showStatusPage: $showStatusPage)
                
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
            .opacity(viewModel.sections.isEmpty ? 0 : 1)
            
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

