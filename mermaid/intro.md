```mermaid
classDiagram
    class Libro {
        +String titulo
        +String autores
        +String isbn
        +boolean isAvailable()
    }

    class Miembro {
        +String name
        +String memberId
        +borrowBook(Book book)
        +returnBook(Book book)
    }

    class Bibliotecario {
        +String name
        +String employeeId
        +addBook(Book book)
        +removeBook(Book book)
    }

    class Biblioteca {
        +String name
        +List<Book> books
        +List<Member> members
        +List<Librarian> librarians
        +addMember(Member member)
        +removeMember(Member member)
    }

    Libro --> Biblioteca : contiene libros
    Miembro --> Biblioteca : registra
    Bibliotecario --> Biblioteca : administra
