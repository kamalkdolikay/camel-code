class TreeNode {
    constructor(value) {
        this.value = value;
        this.left = null;
        this.right = null;
        this.domElement = null;
    }
}

class BSTree {
    constructor() {
        this.root = null;
    }

    insert(value) {
        if (this.root === null) {
            this.root = new TreeNode(value);
        } else {
            this._insertNode(this.root, value);
        }
    }

    _insertNode(node, value) {
        if (value < node.value) {
            if (node.left === null) {
                node.left = new TreeNode(value);
            } else {
                this._insertNode(node.left, value);
            }
        } else if (value > node.value) {
            if (node.right === null) {
                node.right = new TreeNode(value);
            } else {
                this._insertNode(node.right, value);
            }
        }
    }

    delete(value) {
        this.root = this._deleteNode(this.root, value);
    }

    _deleteNode(node, value) {
        if (node === null) return null;

        if (value < node.value) {
            node.left = this._deleteNode(node.left, value);
        } else if (value > node.value) {
            node.right = this._deleteNode(node.right, value);
        } else {
            if (!node.left && !node.right) return null;
            if (!node.left) return node.right;
            if (!node.right) return node.left;

            let minNode = this._getMinNode(node.right);
            node.value = minNode.value;
            node.right = this._deleteNode(node.right, minNode.value);
        }
        return node;
    }

    _getMinNode(node) {
        while (node.left !== null) {
            node = node.left;
        }
        return node;
    }

    // Calculate the depth of the tree to determine SVG height
    _getDepth(node) {
        if (!node) return 0;
        return 1 + Math.max(this._getDepth(node.left), this._getDepth(node.right));
    }

    render() {
        const container = document.getElementById("bst-container");
        container.innerHTML = '';

        // Calculate SVG dimensions based on tree depth and screen width
        const depth = this._getDepth(this.root);
        const svgHeight = depth * 100; // 100px per level
        const svgWidth = window.innerWidth; // Use the full window width

        const svg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
        svg.setAttribute("width", `${svgWidth}px`);
        svg.setAttribute("height", `${svgHeight}px`);
        svg.style.position = "absolute";
        svg.style.top = "0";
        svg.style.left = "0";
        svg.style.pointerEvents = "none";
        container.appendChild(svg);

        if (this.root) {
            // Adjust initial spacing based on screen width
            const initialSpacing = Math.min(window.innerWidth / 4, 300); // Cap at 300px
            this._renderNode(this.root, container, svg, 0, svgWidth / 2, 50, initialSpacing);
        }
    }

    _renderNode(node, container, svg, level, x, y, spacing) {
        if (!node) return;

        const nodeDiv = document.createElement('div');
        nodeDiv.className = 'node-container';
        nodeDiv.style.position = 'absolute';
        nodeDiv.style.left = `${x - 38}px`; // Center the node (20px is half the node width)
        nodeDiv.style.top = `${y - 10}px`;

        const nodeContent = document.createElement('div');
        nodeContent.className = 'tree-node';
        nodeContent.textContent = node.value;
        nodeDiv.appendChild(nodeContent);
        container.appendChild(nodeDiv);

        node.domElement = nodeDiv;
        nodeDiv.dataset.x = x;
        nodeDiv.dataset.y = y;

        const childY = y + 80;
        const newSpacing = spacing * 0.6;

        if (node.left) {
            const leftX = x - spacing;
            this._renderNode(node.left, container, svg, level + 1, leftX, childY, newSpacing);
            const leftChildX = parseFloat(node.left.domElement.dataset.x);
            const leftChildY = parseFloat(node.left.domElement.dataset.y);
            this._drawLine(svg, x, y + 20, leftChildX + 20, leftChildY + 10);
        }

        if (node.right) {
            const rightX = x + spacing;
            this._renderNode(node.right, container, svg, level + 1, rightX, childY, newSpacing);
            const rightChildX = parseFloat(node.right.domElement.dataset.x);
            const rightChildY = parseFloat(node.right.domElement.dataset.y);
            this._drawLine(svg, x, y + 20, rightChildX - 25, rightChildY + 10);
        }
    }

    _drawLine(svg, x1, y1, x2, y2) {
        const line = document.createElementNS("http://www.w3.org/2000/svg", "line");
        line.setAttribute("x1", x1);
        line.setAttribute("y1", y1);
        line.setAttribute("x2", x2);
        line.setAttribute("y2", y2);
        line.setAttribute("stroke", "#4CAF50");
        line.setAttribute("stroke-width", "2");
        svg.appendChild(line);
    }
}

// Initialize the BST with data from the server
const bst = new BSTree();
const initialNumbers = JSON.parse(document.getElementById("bst-data").textContent);
initialNumbers.forEach(num => bst.insert(num));

// Render the initial tree
bst.render();

// Event listeners for adding and deleting nodes
document.getElementById("add-node-btn").addEventListener("click", () => {
    const nodeValue = parseInt(document.getElementById("new-node").value, 10);
    if (!isNaN(nodeValue)) {
        bst.insert(nodeValue);
        bst.render();
        document.getElementById("new-node").value = '';
    } else {
        alert("Please enter a valid number!");
    }
});

document.getElementById("delete-node-btn").addEventListener("click", () => {
    const nodeValue = parseInt(document.getElementById("delete-node").value, 10);
    if (!isNaN(nodeValue)) {
        bst.delete(nodeValue);
        bst.render();
        document.getElementById("delete-node").value = '';
    } else {
        alert("Please enter a valid number to delete!");
    }
});