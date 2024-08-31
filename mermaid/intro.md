```mermaid
classDiagram
    class Libro {
        +String titulo
        +String autores
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

    Libro --> Library : contiene
    Member --> Library : registra
    Librarian --> Library : administra
