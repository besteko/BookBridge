//
//  BookBorrowingView.swift
//  BookBridge
//
//  Created by Beste Kocaoglu on 30.01.2024.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseDatabase

struct BookBorrowingView: View {
    @Binding var isPresented: Bool
    @ObservedObject var borrowingManager: BorrowingManager
    @ObservedObject var bookViewModel: BookViewModel
    @State private var selectedDurationIndex = 0
    @State private var address = ""
    @State private var isBorrowingConfirmed = false
    @State private var showAlert = false
    @State private var showBorrowedBooksView = false
    @State private var selectedDate = Date()

    var body: some View {
        NavigationView {
            VStack {
                if let selectedBook = bookViewModel.selectedBook {
                    Text("Seçilen Kitap: \(selectedBook.title)")
                        .font(.headline)
                        .padding()
                }

                Picker("Ödünç Süresi", selection: $selectedDurationIndex) {
                    Text("1 Hafta").tag(0)
                    Text("2 Hafta").tag(1)
                    Text("3 Hafta").tag(2)
                    Text("1 Ay").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                DatePicker("Ödünç Tarihi", selection: $selectedDate, in: Date()..., displayedComponents: .date)
                    .padding()

                TextField("Adresinizi Girin", text: $address)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: {
                    showAlert.toggle()
                }) {
                    Text("Ödünç Almayı Onayla")
                        .padding()
                        .foregroundColor(.white)
                        .font(.headline)
                        .background(Color.green)
                        .cornerRadius(15)
                }
                .padding()

                if isBorrowingConfirmed {
                    Text("Kitap ödünç alındı!")
                        .foregroundColor(.green)
                        .bold()
                        .padding()
                }
            }
            .navigationBarItems(trailing: Button("Kapat") {
                isPresented = false
            })
            .navigationBarTitle("Kitap Ödünç Alma", displayMode: .inline)
            .confirmationDialog("Kitabı ödünç almak istediğinize emin misiniz?", isPresented: $showAlert) {
                Button("Evet") {
                    borrowingManager.borrowBook(book: bookViewModel.selectedBook!, selectedDurationIndex: selectedDurationIndex, address: address, selectedDate: selectedDate)
                    
                    borrowingManager.updateBookBorrowStatus(bookId: bookViewModel.selectedBook!.id!, isBorrowed: true) { error in
                        if let error = error {
                            print("Kitap ödünç alındı, ancak isBorrowed güncellenirken bir hata oluştu: \(error.localizedDescription)")
                        } else {
                            print("Kitap ödünç alındı ve isBorrowed güncellendi!")
                        }
                    }

                    isBorrowingConfirmed = true
                    print(selectedDate)
                }


                Button("Hayır") {
                    isBorrowingConfirmed = false
                }
            }
            .background(
                NavigationLink(
                    destination: BorrowedBooksView(viewModel: BorrowedBooksViewModel(borrowingManager: borrowingManager), bookViewModel: bookViewModel),
                    isActive: $showBorrowedBooksView
                ) {
                    EmptyView()
                }
                .hidden()
            )
        }
    }
}
