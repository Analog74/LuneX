import tkinter as tk
from tkinter import filedialog, messagebox, ttk
import subprocess
import os
import platform
import json
import sys

try:
    from tkinterdnd2 import DND_FILES, TkinterDnD
except ImportError:
    print("tkinterdnd2 not found. Attempting to install...")
    try:
        # Ensure pip is available
        subprocess.check_call([sys.executable, "-m", "ensurepip"])
        # Install tkinterdnd2
        subprocess.check_call([sys.executable, "-m", "pip", "install", "tkinterdnd2"])
        from tkinterdnd2 import DND_FILES, TkinterDnD
        print("tkinterdnd2 installed successfully.")
    except Exception as e:
        messagebox.showerror(
            "Missing Dependency",
            f"Failed to install tkinterdnd2: {e}\n\nPlease install it manually:\npip install tkinterdnd2"
        )
        sys.exit(1)


# --- Configuration Management ---
CONFIG_DIR = "config"
CONFIG_FILE = os.path.join(CONFIG_DIR, "lunex_config.json")

def load_config():
    """Load configuration from file."""
    default_config = {
        "last_source_dir": os.path.expanduser("~"),
        "last_dest_dir": os.path.expanduser("~"),
        "default_source_dir": "",
        "default_dest_dir": "",
        "last_export_mode": "rojo",
        "recent_files": []
    }
    
    if os.path.exists(CONFIG_FILE):
        try:
            with open(CONFIG_FILE, 'r') as f:
                config = json.load(f)
                # Merge with defaults to handle missing keys
                for key in default_config:
                    if key not in config:
                        config[key] = default_config[key]
                return config
        except Exception as e:
            print(f"Error loading config: {e}")
    
    return default_config

def save_config(config):
    """Save configuration to file."""
    try:
        if not os.path.exists(CONFIG_DIR):
            os.makedirs(CONFIG_DIR)
        with open(CONFIG_FILE, 'w') as f:
            json.dump(config, f, indent=2)
    except Exception as e:
        print(f"Error saving config: {e}")

# --- Core Export Logic ---
def run_lune_export(input_file, output_dir, export_mode, create_project_json=False):
    """
    Execute the Lune.py script and yield progress updates.
    """
    try:
        # Build the command
        cmd = [sys.executable, "Lune.py", input_file, output_dir, "--mode", export_mode]
        
        if export_mode == "scripts-only" and create_project_json:
            cmd.append("--project-json")
        
        # Execute the command using Popen for real-time output
        process = subprocess.Popen(
            cmd, 
            stdout=subprocess.PIPE, 
            stderr=subprocess.PIPE, 
            text=True, 
            bufsize=1, 
            universal_newlines=True, 
            cwd=os.path.dirname(os.path.abspath(__file__))
        )
        
        # Read stdout line by line
        for line in iter(process.stdout.readline, ''):
            if line.startswith("PROGRESS:"):
                try:
                    _, percentage, message = line.strip().split(':', 2)
                    yield int(percentage), message
                except ValueError:
                    print(f"Warning: Could not parse progress line: {line.strip()}")
            else:
                # Yield other output for logging if needed
                yield None, line.strip()

        process.wait()
        
        if process.returncode != 0:
            error_output = process.stderr.read()
            yield -1, f"Export failed!\n\nError: {error_output}"
            
    except Exception as e:
        yield -1, f"Failed to execute Lune.py: {str(e)}"


# --- GUI Application ---

class LuneX_GUI(TkinterDnD.Tk):
    def __init__(self):
        super().__init__()
        self.title("LuneX - Roblox Export Tool")
        self.geometry("600x550")
        self.resizable(False, False)
        
        # Load configuration
        self.config = load_config()

        # --- Menu Bar ---
        self.menu_bar = tk.Menu(self)
        self.config(menu=self.menu_bar)

        # File Menu
        self.file_menu = tk.Menu(self.menu_bar, tearoff=0)
        self.menu_bar.add_cascade(label="File", menu=self.file_menu)
        self.file_menu.add_command(label="Open File...", command=self.browse_file)

        # Recent Files Submenu
        self.recent_files_menu = tk.Menu(self.file_menu, tearoff=0)
        self.file_menu.add_cascade(label="Recent Files", menu=self.recent_files_menu)
        
        self.file_menu.add_separator()
        self.file_menu.add_command(label="Quit", command=self.quit)

        self.update_recent_files_menu()

        # Help Menu
        self.help_menu = tk.Menu(self.menu_bar, tearoff=0)
        self.menu_bar.add_cascade(label="Help", menu=self.help_menu)
        self.help_menu.add_command(label="View Documentation", command=self.open_documentation)
        self.help_menu.add_command(label="About LuneX", command=self.show_about)


        # Style
        self.style = ttk.Style(self)
        if platform.system() == "Darwin":
            self.style.theme_use('aqua')
        else:
            self.style.theme_use('clam')

        # Main frame with scrollable content
        main_frame = ttk.Frame(self, padding="20")
        main_frame.pack(fill=tk.BOTH, expand=True)

        # Title
        title_label = ttk.Label(main_frame, text="LuneX - Roblox Export Tool", font=('Helvetica', 16, 'bold'))
        title_label.pack(pady=(0, 20))

        # --- File Selection (with Drag & Drop) ---
        file_frame = ttk.LabelFrame(main_frame, text="1. Select File or Drag & Drop Here", padding="10")
        file_frame.pack(fill=tk.X, pady=10)

        # Register as a drop target
        file_frame.drop_target_register(DND_FILES)
        file_frame.dnd_bind('<<Drop>>', self.on_drop)

        # Can store single path or multiple paths
        self.file_paths = []
        self.file_path_var = tk.StringVar()
        file_entry = ttk.Entry(file_frame, textvariable=self.file_path_var, width=60, state="readonly")
        file_entry.pack(side=tk.LEFT, fill=tk.X, expand=True, padx=(0, 10))

        browse_button = ttk.Button(file_frame, text="Browse...", command=self.browse_files)
        browse_button.pack(side=tk.RIGHT)

        # --- Export Mode Selection ---
        mode_frame = ttk.LabelFrame(main_frame, text="2. Choose Export Mode", padding="10")
        mode_frame.pack(fill=tk.X, pady=10)

        self.export_mode_var = tk.StringVar(value=self.config.get("last_export_mode", "rojo"))
        
        # Rojo mode
        rojo_frame = ttk.Frame(mode_frame)
        rojo_frame.pack(fill=tk.X, pady=5)
        rojo_rb = ttk.Radiobutton(rojo_frame, text="Rojo-Ready Export", variable=self.export_mode_var, value="rojo")
        rojo_rb.pack(side=tk.LEFT)
        rojo_desc = ttk.Label(rojo_frame, text="(Full project structure with default.project.json)", font=('Helvetica', 9))
        rojo_desc.pack(side=tk.LEFT, padx=(10, 0))

        # Scripts-only mode
        scripts_frame = ttk.Frame(mode_frame)
        scripts_frame.pack(fill=tk.X, pady=5)
        scripts_rb = ttk.Radiobutton(scripts_frame, text="Scripts-Only Export", variable=self.export_mode_var, value="scripts-only")
        scripts_rb.pack(side=tk.LEFT)
        scripts_desc = ttk.Label(scripts_frame, text="(All scripts in single directory with metadata)", font=('Helvetica', 9))
        scripts_desc.pack(side=tk.LEFT, padx=(10, 0))

        # Scripts-only options
        self.create_project_json_var = tk.BooleanVar(value=False)
        project_json_cb = ttk.Checkbutton(scripts_frame, text="Create default.project.json", variable=self.create_project_json_var)
        project_json_cb.pack(side=tk.RIGHT)

        # --- Directory Settings ---
        dir_frame = ttk.LabelFrame(main_frame, text="3. Directory Settings", padding="10")
        dir_frame.pack(fill=tk.X, pady=10)

        # Default directories
        default_frame = ttk.Frame(dir_frame)
        default_frame.pack(fill=tk.X, pady=5)
        
        ttk.Label(default_frame, text="Default Source:").pack(side=tk.LEFT)
        self.default_source_var = tk.StringVar(value=self.config.get("default_source_dir", ""))
        default_source_entry = ttk.Entry(default_frame, textvariable=self.default_source_var, width=30)
        default_source_entry.pack(side=tk.LEFT, padx=(5, 5))
        ttk.Button(default_frame, text="Set", command=self.set_default_source).pack(side=tk.LEFT)

        ttk.Label(default_frame, text=" Default Dest:").pack(side=tk.LEFT, padx=(10, 0))
        self.default_dest_var = tk.StringVar(value=self.config.get("default_dest_dir", ""))
        default_dest_entry = ttk.Entry(default_frame, textvariable=self.default_dest_var, width=30)
        default_dest_entry.pack(side=tk.LEFT, padx=(5, 5))
        ttk.Button(default_frame, text="Set", command=self.set_default_dest).pack(side=tk.LEFT)

        # --- Export Action ---
        export_frame = ttk.Frame(main_frame)
        export_frame.pack(fill=tk.X, pady=20)
        
        export_button = ttk.Button(export_frame, text="Export Project", command=self.run_export, style="Accent.TButton")
        export_button.pack(fill=tk.X, ipady=5)
        self.style.configure("Accent.TButton", font=('Helvetica', 12, 'bold'))

        # --- Progress Bar ---
        progress_frame = ttk.Frame(main_frame)
        progress_frame.pack(fill=tk.X, pady=10)

        self.progress_bar = ttk.Progressbar(progress_frame, orient="horizontal", length=100, mode="determinate")
        self.progress_bar.pack(fill=tk.X)

        self.progress_label_var = tk.StringVar(value="Ready")
        progress_label = ttk.Label(progress_frame, textvariable=self.progress_label_var, font=('Helvetica', 9))
        progress_label.pack(pady=5)


    def show_about(self):
        """Display the about dialog."""
        messagebox.showinfo(
            "About LuneX",
            "LuneX - Roblox Export Tool\nVersion: 1.2.0\n\n"
            "A professional utility for exporting Roblox .rbxl and .rbxlx files "
            "to organized, Rojo-compatible project structures."
        )

    def open_documentation(self):
        """Open the project's README.md file."""
        doc_path = os.path.abspath("README.md")
        try:
            if platform.system() == "Windows":
                os.startfile(doc_path)
            elif platform.system() == "Darwin":  # macOS
                subprocess.Popen(["open", doc_path])
            else:  # Linux
                subprocess.Popen(["xdg-open", doc_path])
        except Exception as e:
            messagebox.showerror("Error", f"Could not open documentation file: {e}")

    def update_recent_files_menu(self):
        self.recent_files_menu.delete(0, tk.END) # Clear existing items
        recent_files = self.config.get("recent_files", [])
        for path in recent_files:
            # Use a lambda to capture the path for the command
            self.recent_files_menu.add_command(
                label=os.path.basename(path), 
                command=lambda p=path: self.load_file_from_path(p)
            )
        if not recent_files:
            self.recent_files_menu.add_command(label="(No recent files)", state="disabled")

    def add_to_recent_files(self, file_path):
        if not file_path:
            return
        
        recent_files = self.config.get("recent_files", [])
        
        # Remove if already exists to move it to the top
        if file_path in recent_files:
            recent_files.remove(file_path)
        
        # Add to the top of the list
        recent_files.insert(0, file_path)
        
        # Limit to 10 recent files
        self.config["recent_files"] = recent_files[:10]
        
        save_config(self.config)
        self.update_recent_files_menu()

    def load_file_from_path(self, file_path):
        if os.path.isfile(file_path) and file_path.lower().endswith(('.rbxl', '.rbxlx')):
            self.file_path_var.set(file_path)
            self.config["last_source_dir"] = os.path.dirname(file_path)
            self.add_to_recent_files(file_path)
            self.progress_label_var.set(f"Loaded: {os.path.basename(file_path)}")
        else:
            messagebox.showwarning("Invalid File", f"Could not find or open file: {file_path}")
            # Optionally remove from recent files if it's invalid
            if file_path in self.config.get("recent_files", []):
                self.config["recent_files"].remove(file_path)
                save_config(self.config)
                self.update_recent_files_menu()
            self.progress_label_var.set("Ready")

    def on_drop(self, event):
        """Handle file drop events."""
        # The event data is a string of file paths, use splitlist to handle them
        filepaths = self.tk.splitlist(event.data)
        if filepaths:
            # Accept multiple files
            valid = [f for f in filepaths if os.path.isfile(f) and f.lower().endswith(('.rbxl', '.rbxlx'))]
            if valid:
                self.file_paths = valid
                display = (os.path.basename(valid[0]) + (f" (+{len(valid)-1} more)" if len(valid)>1 else ''))
                self.file_path_var.set(display)
                for f in valid:
                    self.add_to_recent_files(f)
                self.progress_label_var.set(f"Loaded {len(valid)} files")
            else:
                messagebox.showwarning("Invalid File", "Please drop .rbxl or .rbxlx files.")
                self.progress_label_var.set("Ready")

    def browse_files(self):
        initial_dir = self.config.get("default_source_dir") or self.config.get("last_source_dir", os.path.expanduser("~"))
        filepaths = filedialog.askopenfilenames(
            title="Select a Roblox Place File",
            initialdir=initial_dir,
            filetypes=(("Roblox Place Files", "*.rbxl *.rbxlx"), ("All files", "*.*"))
        )
        if filepaths:
            self.file_paths = list(filepaths)
            display = (os.path.basename(self.file_paths[0]) + (f" (+{len(self.file_paths)-1} more)" if len(self.file_paths)>1 else ''))
            self.file_path_var.set(display)
            for f in self.file_paths:
                self.add_to_recent_files(f)
            self.progress_label_var.set(f"Loaded {len(self.file_paths)} files")

    def set_default_source(self):
        dir_path = filedialog.askdirectory(title="Select Default Source Directory")
        if dir_path:
            self.default_source_var.set(dir_path)
            self.config["default_source_dir"] = dir_path
            save_config(self.config)

    def set_default_dest(self):
        dir_path = filedialog.askdirectory(title="Select Default Destination Directory")
        if dir_path:
            self.default_dest_var.set(dir_path)
            self.config["default_dest_dir"] = dir_path
            save_config(self.config)

    def run_export(self):
        export_mode = self.export_mode_var.get()

        if not self.file_paths:
            messagebox.showerror("Error", "Please select one or more .rbxl files first.")
            return

        # Ask for output directory
        initial_dir = self.config.get("default_dest_dir") or self.config.get("last_dest_dir", os.path.expanduser("~"))
        output_dir = filedialog.askdirectory(title="Select Output Directory", initialdir=initial_dir)
        if not output_dir:
            return

        self.config["last_dest_dir"] = output_dir
        self.config["last_export_mode"] = export_mode
        save_config(self.config)

        # Reset progress bar and update status
        self.progress_bar["value"] = 0
        self.progress_label_var.set("Starting batch export...")
        self.update_idletasks()

        try:
            create_project_json = self.create_project_json_var.get() if export_mode == "scripts-only" else False
            
            # Batch export multiple files sequentially
            all_success = True
            for idx, input_file in enumerate(self.file_paths, start=1):
                filename = os.path.basename(input_file)
                self.progress_label_var.set(f"[File {idx}/{len(self.file_paths)}] {filename}")
                for percentage, message in run_lune_export(input_file, output_dir, export_mode, create_project_json):
                    if percentage is not None and percentage >= 0:
                        self.progress_bar["value"] = percentage
                        self.progress_label_var.set(f"{filename}: {message}")
                        self.update_idletasks()
                    elif percentage == -1:
                        all_success = False
                        self.progress_bar["value"] = 100
                        self.progress_label_var.set(f"{filename}: Failed")
                        break
                if not all_success:
                    break
            
            # Finalize batch
            if all_success:
                messagebox.showinfo("Success", f"All {len(self.file_paths)} files exported successfully to {output_dir}")
                self.progress_label_var.set("Batch export complete!")
            else:
                messagebox.showerror("Batch Export Failed", f"Error exporting {filename}. See console for details.")

        except Exception as e:
            messagebox.showerror("Export Failed", f"An unexpected error occurred:\n{e}")
            self.progress_label_var.set("Export failed with an unexpected error.")
            self.style.configure("red.Horizontal.TProgressbar", background='red')
            self.progress_bar.configure(style="red.Horizontal.TProgressbar")


if __name__ == "__main__":
    # Check if Lune.py exists
    if not os.path.exists("Lune.py"):
        messagebox.showerror(
            "Missing Dependency", 
            "Lune.py not found in the current directory.\n"
            "Please ensure Lune.py is in the same folder as LuneX.py"
        )
        sys.exit(1)
    
    app = LuneX_GUI()
    app.mainloop()
