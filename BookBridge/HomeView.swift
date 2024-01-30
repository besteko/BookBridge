import SwiftUI

struct HomeView: View {
    @State private var refreshID = UUID()
    @State private var searchText = ""
    @StateObject var bookViewModel = BookViewModel()
    @State private var filteredBooks: [Book] = [] // Burada filteredBooks'u state olarak ekledik

    var body: some View {
        TabView {
            NavigationView {
                VStack {
                    if isHomeView {
                        HStack {
                            Image("bookstack")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 50)
                                .padding()
                            SearchBar(searchText: $searchText, placeholder: "", onCommit: filterBooks)
                                .padding(.bottom, 10)
                        }
                    }
                    BookCardGridView(bookViewModel: bookViewModel, searchText: $searchText, refreshID: $refreshID)
                        .id(refreshID)
                }
                .background(Color(red: 1.2, green: 1.1, blue: 0.9))
            }
            .tabItem {
                Label("Ana Sayfa", systemImage: "house")
            }

            NavigationView {
                AddBookView(bookViewModel: bookViewModel)
            }
            .tabItem {
                Label("Kitap Ekle", systemImage: "book")
            }

            NavigationView {
                ProfileView(bookViewModel: bookViewModel)
            }
            .tabItem {
                Label("Profil", systemImage: "person")
            }

            NavigationView {
                BorrowedBooksView(viewModel: BorrowedBooksViewModel(borrowingManager: BorrowingManager()), bookViewModel: bookViewModel)
                   // .navigationBarTitle("Ödünç Al/Kirala")
            }
            .tabItem {
                Label("Ödünç Al", systemImage: "person.2.square.stack")
            }
        }
        .background(Color.white)
        .accentColor(.orange)
        .environmentObject(bookViewModel)
    }

    private func filterBooks() {
        filteredBooks = bookViewModel.filterBooks(with: searchText)
    }


    private var isHomeView: Bool {
        return true
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

