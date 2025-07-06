
import tkinter as tk
from tkinter import filedialog, messagebox, ttk
import subprocess
import os
import platform
import json
import sys

# --- Configuration Management ---
CONFIG_FILE = "lunex_config.json"

def load_config():
    """Load configuration from file."""
    default_config = {
        "last_source_dir": os.path.expanduser("~"),
        "last_dest_dir": os.path.expanduser("~"),
        "default_source_dir": "",
        "default_dest_dir": "",
        "last_export_mode": "rojo"
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
        with open(CONFIG_FILE, 'w') as f:
            json.dump(config, f, indent=2)
    except Exception as e:
        print(f"Error saving config: {e}")

# --- Core Export Logic ---
def run_lune_export(input_file, output_dir, export_mode, create_project_json=False):
    """
    Execute the Lune.py script with the specified parameters.
    """
    try:
        # Build the command
        cmd = [sys.executable, "Lune.py", input_file, output_dir, "--mode", export_mode]
        
        if export_mode == "scripts-only" and create_project_json:
            cmd.append("--project-json")
        
        # Execute the command
        result = subprocess.run(cmd, capture_output=True, text=True, cwd=os.path.dirname(os.path.abspath(__file__)))
        
        if result.returncode == 0:
            return True, f"Export completed successfully!\n\nOutput: {output_dir}"
        else:
            return False, f"Export failed!\n\nError: {result.stderr}"
            
    except Exception as e:
        return False, f"Failed to execute Lune.py: {str(e)}"


# --- GUI Application ---

class LuneX_GUI(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("LuneX - Roblox Export Tool")
        self.geometry("600x500")
        self.resizable(False, False)
        
        # Load configuration
        self.config = load_config()

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

        # --- File Selection ---
        file_frame = ttk.LabelFrame(main_frame, text="1. Select .rbxl File", padding="10")
        file_frame.pack(fill=tk.X, pady=10)

        self.file_path_var = tk.StringVar()
        file_entry = ttk.Entry(file_frame, textvariable=self.file_path_var, width=60, state="readonly")
        file_entry.pack(side=tk.LEFT, fill=tk.X, expand=True, padx=(0, 10))

        browse_button = ttk.Button(file_frame, text="Browse...", command=self.browse_file)
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

        # Status
        self.status_var = tk.StringVar(value="Ready")
        status_label = ttk.Label(main_frame, textvariable=self.status_var, font=('Helvetica', 9))
        status_label.pack(pady=10)

    def browse_file(self):
        initial_dir = self.config.get("default_source_dir") or self.config.get("last_source_dir", os.path.expanduser("~"))
        file_path = filedialog.askopenfilename(
            title="Select a Roblox Place File",
            initialdir=initial_dir,
            filetypes=(("Roblox Place Files", "*.rbxl"), ("All files", "*.*"))
        )
        if file_path:
            self.file_path_var.set(file_path)
            # Update last source directory
            self.config["last_source_dir"] = os.path.dirname(file_path)
            save_config(self.config)

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
        rbxl_path = self.file_path_var.get()
        export_mode = self.export_mode_var.get()

        if not rbxl_path:
            messagebox.showerror("Error", "Please select a .rbxl file first.")
            return

        # Ask for output directory
        initial_dir = self.config.get("default_dest_dir") or self.config.get("last_dest_dir", os.path.expanduser("~"))
        output_dir = filedialog.askdirectory(title="Select Output Directory", initialdir=initial_dir)
        if not output_dir:
            return

        # Update last destination directory
        self.config["last_dest_dir"] = output_dir
        self.config["last_export_mode"] = export_mode
        save_config(self.config)

        # Update status
        self.status_var.set("Exporting...")
        self.update()

        try:
            # Run the export
            create_project_json = self.create_project_json_var.get() if export_mode == "scripts-only" else False
            success, message = run_lune_export(rbxl_path, output_dir, export_mode, create_project_json)
            
            if success:
                messagebox.showinfo("Success", message)
                self.status_var.set("Export completed successfully")
                
                # Open the output directory
                if platform.system() == "Windows":
                    os.startfile(output_dir)
                elif platform.system() == "Darwin":  # macOS
                    subprocess.Popen(["open", output_dir])
                else:  # Linux
                    subprocess.Popen(["xdg-open", output_dir])
            else:
                messagebox.showerror("Export Failed", message)
                self.status_var.set("Export failed")

        except Exception as e:
            messagebox.showerror("Export Failed", f"An unexpected error occurred:\n{e}")
            self.status_var.set("Export failed")


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
