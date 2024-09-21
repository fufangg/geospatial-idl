# 2D Geospatial Map Builder

This project provides a script to build a 2D Geospatial Map using the IDL (Interactive Data Language) compiler. 

## 🛠️ Build Instructions

To compile the script, ensure you have the [IDL compiler from NV5 Geospatial](https://www.nv5geospatialsoftware.com/Products/IDL) installed on your system.

### ⚙️ Requirements
- **NV5 IDL Compiler**: Ensure that you have IDL installed.
- **Operating System**: Supports Windows, Linux, and macOS.

### 📂 File Path Setup
When specifying file paths, note the differences between operating systems:
- **Windows**: Use `\` (e.g., `C:\path\to\file.sav`)
- **Linux/macOS**: Use `/` (e.g., `/path/to/file.sav`)

## 📁 Supported File Formats
- **Input**: `.sav` files
- **Output**: `.png` images

## 🚀 How to Use

1. **Prepare your input**: Ensure your geospatial data is in `.sav` format.
2. **Run the script** using the IDL compiler.
3. **Output**: A 2D Geospatial Map will be generated as a `.png` file.

## 💡 Example Usage
```bash
# On Windows
idl script_name.pro "C:\path\to\input.sav" "C:\path\to\output.png"

# On Linux/macOS
idl script_name.pro "/path/to/input.sav" "/path/to/output.png"
```

## 🌐 Resources
- [IDL Compiler Documentation](https://www.nv5geospatialsoftware.com/Products/IDL)

Feel free to customize this script for your specific geospatial analysis needs!

--- 

This format makes it easier to read, emphasizes important points with icons and section titles, and provides clear examples for users.
