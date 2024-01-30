//
//  BorrowedBooksView.swift
//  bitirmedeneme
//
//  Created by Beste Kocaoglu on 21.11.2023.
//

import SwiftUI
import Firebase

class BorrowedBooksViewModel: ObservableObject {
    @Published var selectedCategory = 0
    @ObservedObject var borrowingManager: BorrowingManager
    @Published var borrowedBooks: [BorrowedBook] = []
    @Published var lentBooks: [BorrowedBook] = []

    init(borrowingManager: BorrowingManager) {
        self.borrowingManager = borrowingManager
    }
    
    func fetchBorrowedBooks() {
        self.borrowingManager.fetchBorrowedBooks { books in
            self.borrowedBooks = books
        }
    }
    
    func fetchLentBooks() {
        self.borrowingManager.fetchLentBooks { books in
            self.lentBooks = books
        }
    }
    
}

struct BorrowedBooksView: View {
    @ObservedObject var viewModel: BorrowedBooksViewModel
    @ObservedObject var bookViewModel: BookViewModel

    var body: some View {
        VStack {
            Image("book") // Logo ekleyin (resim adınıza göre değiştirin)
                .resizable()
                .scaledToFit()
                .frame(height: 80)
                .padding(.top, 80)

            Picker(selection: $viewModel.selectedCategory, label: Text("")) {
                Text("Ödünç Aldıklarım").tag(0)
                //Text("Ödünç Verdiklerim").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            // Kitap Listesi
            List {
                if viewModel.selectedCategory == 0 {
                    ForEach(viewModel.borrowedBooks) { book in
                        BorrowedBookRow(book: book)
                    }
                } else {
                    ForEach(viewModel.lentBooks) { book in
                        BorrowedBookRow(book: book)
                    }
                }
            }
            .onAppear {
                if viewModel.selectedCategory == 0 {
                    viewModel.fetchBorrowedBooks()
                } else {
                    viewModel.fetchLentBooks()
                }
            }
        }
        .onChange(of: viewModel.selectedCategory, perform: { newValue in
            if newValue == 0 {
                viewModel.fetchBorrowedBooks()
            } else {
                viewModel.fetchLentBooks()
            }
        })
        .background(Color(red: 1.2, green: 1.1, blue: 0.9)) // Arka plan rengi
        .foregroundColor(.white) // Metin rengi
        .edgesIgnoringSafeArea(.all)
    }
}

struct BorrowedBookRow: View {
    var book: BorrowedBook

    var body: some View {
        VStack(alignment: .leading) {
            Text(book.title)
                            .font(.headline)
                            .foregroundColor(.blue)

                        Text(book.author)
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        Text("Ödünç Alınan Tarih: \(formattedDate(book.borrowedDate))")
                            .font(.caption)
                            .foregroundColor(.green)

                        Text("Ödünç Verilmesi Gereken Tarih: \(formattedDate(book.returnDate))")
                            .font(.caption)
                            .foregroundColor(.green)
            // Diğer bilgileri ekleyebilirsiniz.
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter.string(from: date)
    }
}

// Bu kısmı tümüyle ekleyin
struct BorrowedBooksView_Previews: PreviewProvider {
    static var previews: some View {
        BorrowedBooksView(viewModel: BorrowedBooksViewModel(borrowingManager: BorrowingManager()), bookViewModel: BookViewModel())
    }
}








