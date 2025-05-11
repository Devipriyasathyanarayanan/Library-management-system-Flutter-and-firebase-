import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String title;
  final String author;
  final String bookNumber;
  String status;

  Book({
    required this.title,
    required this.author,
    required this.bookNumber,
    this.status = 'Available',
  });
}

class BooksLayout extends StatefulWidget {
  final String category;

  const BooksLayout({Key? key, required this.category}) : super(key: key);

  @override
  _BooksLayoutState createState() => _BooksLayoutState();
}

class _BooksLayoutState extends State<BooksLayout> {
  List<Book> books = [];
  List<Book> filteredBooks = [];
  String searchQuery = '';
  String sortBy = 'Title';
  String searchOption = 'Title';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  void _fetchBooks() async {
    try {
      print("Fetching books for category: ${widget.category}");

      QuerySnapshot querySnapshot = await _firestore
          .collection('LibraryBooks')
          .where('category', isEqualTo: widget.category)
          .get();

      print("Number of books fetched: ${querySnapshot.docs.length}");

      List<Book> fetchedBooks = [];
      for (var doc in querySnapshot.docs) {
        fetchedBooks.add(Book(
          title: doc['title'],
          author: doc['author'],
          bookNumber: doc['bookId'],
          status: doc['status'] ?? 'Available',
        ));
      }

      setState(() {
        books = fetchedBooks;
        filteredBooks = List.from(books);
      });

      print("Books fetched successfully: ${books.length}");
    } catch (e) {
      print("Error fetching books: $e");
    }
  }

  void filterBooks() {
    setState(() {
      if (searchOption == 'Title') {
        filteredBooks = books
            .where((book) =>
                book.title.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();
      } else if (searchOption == 'Author') {
        filteredBooks = books
            .where((book) =>
                book.author.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();
      }

      if (sortBy == 'Title') {
        filteredBooks.sort((a, b) => a.title.compareTo(b.title));
      } else if (sortBy == 'Author') {
        filteredBooks.sort((a, b) => a.author.compareTo(b.author));
      } else if (sortBy == 'Book Number') {
        filteredBooks.sort((a, b) => a.bookNumber.compareTo(b.bookNumber));
      }
    });
  }

  Future<void> _showSearchDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Search by', style: TextStyle(color: Colors.black)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('Title', style: TextStyle(color: Colors.black)),
                onTap: () {
                  setState(() {
                    searchOption = 'Title';
                  });
                  Navigator.of(context).pop();
                  _showSearchBar();
                },
              ),
              ListTile(
                title: Text('Author', style: TextStyle(color: Colors.black)),
                onTap: () {
                  setState(() {
                    searchOption = 'Author';
                  });
                  Navigator.of(context).pop();
                  _showSearchBar();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSearchBar() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Enter Search Query', style: TextStyle(color: Colors.black)),
          content: TextField(
            autofocus: true,
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search...',
              hintStyle: TextStyle(color: Colors.white54),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Search'),
              onPressed: () {
                filterBooks();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book List - ${widget.category}', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green[800],
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: _showSearchDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: sortBy,
                  dropdownColor: Colors.white,
                  style: TextStyle(color: Colors.black),
                  items: ['Title', 'Author', 'Book Number']
                      .map((e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      sortBy = value!;
                    });
                    filterBooks();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                // Table Header
                Container(
                  color: Colors.green[600],
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(child: Text('Title', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                      Expanded(child: Text('Author', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                      Expanded(child: Text('Book No.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                      Expanded(child: Text('Status', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
                // Table Rows
                ...filteredBooks.map((book) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    margin: EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white, // Set the background color here
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(child: Text(book.title, textAlign: TextAlign.center, style: TextStyle(color: Colors.black))),
                        Expanded(child: Text(book.author, textAlign: TextAlign.center, style: TextStyle(color: Colors.black))),
                        Expanded(child: Text(book.bookNumber, textAlign: TextAlign.center, style: TextStyle(color: Colors.black))),
                        Expanded(child: Chip(
                          label: Text(book.status, style: TextStyle(color: Colors.white)),
                          backgroundColor: book.status == 'Available' ? Color(0xFF808000) : Colors.red,
                        )),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}