//
//  ArticleMetaView.swift
//  BeatitudoMedia
//
//  Created by Jinho Lee on 5/3/24.
//

import SwiftUI

struct ArticleMetadataView: View {
    @StateObject private var viewModel: ArticleMetadataViewModel
    
    @Binding var signalArticleViews: Bool
    
    init(articleMetadata: ArticleMetadata, signalArticleViews: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: ArticleMetadataViewModel(articleMetadata: articleMetadata))
        _signalArticleViews = signalArticleViews
    }
    
    var body: some View {
        ZStack {
            Color.adaptiveBackground
            
            HStack(spacing: 10) {
                HStack(spacing: 5) {
                    Image(systemName: "clock")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 10, height: 10)
                    
                    Text("\(viewModel.articleMetadata.timeToRead)분 독서")
                        .font(.system(size: 10))
                }
                .foregroundStyle(.gray)
                
                Spacer()
                
                HStack {
                    HStack(spacing: 5) {
                        Image(systemName: "eye")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height: 15)
                        
                        Text("\(viewModel.getArticleViews())")
                            .font(.system(size: 10))
                    }
                    .foregroundStyle(.gray)
                    
                    HStack(spacing: 5) {
                        Image(systemName: "calendar")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height: 15)
                        
                        Text(viewModel.articleMetadata.date)
                            .font(.system(size: 10))
                    }
                    .foregroundStyle(.gray)
                }
                .frame(width: 120)
            }
        }
        .frame(height: 15)
        .onChange(of: signalArticleViews) { _, _ in
            viewModel.updateArticleViews()
        }
    }
}

#Preview {
    BeatitudoMediaView()
}
