```mermaid
classDiagram
    class Book {
        +String title
        +String author
        +String isbn
        +boolean isAvailable()
    }

    class Member {
        +String name
        +String memberId
        +borrowBook(Book book)
        +returnBook(Book book)
    }

    class Librarian {
        +String name
        +String employeeId
        +addBook(Book book)
        +removeBook(Book book)
    }

    class Library {
        +String name
        +List<Book> books
        +List<Member> members
        +List<Librarian> librarians
        +addMember(Member member)
        +removeMember(Member member)
    }

    Book --> Library : contains
    Member --> Library : registers
    Librarian --> Library : manages
