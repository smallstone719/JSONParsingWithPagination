//
//  HomeView.swift
//  JSONParsingWithPagination
//
//  Created by Thach Nguyen Trong on 3/22/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeView: View {
    @State private var photos: [Photo]      = []
    @State private var page: Int            = 1
    @State private var lastFetchedPage: Int = 1
    @State private var maxPage: Int         = 5
    /// Ngăn ngừa viẹc đang fetch dữ liệu chưa xong
    /// mà kích hoạt fetch dữ liệu mới.
    @State private var isLoading: Bool      = false
    /// Pagination properties
    @State private var activePhotoID: String?
    @State private var lastPhotoID: String?
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 3), spacing: 24) {
                ForEach(photos) { photo in
                    PhotoCardView(photo: photo)
                }
            }
            .overlay(alignment: .bottom) {
                if isLoading {
                    ProgressView()
                        .offset(y: 30)
                }
            }
            .padding(15)
            .padding(.bottom, 15)
            .scrollTargetLayout()
        }
        .scrollPosition(id: $activePhotoID, anchor: .bottomTrailing)
        .onChange(of: activePhotoID, { oldValue, newValue in
            print(newValue as Any)
            if newValue == lastPhotoID, !isLoading, page != maxPage {
               page += 1
                fetchPhotos()
            }
        })
        .onAppear {
            fetchPhotos()
        }
    }
    
    /// Fetching photos as per needs
    func fetchPhotos() {
        Task {
            do {
                if let url = URL(string: "https://picsum.photos/v2/list?page=\(page)&limit=30") {
                    isLoading = true
                    let session = URLSession(configuration: .default)
                    let jsonData = try await session.data(from: url).0
                    let photos = try JSONDecoder().decode([Photo].self, from: jsonData)
                    /// Updating UI in Main Thread
                    await MainActor.run {
                        if photos.isEmpty {
                            /// No more data
                            page = lastFetchedPage
                            maxPage = lastFetchedPage
                        } else {
                            /// Adding to the array of photos
                            self.photos.append(contentsOf: photos)
                            lastPhotoID = self.photos.last?.id
                            lastFetchedPage = page
                        }
                        isLoading = false
                    }
                }
            } catch {
                isLoading = false
                print(error.localizedDescription)
            }
        }
    }
}

struct PhotoCardView: View {
    var photo: Photo
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            GeometryReader {
                let size = $0.size
                
                AnimatedImage(url: photo.imageURL) {
                    ProgressView()
                        .frame(width: size.width, height: size.height)
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height)
                .clipShape(.rect(cornerRadius: 10))
            }
            .frame(height: 120)
            
            Text(photo.author)
                .font(.caption)
                .foregroundStyle(.gray)
                .lineLimit(1)
            
        }
    }
}

#Preview {
    ContentView()
}
