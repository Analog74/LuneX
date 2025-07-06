# LuneX GUI Development Guide

## 🎨 GUI Architecture & Design Patterns

This guide provides comprehensive documentation for LuneX's graphical user interface, designed to enable efficient AI-assisted development and cross-platform GUI enhancements.

## 🏗️ GUI Framework Architecture

### Technology Stack
- **Framework**: Python tkinter (built-in, cross-platform)
- **Styling**: ttk (themed widgets) with platform adaptation
- **Layout**: Grid and pack managers for responsive design
- **State Management**: tkinter Variables with configuration persistence

### Design Philosophy

#### 1. Progressive Disclosure
- **Simple First**: Core functionality immediately visible
- **Advanced Hidden**: Complex options accessible when needed
- **Context-Aware**: Show relevant options based on user selections

#### 2. Memory-Driven Interface
- **Path Memory**: Remembers last used directories
- **Preference Persistence**: Export mode and option memory
- **Default Configuration**: Smart defaults that improve over time

#### 3. Cross-Platform Native Feel
```python
# Platform-specific styling
if platform.system() == "Darwin":
    self.style.theme_use('aqua')      # macOS native
elif platform.system() == "Windows":
    self.style.theme_use('winnative') # Windows native
else:
    self.style.theme_use('clam')      # Universal fallback
```

## 🎯 GUI Component Architecture

### Main Window Structure
```
LuneX_GUI (600x500)
├── Header Section (Title + Branding)
├── File Selection Section
│   ├── File Path Display (readonly Entry)
│   └── Browse Button
├── Export Configuration Section
│   ├── Mode Selection (Radio Buttons)
│   ├── Mode Descriptions (Contextual Labels)
│   └── Conditional Options (Checkboxes)
├── Directory Management Section
│   ├── Default Source Configuration
│   └── Default Destination Configuration
├── Action Section
│   └── Export Button (Primary Action)
└── Status Section
    └── Status Label (Dynamic Feedback)
```

### Component Implementation Patterns

#### 1. Labeled Frame Containers
```python
# Pattern: Organized sections with clear visual hierarchy
file_frame = ttk.LabelFrame(main_frame, text="1. Select .rbxl File", padding="10")
file_frame.pack(fill=tk.X, pady=10)

# Benefits:
# - Clear visual organization
# - Accessible navigation (numbered steps)
# - Consistent spacing and padding
```

#### 2. State-Bound Variables
```python
# Pattern: GUI state synchronized with configuration
self.file_path_var = tk.StringVar()
self.export_mode_var = tk.StringVar(value=self.config.get("last_export_mode", "rojo"))
self.create_project_json_var = tk.BooleanVar(value=False)

# Benefits:
# - Automatic GUI updates when state changes
# - Easy configuration persistence
# - Clean separation of data and presentation
```

#### 3. Responsive Layout Management
```python
# Pattern: Flexible layouts that adapt to content
file_entry = ttk.Entry(file_frame, textvariable=self.file_path_var, width=60, state="readonly")
file_entry.pack(side=tk.LEFT, fill=tk.X, expand=True, padx=(0, 10))

browse_button = ttk.Button(file_frame, text="Browse...", command=self.browse_file)
browse_button.pack(side=tk.RIGHT)

# Benefits:
# - Adapts to different window sizes
# - Consistent spacing across platforms
# - Professional appearance
```

## 🎨 Visual Design System

### Color Scheme Strategy
```python
# Using system colors for native appearance
self.style.configure("Accent.TButton", font=('Helvetica', 12, 'bold'))

# Color considerations:
# - System theme integration (light/dark mode)
# - High contrast for accessibility
# - Brand consistency across platforms
```

### Typography Hierarchy
```python
# Title: Large, bold, attention-grabbing
title_label = ttk.Label(main_frame, text="LuneX - Roblox Export Tool", 
                       font=('Helvetica', 16, 'bold'))

# Descriptions: Smaller, muted, informative
rojo_desc = ttk.Label(rojo_frame, 
                     text="(Full project structure with default.project.json)", 
                     font=('Helvetica', 9))

# Actions: Medium, bold, clear call-to-action
export_button = ttk.Button(export_frame, text="Export Project", 
                          style="Accent.TButton")
```

### Spacing and Layout Guidelines
```python
# Consistent padding throughout interface
main_frame = ttk.Frame(self, padding="20")        # Outer container
file_frame = ttk.LabelFrame(main_frame, padding="10")  # Section containers
file_frame.pack(fill=tk.X, pady=10)               # Inter-section spacing

# Spacing principles:
# - 20px outer margins for breathing room
# - 10px section padding for content separation
# - 10px vertical spacing between sections
# - 5px spacing for related elements
```

## 🔧 Event Handling Architecture

### File Operations Pattern
```python
def browse_file(self):
    """
    File selection with intelligent directory management
    """
    # Smart initial directory selection
    initial_dir = (self.config.get("default_source_dir") or 
                  self.config.get("last_source_dir", os.path.expanduser("~")))
    
    # Native file dialog
    file_path = filedialog.askopenfilename(
        title="Select a Roblox Place File",
        initialdir=initial_dir,
        filetypes=(("Roblox Place Files", "*.rbxl"), ("All files", "*.*"))
    )
    
    # State update and persistence
    if file_path:
        self.file_path_var.set(file_path)
        self.config["last_source_dir"] = os.path.dirname(file_path)
        save_config(self.config)
```

**Key Patterns:**
- **Intelligent Defaults**: Use remembered paths as starting points
- **Immediate Persistence**: Save preferences as soon as they change
- **Graceful Cancellation**: Handle user cancellation without errors

### Export Workflow Pattern
```python
def run_export(self):
    """
    Complete export workflow with validation and feedback
    """
    # 1. Input validation
    rbxl_path = self.file_path_var.get()
    if not rbxl_path:
        messagebox.showerror("Error", "Please select a .rbxl file first.")
        return

    # 2. Directory selection with smart defaults
    initial_dir = (self.config.get("default_dest_dir") or 
                  self.config.get("last_dest_dir", os.path.expanduser("~")))
    output_dir = filedialog.askdirectory(title="Select Output Directory", 
                                        initialdir=initial_dir)
    if not output_dir:
        return

    # 3. Configuration persistence
    self.config["last_dest_dir"] = output_dir
    self.config["last_export_mode"] = self.export_mode_var.get()
    save_config(self.config)

    # 4. Visual feedback
    self.status_var.set("Exporting...")
    self.update()

    # 5. Process execution with error handling
    try:
        success, message = run_lune_export(...)
        if success:
            messagebox.showinfo("Success", message)
            self.status_var.set("Export completed successfully")
            self.open_output_directory(output_dir)
        else:
            messagebox.showerror("Export Failed", message)
            self.status_var.set("Export failed")
    except Exception as e:
        messagebox.showerror("Export Failed", f"An unexpected error occurred:\n{e}")
        self.status_var.set("Export failed")
```

**Workflow Benefits:**
- **Comprehensive Validation**: Multiple validation points prevent errors
- **Clear User Feedback**: Status updates at each step
- **Automatic Actions**: Opens result directory on success
- **Error Recovery**: Graceful handling of all failure modes

## 🌐 Cross-Platform GUI Adaptations

### Platform Detection and Adaptation
```python
import platform

def apply_platform_styling(self):
    """Apply platform-specific GUI adaptations"""
    system = platform.system()
    
    if system == "Darwin":  # macOS
        self.configure_macos_styling()
    elif system == "Windows":
        self.configure_windows_styling()
    else:  # Linux and others
        self.configure_linux_styling()

def configure_macos_styling(self):
    """macOS-specific adaptations"""
    self.style.theme_use('aqua')
    # macOS users expect larger click targets
    self.style.configure("TButton", padding=(10, 5))
    # Native file dialogs work better with absolute paths
    self.use_absolute_paths = True

def configure_windows_styling(self):
    """Windows-specific adaptations"""
    self.style.theme_use('winnative')
    # Windows users expect more compact interfaces
    self.style.configure("TButton", padding=(8, 3))
    # Windows file dialogs handle UNC paths differently
    self.handle_unc_paths = True

def configure_linux_styling(self):
    """Linux-specific adaptations"""
    self.style.theme_use('clam')
    # Linux users often prefer keyboard navigation
    self.enable_keyboard_shortcuts()
    # Handle various desktop environments
    self.detect_desktop_environment()
```

### File System Integration
```python
def open_output_directory(self, directory_path):
    """Open directory in platform-native file manager"""
    system = platform.system()
    
    try:
        if system == "Windows":
            os.startfile(directory_path)
        elif system == "Darwin":  # macOS
            subprocess.Popen(["open", directory_path])
        else:  # Linux
            # Try common Linux file managers
            for cmd in ["xdg-open", "nautilus", "dolphin", "thunar"]:
                try:
                    subprocess.Popen([cmd, directory_path])
                    break
                except FileNotFoundError:
                    continue
    except Exception as e:
        # Fallback: show path in status
        self.status_var.set(f"Export completed: {directory_path}")
```

## 🎛️ Configuration Management GUI

### Settings Interface Pattern
```python
def create_settings_dialog(self):
    """Create advanced settings dialog"""
    settings_window = tk.Toplevel(self)
    settings_window.title("LuneX Settings")
    settings_window.geometry("500x400")
    settings_window.transient(self)  # Modal-like behavior
    settings_window.grab_set()       # Focus capture
    
    # Settings categories
    notebook = ttk.Notebook(settings_window)
    
    # General settings tab
    general_frame = ttk.Frame(notebook)
    notebook.add(general_frame, text="General")
    
    # Advanced settings tab
    advanced_frame = ttk.Frame(notebook)
    notebook.add(advanced_frame, text="Advanced")
    
    notebook.pack(fill=tk.BOTH, expand=True, padx=10, pady=10)
```

### Dynamic Option Visibility
```python
def on_export_mode_changed(self, *args):
    """Show/hide options based on export mode selection"""
    mode = self.export_mode_var.get()
    
    if mode == "scripts-only":
        self.project_json_checkbox.pack(side=tk.RIGHT)
    else:
        self.project_json_checkbox.pack_forget()
    
    # Update descriptions
    if mode == "rojo":
        self.mode_description.set("Creates complete Rojo project structure")
    else:
        self.mode_description.set("Extracts scripts to flat directory")
```

## 🔄 State Management Patterns

### Configuration Synchronization
```python
class ConfigManager:
    """Centralized configuration management with GUI synchronization"""
    
    def __init__(self, gui_instance):
        self.gui = gui_instance
        self.config = load_config()
        self.bind_gui_variables()
    
    def bind_gui_variables(self):
        """Bind GUI variables to configuration changes"""
        self.gui.export_mode_var.trace('w', self.on_export_mode_changed)
        self.gui.default_source_var.trace('w', self.on_default_source_changed)
        
    def on_export_mode_changed(self, *args):
        """Handle export mode changes"""
        new_mode = self.gui.export_mode_var.get()
        self.config["last_export_mode"] = new_mode
        self.save_config()
        self.gui.update_conditional_options(new_mode)
    
    def save_config(self):
        """Atomic configuration save with error handling"""
        try:
            temp_file = CONFIG_FILE + ".tmp"
            with open(temp_file, 'w') as f:
                json.dump(self.config, f, indent=2)
            os.replace(temp_file, CONFIG_FILE)  # Atomic operation
        except Exception as e:
            print(f"Failed to save configuration: {e}")
```

### Validation Pipeline
```python
class ValidationManager:
    """Input validation with user feedback"""
    
    def validate_file_selection(self, file_path):
        """Validate selected file"""
        if not file_path:
            return False, "No file selected"
        
        if not os.path.exists(file_path):
            return False, "File does not exist"
        
        if not file_path.lower().endswith(('.rbxl', '.rbxlx')):
            return False, "File must be a Roblox place file (.rbxl or .rbxlx)"
        
        try:
            # Quick file access test
            with open(file_path, 'rb') as f:
                f.read(10)
            return True, "File is valid"
        except PermissionError:
            return False, "Permission denied - cannot read file"
        except Exception as e:
            return False, f"File access error: {e}"
    
    def validate_output_directory(self, directory_path):
        """Validate output directory"""
        if not directory_path:
            return False, "No directory selected"
        
        if not os.path.exists(directory_path):
            return False, "Directory does not exist"
        
        if not os.access(directory_path, os.W_OK):
            return False, "Directory is not writable"
        
        return True, "Directory is valid"
```

## 🎨 UI Enhancement Opportunities

### 1. Modern UI Components
```python
# Replace basic widgets with enhanced versions
class ModernButton(ttk.Button):
    """Enhanced button with hover effects and better styling"""
    
    def __init__(self, parent, **kwargs):
        super().__init__(parent, **kwargs)
        self.bind("<Enter>", self.on_hover_enter)
        self.bind("<Leave>", self.on_hover_leave)
    
    def on_hover_enter(self, event):
        self.configure(style="Hover.TButton")
    
    def on_hover_leave(self, event):
        self.configure(style="Normal.TButton")

class ProgressDialog:
    """Non-blocking progress dialog for long operations"""
    
    def __init__(self, parent, title="Processing..."):
        self.window = tk.Toplevel(parent)
        self.window.title(title)
        self.window.geometry("400x150")
        
        self.progress_var = tk.DoubleVar()
        self.progress_bar = ttk.Progressbar(
            self.window, 
            variable=self.progress_var,
            mode='determinate'
        )
        self.progress_bar.pack(pady=20, padx=20, fill=tk.X)
        
        self.status_label = ttk.Label(self.window, text="Initializing...")
        self.status_label.pack(pady=10)
    
    def update_progress(self, value, status_text):
        self.progress_var.set(value)
        self.status_label.configure(text=status_text)
        self.window.update()
```

### 2. Drag and Drop Interface
```python
class DropZone(ttk.Frame):
    """Drag and drop file selection area"""
    
    def __init__(self, parent, on_drop_callback, **kwargs):
        super().__init__(parent, **kwargs)
        self.on_drop = on_drop_callback
        
        # Visual styling for drop zone
        self.configure(style="DropZone.TFrame")
        
        # Drop zone label
        self.label = ttk.Label(
            self, 
            text="Drag .rbxl file here or click to browse",
            style="DropZone.TLabel"
        )
        self.label.pack(expand=True)
        
        # Enable drag and drop
        self.dnd_bind()
        
        # Click to browse fallback
        self.bind("<Button-1>", self.browse_file)
        self.label.bind("<Button-1>", self.browse_file)
    
    def dnd_bind(self):
        """Bind drag and drop events"""
        self.drop_target_register(DND_FILES)
        self.dnd_bind('<<Drop>>', self.on_file_dropped)
        self.dnd_bind('<<DragEnter>>', self.on_drag_enter)
        self.dnd_bind('<<DragLeave>>', self.on_drag_leave)
    
    def on_file_dropped(self, event):
        """Handle dropped files"""
        files = event.data.split()
        if files:
            file_path = files[0].strip('{}')  # Remove curly braces
            if file_path.lower().endswith(('.rbxl', '.rbxlx')):
                self.on_drop(file_path)
            else:
                messagebox.showerror("Error", "Please drop a .rbxl or .rbxlx file")
```

### 3. Recent Files Management
```python
class RecentFilesMenu:
    """Recent files menu with intelligent ordering"""
    
    def __init__(self, parent_menu, config_manager):
        self.parent_menu = parent_menu
        self.config = config_manager
        self.recent_files = self.config.get("recent_files", [])
        
        # Create recent files submenu
        self.menu = tk.Menu(parent_menu, tearoff=0)
        parent_menu.add_cascade(label="Recent Files", menu=self.menu)
        
        self.update_menu()
    
    def add_recent_file(self, file_path):
        """Add file to recent files list"""
        # Remove if already exists
        if file_path in self.recent_files:
            self.recent_files.remove(file_path)
        
        # Add to beginning
        self.recent_files.insert(0, file_path)
        
        # Limit to 10 recent files
        self.recent_files = self.recent_files[:10]
        
        # Update configuration
        self.config["recent_files"] = self.recent_files
        save_config(self.config)
        
        # Update menu
        self.update_menu()
    
    def update_menu(self):
        """Update the recent files menu"""
        # Clear existing items
        self.menu.delete(0, tk.END)
        
        if not self.recent_files:
            self.menu.add_command(label="No recent files", state="disabled")
            return
        
        for file_path in self.recent_files:
            if os.path.exists(file_path):
                filename = os.path.basename(file_path)
                self.menu.add_command(
                    label=filename,
                    command=lambda path=file_path: self.open_recent_file(path)
                )
        
        # Add clear option
        self.menu.add_separator()
        self.menu.add_command(label="Clear Recent Files", command=self.clear_recent_files)
```

## 🧪 GUI Testing Strategies

### Automated GUI Testing
```python
import unittest
from unittest.mock import patch, MagicMock

class TestLuneXGUI(unittest.TestCase):
    """GUI component testing"""
    
    def setUp(self):
        """Set up test environment"""
        self.root = tk.Tk()
        self.root.withdraw()  # Hide test window
        self.app = LuneX_GUI()
    
    def tearDown(self):
        """Clean up test environment"""
        self.app.destroy()
        self.root.destroy()
    
    def test_file_selection_validation(self):
        """Test file selection validation"""
        # Test empty file path
        self.app.file_path_var.set("")
        result = self.app.validate_inputs()
        self.assertFalse(result)
        
        # Test valid file path
        self.app.file_path_var.set("test.rbxl")
        with patch('os.path.exists', return_value=True):
            result = self.app.validate_inputs()
            self.assertTrue(result)
    
    @patch('tkinter.filedialog.askopenfilename')
    def test_browse_file_dialog(self, mock_dialog):
        """Test file browse dialog"""
        mock_dialog.return_value = "/path/to/test.rbxl"
        
        self.app.browse_file()
        
        # Verify file path was set
        self.assertEqual(self.app.file_path_var.get(), "/path/to/test.rbxl")
        
        # Verify dialog was called with correct parameters
        mock_dialog.assert_called_once()
        call_args = mock_dialog.call_args[1]
        self.assertIn("filetypes", call_args)
```

### Manual Testing Checklist
```markdown
## GUI Testing Checklist

### File Selection
- [ ] Browse button opens native file dialog
- [ ] File path displays correctly in entry field
- [ ] Invalid file types show appropriate error
- [ ] File path persists between sessions

### Export Mode Selection
- [ ] Radio buttons are mutually exclusive
- [ ] Mode descriptions update correctly
- [ ] Conditional options appear/disappear as expected
- [ ] Last selected mode is remembered

### Directory Management
- [ ] Default directories can be set and persist
- [ ] Last used directories are remembered
- [ ] Directory dialogs open to intelligent locations
- [ ] Invalid directories show error messages

### Export Process
- [ ] Export button is disabled during processing
- [ ] Status updates appear during export
- [ ] Success/failure messages are clear
- [ ] Output directory opens automatically on success

### Cross-Platform
- [ ] Native styling applies correctly
- [ ] File dialogs use platform conventions
- [ ] Keyboard shortcuts work as expected
- [ ] High DPI displays render correctly
```

## 🚀 Future GUI Enhancements

### 1. Modern Material Design
```python
# Material Design color palette
MATERIAL_COLORS = {
    'primary': '#1976D2',
    'primary_dark': '#1565C0',
    'accent': '#FF4081',
    'background': '#FAFAFA',
    'surface': '#FFFFFF',
    'error': '#F44336',
    'text_primary': '#212121',
    'text_secondary': '#757575'
}

class MaterialStyle:
    """Material Design styling for tkinter"""
    
    def apply_material_theme(self, root):
        style = ttk.Style()
        
        # Configure button styles
        style.configure('Material.TButton',
                       background=MATERIAL_COLORS['primary'],
                       foreground='white',
                       borderwidth=0,
                       focuscolor='none',
                       padding=(16, 8))
        
        # Configure frame styles
        style.configure('Material.TFrame',
                       background=MATERIAL_COLORS['surface'],
                       relief='flat')
```

### 2. Dark Mode Support
```python
class ThemeManager:
    """Dynamic theme switching with system integration"""
    
    def __init__(self, gui_instance):
        self.gui = gui_instance
        self.current_theme = "system"
        self.detect_system_theme()
    
    def detect_system_theme(self):
        """Detect system dark/light mode preference"""
        try:
            if platform.system() == "Darwin":
                # macOS dark mode detection
                result = subprocess.run(['defaults', 'read', '-g', 'AppleInterfaceStyle'], 
                                      capture_output=True, text=True)
                return "dark" if result.returncode == 0 else "light"
            elif platform.system() == "Windows":
                # Windows dark mode detection
                import winreg
                key = winreg.OpenKey(winreg.HKEY_CURRENT_USER, 
                                   r"Software\Microsoft\Windows\CurrentVersion\Themes\Personalize")
                value = winreg.QueryValueEx(key, "AppsUseLightTheme")[0]
                return "light" if value else "dark"
        except:
            pass
        return "light"  # Default fallback
```

### 3. Accessibility Enhancements
```python
class AccessibilityManager:
    """Accessibility features for inclusive design"""
    
    def __init__(self, gui_instance):
        self.gui = gui_instance
        self.setup_accessibility()
    
    def setup_accessibility(self):
        """Configure accessibility features"""
        # Keyboard navigation
        self.setup_keyboard_navigation()
        
        # Screen reader support
        self.setup_screen_reader_support()
        
        # High contrast mode
        self.setup_high_contrast()
    
    def setup_keyboard_navigation(self):
        """Enable comprehensive keyboard navigation"""
        # Tab order configuration
        widgets = [
            self.gui.browse_button,
            self.gui.rojo_radiobutton,
            self.gui.scripts_radiobutton,
            self.gui.export_button
        ]
        
        for i, widget in enumerate(widgets):
            widget.bind('<Tab>', lambda e, next_widget=widgets[(i+1) % len(widgets)]: 
                       next_widget.focus())
        
        # Keyboard shortcuts
        self.gui.bind('<Control-o>', lambda e: self.gui.browse_file())
        self.gui.bind('<Control-Return>', lambda e: self.gui.run_export())
```

This comprehensive GUI documentation provides the foundation for AI-assisted development, enabling efficient enhancement and maintenance of the LuneX interface across all platforms while maintaining usability and accessibility standards.
