# Dream Project 🌳

Welcome to **Dream Project**, a web-based application built with OCaml and the Dream framework to demonstrate Binary Search Tree (BST) operations and list zipping functionality. This project provides an interactive interface for creating, visualizing, and manipulating BSTs, as well as zipping two lists into pairs. It's perfect for learning about data structures and functional programming while exploring modern web development with OCaml.

---

## 🌟 Introduction

Dream Project is an educational and interactive web application designed to showcase two core functionalities:

1. **Binary Search Tree Operations**: Create a BST from a list of numbers, visualize it, add or delete nodes, and view metrics like tree size and depth.
2. **List Zipping**: Combine two comma-separated lists into a list of pairs, displayed in a clean and user-friendly format.

Built with **OCaml**, **Dream** (a web framework), and **Dune** (a build system), this project combines functional programming with web development. The frontend includes a JavaScript-based BST visualization and a responsive design powered by CSS.

---

## 📂 Project Structure

The project is organized as follows:

```
dream-project/
│   ├── bstree.ml          # Binary Search Tree 
│   ├── zip.ml             # List zipping implementation
│   └── main.ml            # Main application logic with 
├── static/                # Static assets
│   ├── style.css          # CSS styles for the frontend
│   └── tree.js            # BST visualization
├── dune                   # Dune build configuration
├── dune-project           # Dune project metadata
├── README.md              # This file
└── LICENSE                # License file (to be added)
```

---

## 🛠️ Prerequisites

To run Dream Project on Ubuntu, ensure you have the following installed:

- **OCaml** (version 5.0 or higher)
- **Dune** (version 3.0 or higher)
- **OPAM** (OCaml package manager, version 2.1 or higher)
- **Ubuntu** (20.04 LTS or later recommended)

---

## 🐧 Installation on Ubuntu

Follow these steps to set up the project:

1. **Install OPAM**:

   ```bash
   bash -c "sh <(curl -fsSL https://opam.ocaml.org/install.sh)"
   ```

2. **Initialize OPAM**:

   ```bash
   opam init
   eval $(opam env)
   ```

3. **Install OCaml and Dune**:

   ```bash
   opam switch create 5.3.0
   opam install dune
   ```

4. **Install Dream and Lwt**:

   ```bash
   opam install dream lwt lwt_ppx
   ```

---

## 🚀 Running the Project

To run the project with Dune:

1. **Build the project**:

   ```bash
   dune build
   ```

2. **Run the application**:

   ```bash
   dune exec ./main.exe
   ```

3. **Access the web interface**:

   - Open your browser and navigate to `http://localhost:8080`.
   - The homepage offers two options: BST operations or list zipping.

---

## 📚 Usage

### Binary Search Tree Operations

1. Navigate to `/bst` from the homepage.
2. Enter comma-separated numbers (e.g., `5,2,8,1,9`) in the form and submit.
3. View the BST visualization, size, and depth.
4. Use the "Add Node" or "Delete Node" buttons to modify the tree:
   - Enter a number and click "Add Node" to insert it.
   - Enter a number and click "Delete Node" to remove it.
5. Errors (e.g., invalid input) are displayed with a "Back" link to retry.

### List Zipping

1. Navigate to `/zip` from the homepage.
2. Enter two comma-separated lists (e.g., `a,b,c` and `1,2,3`) in the form and submit.
3. View the zipped result as a list of pairs (e.g., `(a,1), (b,2), (c,3)`).
4. Click "Back" to try another pair of lists.

---

## 🤝 Contributing

Contributions are welcome! To contribute:

1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/YourFeature`).
3. Commit your changes (`git commit -m 'Add YourFeature'`).
4. Push to the branch (`git push origin feature/YourFeature`).
5. Open a Pull Request.

Please ensure your code follows the project's coding style and includes appropriate tests.

---

## 👤 Author

**Your Name**

- GitHub: https://github.com/kamalkdolikay
- Email: kamaldolikay@gmail.com

---

## 📜 License

This project is licensed under the **MIT License**. See the LICENSE file for details.

---