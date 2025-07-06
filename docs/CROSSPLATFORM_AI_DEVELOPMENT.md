# LuneX Cross-Platform & AI Development Guide

## 🌐 Cross-Platform Development Excellence

This comprehensive guide covers cross-platform compatibility, AI-assisted development strategies, and best practices for maintaining LuneX across Windows, macOS, and Linux environments.

## 🏗️ Cross-Platform Architecture Strategy

### Platform Detection & Adaptation Framework

```python
import platform
import sys
import os
from pathlib import Path

class PlatformManager:
    """
    Centralized platform detection and adaptation system
    """
    
    def __init__(self):
        self.system = platform.system()
        self.release = platform.release()
        self.version = platform.version()
        self.machine = platform.machine()
        self.python_version = sys.version_info
        
    def is_windows(self):
        return self.system == "Windows"
    
    def is_macos(self):
        return self.system == "Darwin"
    
    def is_linux(self):
        return self.system == "Linux"
    
    def is_unix_like(self):
        return self.system in ["Darwin", "Linux"]
    
    def get_platform_config(self):
        """
        Get platform-specific configuration
        """
        configs = {
            "Windows": {
                "executable_extension": ".exe",
                "path_separator": "\\",
                "line_ending": "\r\n",
                "home_var": "USERPROFILE",
                "temp_dir": "TEMP",
                "shell": "cmd",
                "file_manager": "explorer",
                "default_theme": "winnative"
            },
            "Darwin": {  # macOS
                "executable_extension": "",
                "path_separator": "/",
                "line_ending": "\n",
                "home_var": "HOME",
                "temp_dir": "TMPDIR",
                "shell": "zsh",
                "file_manager": "open",
                "default_theme": "aqua"
            },
            "Linux": {
                "executable_extension": "",
                "path_separator": "/", 
                "line_ending": "\n",
                "home_var": "HOME",
                "temp_dir": "TMPDIR",
                "shell": "bash",
                "file_manager": "xdg-open",
                "default_theme": "clam"
            }
        }
        
        return configs.get(self.system, configs["Linux"])  # Default to Linux
    
    def get_executable_name(self, base_name):
        """
        Get platform-specific executable name
        """
        config = self.get_platform_config()
        return base_name + config["executable_extension"]
    
    def normalize_path(self, path):
        """
        Normalize path for current platform
        """
        return os.path.normpath(path)
    
    def get_user_home(self):
        """
        Get user home directory across platforms
        """
        return Path.home()
    
    def get_app_data_dir(self, app_name):
        """
        Get platform-appropriate application data directory
        """
        if self.is_windows():
            # Windows: %APPDATA%\AppName
            appdata = os.environ.get("APPDATA", "")
            return os.path.join(appdata, app_name)
        elif self.is_macos():
            # macOS: ~/Library/Application Support/AppName
            return os.path.join(self.get_user_home(), "Library", "Application Support", app_name)
        else:
            # Linux: ~/.config/AppName
            config_home = os.environ.get("XDG_CONFIG_HOME", os.path.join(self.get_user_home(), ".config"))
            return os.path.join(config_home, app_name)

# Global platform manager instance
platform_manager = PlatformManager()
```

### File System Abstractions

```python
class CrossPlatformFileSystem:
    """
    File system operations with cross-platform compatibility
    """
    
    @staticmethod
    def safe_join(*paths):
        """
        Safely join paths across platforms
        """
        return os.path.normpath(os.path.join(*paths))
    
    @staticmethod
    def ensure_executable(file_path):
        """
        Ensure file is executable (Unix systems only)
        """
        if platform_manager.is_unix_like():
            try:
                import stat
                current_mode = os.stat(file_path).st_mode
                os.chmod(file_path, current_mode | stat.S_IEXEC)
                return True
            except Exception as e:
                print(f"Warning: Could not make {file_path} executable: {e}")
                return False
        return True  # Windows doesn't need explicit executable permission
    
    @staticmethod
    def find_executable(name):
        """
        Find executable in PATH, handling platform differences
        """
        executable_name = platform_manager.get_executable_name(name)
        
        # Check current directory first
        local_path = os.path.join(".", executable_name)
        if os.path.exists(local_path):
            return os.path.abspath(local_path)
        
        # Search PATH
        for path_dir in os.environ.get("PATH", "").split(os.pathsep):
            if not path_dir:
                continue
            
            executable_path = os.path.join(path_dir, executable_name)
            if os.path.exists(executable_path):
                return executable_path
        
        return None
    
    @staticmethod
    def open_file_manager(directory):
        """
        Open directory in platform-native file manager
        """
        config = platform_manager.get_platform_config()
        file_manager = config["file_manager"]
        
        try:
            if platform_manager.is_windows():
                os.startfile(directory)
            elif platform_manager.is_macos():
                subprocess.run([file_manager, directory], check=True)
            else:  # Linux
                # Try multiple file managers
                file_managers = ["xdg-open", "nautilus", "dolphin", "thunar", "nemo"]
                for fm in file_managers:
                    try:
                        subprocess.run([fm, directory], check=True)
                        break
                    except (subprocess.CalledProcessError, FileNotFoundError):
                        continue
                else:
                    print(f"Could not open file manager. Directory: {directory}")
                    
        except Exception as e:
            print(f"Error opening file manager: {e}")
    
    @staticmethod
    def get_temp_directory():
        """
        Get platform-appropriate temporary directory
        """
        if platform_manager.is_windows():
            return os.environ.get("TEMP", os.path.join(os.environ.get("USERPROFILE", ""), "AppData", "Local", "Temp"))
        else:
            return os.environ.get("TMPDIR", "/tmp")
    
    @staticmethod
    def create_desktop_shortcut(name, target_path, description=""):
        """
        Create desktop shortcut (platform-specific)
        """
        if platform_manager.is_windows():
            return CrossPlatformFileSystem._create_windows_shortcut(name, target_path, description)
        elif platform_manager.is_macos():
            return CrossPlatformFileSystem._create_macos_shortcut(name, target_path, description)
        else:
            return CrossPlatformFileSystem._create_linux_shortcut(name, target_path, description)
    
    @staticmethod
    def _create_windows_shortcut(name, target_path, description):
        """Create Windows .lnk shortcut"""
        try:
            import win32com.client
            
            desktop = os.path.join(os.environ["USERPROFILE"], "Desktop")
            shortcut_path = os.path.join(desktop, f"{name}.lnk")
            
            shell = win32com.client.Dispatch("WScript.Shell")
            shortcut = shell.CreateShortCut(shortcut_path)
            shortcut.Targetpath = target_path
            shortcut.Description = description
            shortcut.save()
            
            return True
        except ImportError:
            print("pywin32 not available for shortcut creation")
            return False
        except Exception as e:
            print(f"Error creating Windows shortcut: {e}")
            return False
    
    @staticmethod
    def _create_macos_shortcut(name, target_path, description):
        """Create macOS alias/shortcut"""
        try:
            desktop = os.path.join(platform_manager.get_user_home(), "Desktop")
            shortcut_path = os.path.join(desktop, f"{name}.command")
            
            with open(shortcut_path, 'w') as f:
                f.write(f"#!/bin/bash\n")
                f.write(f"# {description}\n")
                f.write(f"cd \"{os.path.dirname(target_path)}\"\n")
                f.write(f"python3 \"{os.path.basename(target_path)}\"\n")
            
            CrossPlatformFileSystem.ensure_executable(shortcut_path)
            return True
            
        except Exception as e:
            print(f"Error creating macOS shortcut: {e}")
            return False
    
    @staticmethod
    def _create_linux_shortcut(name, target_path, description):
        """Create Linux .desktop file"""
        try:
            desktop = os.path.join(platform_manager.get_user_home(), "Desktop")
            shortcut_path = os.path.join(desktop, f"{name}.desktop")
            
            desktop_content = f"""[Desktop Entry]
Version=1.0
Type=Application
Name={name}
Comment={description}
Exec=python3 "{target_path}"
Icon=python
Terminal=false
Categories=Development;
"""
            
            with open(shortcut_path, 'w') as f:
                f.write(desktop_content)
            
            CrossPlatformFileSystem.ensure_executable(shortcut_path)
            return True
            
        except Exception as e:
            print(f"Error creating Linux shortcut: {e}")
            return False
```

### GUI Cross-Platform Adaptations

```python
class CrossPlatformGUI:
    """
    GUI adaptations for different platforms
    """
    
    def __init__(self, root_window):
        self.root = root_window
        self.platform_config = platform_manager.get_platform_config()
        self.apply_platform_adaptations()
    
    def apply_platform_adaptations(self):
        """
        Apply platform-specific GUI adaptations
        """
        if platform_manager.is_windows():
            self._apply_windows_adaptations()
        elif platform_manager.is_macos():
            self._apply_macos_adaptations()
        else:
            self._apply_linux_adaptations()
    
    def _apply_windows_adaptations(self):
        """
        Windows-specific GUI adaptations
        """
        # Windows-specific styling
        style = ttk.Style()
        style.theme_use('winnative')
        
        # Windows expects more compact interfaces
        style.configure("TButton", padding=(8, 3))
        style.configure("TFrame", relief="flat")
        
        # Windows-specific keyboard shortcuts
        self.root.bind('<Alt-F4>', lambda e: self.root.quit())
        
        # Windows file dialog preferences
        self.file_dialog_options = {
            'defaultextension': '.rbxl',
            'filetypes': [
                ('Roblox Place Files', '*.rbxl'),
                ('Roblox XML Files', '*.rbxlx'),
                ('All Files', '*.*')
            ]
        }
    
    def _apply_macos_adaptations(self):
        """
        macOS-specific GUI adaptations
        """
        # macOS native styling
        style = ttk.Style()
        style.theme_use('aqua')
        
        # macOS expects larger click targets
        style.configure("TButton", padding=(12, 6))
        
        # macOS-specific keyboard shortcuts
        self.root.bind('<Cmd-q>', lambda e: self.root.quit())
        self.root.bind('<Cmd-w>', lambda e: self.root.quit())
        self.root.bind('<Cmd-o>', lambda e: self.browse_file())
        
        # macOS file dialog preferences
        self.file_dialog_options = {
            'defaultextension': '.rbxl',
            'filetypes': [
                ('Roblox Place Files', '*.rbxl'),
                ('Roblox XML Files', '*.rbxlx')
            ]
        }
        
        # macOS menu bar integration
        self._setup_macos_menu()
    
    def _apply_linux_adaptations(self):
        """
        Linux-specific GUI adaptations
        """
        # Detect desktop environment
        desktop_env = self._detect_linux_desktop()
        
        # Choose appropriate theme
        if desktop_env in ['gnome', 'unity']:
            theme = 'clam'
        elif desktop_env == 'kde':
            theme = 'alt'
        else:
            theme = 'default'
        
        style = ttk.Style()
        style.theme_use(theme)
        
        # Linux keyboard shortcuts
        self.root.bind('<Control-q>', lambda e: self.root.quit())
        self.root.bind('<Control-o>', lambda e: self.browse_file())
        
        # Linux file dialog preferences
        self.file_dialog_options = {
            'defaultextension': '.rbxl',
            'filetypes': [
                ('Roblox Place Files', '*.rbxl'),
                ('Roblox XML Files', '*.rbxlx'),
                ('All Files', '*.*')
            ]
        }
    
    def _detect_linux_desktop(self):
        """
        Detect Linux desktop environment
        """
        desktop_session = os.environ.get('DESKTOP_SESSION', '').lower()
        xdg_current_desktop = os.environ.get('XDG_CURRENT_DESKTOP', '').lower()
        
        if 'gnome' in desktop_session or 'gnome' in xdg_current_desktop:
            return 'gnome'
        elif 'kde' in desktop_session or 'kde' in xdg_current_desktop:
            return 'kde'
        elif 'xfce' in desktop_session:
            return 'xfce'
        elif 'unity' in desktop_session:
            return 'unity'
        else:
            return 'unknown'
    
    def _setup_macos_menu(self):
        """
        Set up native macOS menu bar
        """
        menubar = tk.Menu(self.root)
        self.root.config(menu=menubar)
        
        # Application menu
        app_menu = tk.Menu(menubar, tearoff=0)
        menubar.add_cascade(label="LuneX", menu=app_menu)
        app_menu.add_command(label="About LuneX", command=self.show_about)
        app_menu.add_separator()
        app_menu.add_command(label="Preferences...", command=self.show_preferences)
        app_menu.add_separator()
        app_menu.add_command(label="Quit LuneX", command=self.root.quit, accelerator="Cmd+Q")
        
        # File menu
        file_menu = tk.Menu(menubar, tearoff=0)
        menubar.add_cascade(label="File", menu=file_menu)
        file_menu.add_command(label="Open...", command=self.browse_file, accelerator="Cmd+O")
        file_menu.add_separator()
        file_menu.add_command(label="Export Project", command=self.run_export)
```

## 🤖 AI-Assisted Development Framework

### AI Prompt Engineering for LuneX

```python
class AIAssistantPrompts:
    """
    Standardized prompts for AI-assisted development
    """
    
    @staticmethod
    def get_code_analysis_prompt(code_snippet, context=""):
        """
        Generate prompt for code analysis
        """
        return f"""
        Analyze this LuneX code snippet:
        
        Context: {context}
        
        Code:
        ```python
        {code_snippet}
        ```
        
        Please provide:
        1. Code quality assessment
        2. Potential bugs or issues
        3. Performance improvements
        4. Cross-platform compatibility concerns
        5. Suggested refactoring opportunities
        6. Testing recommendations
        
        Focus on LuneX's architecture patterns and cross-platform requirements.
        """
    
    @staticmethod
    def get_feature_development_prompt(feature_description, existing_code=""):
        """
        Generate prompt for new feature development
        """
        return f"""
        Develop a new feature for LuneX:
        
        Feature: {feature_description}
        
        Existing Code Context:
        ```python
        {existing_code}
        ```
        
        Requirements:
        1. Follow LuneX architecture patterns
        2. Ensure cross-platform compatibility (Windows, macOS, Linux)
        3. Include comprehensive error handling
        4. Add appropriate logging and user feedback
        5. Write unit tests
        6. Document the implementation
        
        LuneX Tech Stack:
        - Python 3.7+ with tkinter
        - External tool integration (subprocess)
        - JSON configuration management
        - XML processing with ElementTree
        
        Provide complete implementation with:
        - Main feature code
        - Integration points
        - Test cases
        - Documentation
        """
    
    @staticmethod
    def get_debugging_prompt(error_description, stack_trace="", code_context=""):
        """
        Generate prompt for debugging assistance
        """
        return f"""
        Debug this LuneX issue:
        
        Error Description: {error_description}
        
        Stack Trace:
        ```
        {stack_trace}
        ```
        
        Code Context:
        ```python
        {code_context}
        ```
        
        Please provide:
        1. Root cause analysis
        2. Step-by-step debugging approach
        3. Potential fixes with code examples
        4. Prevention strategies
        5. Cross-platform considerations
        
        Consider LuneX's architecture and common issues with:
        - File format detection
        - External tool integration
        - Cross-platform file operations
        - GUI event handling
        """
    
    @staticmethod
    def get_refactoring_prompt(code_to_refactor, goals=""):
        """
        Generate prompt for code refactoring
        """
        return f"""
        Refactor this LuneX code:
        
        Goals: {goals}
        
        Current Code:
        ```python
        {code_to_refactor}
        ```
        
        Refactoring Objectives:
        1. Improve maintainability
        2. Enhance testability
        3. Better error handling
        4. Cross-platform compatibility
        5. Performance optimization
        6. Code readability
        
        Follow LuneX patterns:
        - Configuration-driven behavior
        - Comprehensive error handling
        - Platform abstraction
        - Modular design
        
        Provide:
        - Refactored code
        - Explanation of changes
        - Migration guide
        - Updated tests
        """

class AIDevelopmentWorkflow:
    """
    Structured workflow for AI-assisted development
    """
    
    def __init__(self):
        self.session_context = {
            "current_task": "",
            "code_changes": [],
            "test_results": [],
            "platform_tested": set()
        }
    
    def start_development_session(self, task_description):
        """
        Initialize AI development session
        """
        self.session_context["current_task"] = task_description
        
        context_prompt = f"""
        Starting LuneX development session:
        
        Task: {task_description}
        
        Current LuneX State:
        - Architecture: GUI (LuneX.py) + Core Logic (Lune.py)
        - Platforms: Windows, macOS, Linux
        - Dependencies: Python 3.7+, tkinter, external Rust tools
        - Current Features: Binary .rbxl support, dual export modes, GUI + CLI
        
        Development Guidelines:
        1. Maintain cross-platform compatibility
        2. Follow existing architecture patterns
        3. Include comprehensive testing
        4. Update documentation
        5. Preserve backward compatibility
        
        Please confirm understanding and suggest development approach.
        """
        
        return context_prompt
    
    def document_code_change(self, file_path, change_description, code_diff=""):
        """
        Document code changes for AI context
        """
        change_record = {
            "file": file_path,
            "description": change_description,
            "diff": code_diff,
            "timestamp": time.time()
        }
        
        self.session_context["code_changes"].append(change_record)
    
    def generate_testing_prompt(self):
        """
        Generate comprehensive testing prompt
        """
        changes = self.session_context["code_changes"]
        
        prompt = f"""
        Generate tests for recent LuneX changes:
        
        Changes Made:
        """
        
        for change in changes[-5:]:  # Last 5 changes
            prompt += f"""
        - File: {change['file']}
        - Change: {change['description']}
        """
        
        prompt += f"""
        
        Testing Requirements:
        1. Unit tests for new/modified functions
        2. Integration tests for workflows
        3. Cross-platform compatibility tests
        4. Error handling validation
        5. Performance regression tests
        
        Test Framework: Python unittest
        Mock Strategy: unittest.mock for external dependencies
        
        Provide:
        - Complete test suite
        - Test data setup/teardown
        - Platform-specific test cases
        - Performance benchmarks
        """
        
        return prompt
    
    def generate_documentation_prompt(self):
        """
        Generate documentation update prompt
        """
        changes = self.session_context["code_changes"]
        
        prompt = f"""
        Update LuneX documentation for recent changes:
        
        Task: {self.session_context['current_task']}
        
        Code Changes:
        """
        
        for change in changes:
            prompt += f"""
        - {change['file']}: {change['description']}
        """
        
        prompt += f"""
        
        Documentation to Update:
        1. README.md - User-facing changes
        2. ARCHITECTURE.md - Technical changes
        3. API documentation - New/modified functions
        4. User guides - Workflow changes
        5. Developer guides - Implementation details
        
        Documentation Style:
        - Clear, concise explanations
        - Code examples where appropriate
        - Cross-platform considerations
        - Troubleshooting sections
        
        Provide updated documentation sections.
        """
        
        return prompt
```

### Intelligent Code Generation Patterns

```python
class LuneXCodeGenerator:
    """
    AI-assisted code generation with LuneX patterns
    """
    
    @staticmethod
    def generate_converter_class(tool_name, command_pattern, description=""):
        """
        Generate converter class template
        """
        class_name = f"{tool_name.title().replace('-', '').replace('_', '')}Converter"
        
        template = f'''
class {class_name}(ConverterInterface):
    """
    {description or f"{tool_name} converter implementation"}
    """
    
    def can_convert(self, input_path):
        """
        Check if {tool_name} can handle this file
        """
        format_type, confidence, _ = detect_file_format(input_path)
        # TODO: Implement specific format requirements
        return confidence > 0.7
    
    def convert(self, input_path, output_path):
        """
        Convert using {tool_name}
        
        Command pattern: {command_pattern}
        """
        try:
            cmd = [self.tool_path] + {command_pattern}
            
            result = subprocess.run(
                cmd,
                capture_output=True,
                text=True,
                timeout=self.timeout
            )
            
            if result.returncode == 0 and os.path.exists(output_path):
                return True, output_path
            else:
                print(f"{tool_name} conversion failed")
                if result.stderr:
                    print(f"Error: {{result.stderr}}")
                return False, None
                
        except subprocess.TimeoutExpired:
            print(f"{tool_name} conversion timed out")
            return False, None
        except Exception as e:
            print(f"{tool_name} error: {{e}}")
            return False, None
    
    def get_version(self):
        """Get {tool_name} version"""
        try:
            result = subprocess.run([self.tool_path, '--version'], 
                                  capture_output=True, text=True, timeout=5)
            return result.stdout.strip() if result.returncode == 0 : "unknown"
        except:
            return "unknown"
'''
        
        return template
    
    @staticmethod
    def generate_export_mode_class(mode_name, description=""):
        """
        Generate export mode class template
        """
        class_name = f"{mode_name.title().replace('-', '').replace('_', '')}ExportMode"
        
        template = f'''
class {class_name}(ExportMode):
    """
    {description or f"{mode_name} export mode implementation"}
    """
    
    def export(self, root_object):
        """
        Export using {mode_name} mode
        """
        try:
            print(f"🔄 Starting {{mode_name}} export...")
            
            # TODO: Implement export logic
            self.process_object_hierarchy(root_object)
            
            print(f"✅ {{mode_name}} export completed")
            return True
            
        except Exception as e:
            print(f"❌ {{mode_name}} export failed: {{e}}")
            return False
    
    def process_object_hierarchy(self, obj, current_path=""):
        """
        Process object hierarchy for {mode_name} export
        """
        # TODO: Implement hierarchy processing
        for child in obj.children:
            child_path = os.path.join(current_path, child.name or child.class_name)
            
            if child.is_script():
                self.export_script(child, child_path)
            elif child.children:
                self.process_object_hierarchy(child, child_path)
    
    def export_script(self, script_obj, output_path):
        """
        Export individual script for {mode_name} mode
        """
        # TODO: Implement script export logic
        script_content = script_obj.properties.get("Source", "").value
        
        with open(output_path, 'w', encoding='utf-8') as f:
            f.write(script_content)
    
    def get_description(self):
        """Get human-readable description"""
        return "{description or f'Export using {mode_name} format'}"
'''
        
        return template
    
    @staticmethod
    def generate_test_class(target_class, test_scenarios=None):
        """
        Generate test class template
        """
        test_scenarios = test_scenarios or ["basic_functionality", "error_handling", "edge_cases"]
        
        test_class_name = f"Test{target_class}"
        
        template = f'''
import unittest
from unittest.mock import patch, MagicMock, mock_open

class {test_class_name}(unittest.TestCase):
    """
    Test cases for {target_class}
    """
    
    def setUp(self):
        """Set up test environment"""
        self.test_instance = {target_class}()
        
    def tearDown(self):
        """Clean up test environment"""
        pass
'''
        
        for scenario in test_scenarios:
            method_name = f"test_{scenario}"
            template += f'''
    
    def {method_name}(self):
        """Test {scenario.replace('_', ' ')}"""
        # TODO: Implement {scenario} test
        # Arrange
        
        # Act
        
        # Assert
        self.assertTrue(True)  # Placeholder
'''
        
        template += '''

if __name__ == '__main__':
    unittest.main()
'''
        
        return template
```

## 📊 Development Metrics & Quality Assurance

### Code Quality Monitoring

```python
class CodeQualityMonitor:
    """
    Automated code quality monitoring for AI assistance
    """
    
    def __init__(self):
        self.metrics = {
            "complexity": {},
            "test_coverage": {},
            "performance": {},
            "cross_platform": {}
        }
    
    def analyze_function_complexity(self, function_code):
        """
        Analyze function complexity for AI recommendations
        """
        lines = function_code.split('\n')
        complexity_score = 0
        
        # Simple complexity metrics
        for line in lines:
            line = line.strip()
            if line.startswith(('if ', 'elif ', 'for ', 'while ', 'try:', 'except')):
                complexity_score += 1
            elif 'and ' in line or 'or ' in line:
                complexity_score += 0.5
        
        # Complexity assessment
        if complexity_score <= 5:
            assessment = "Low complexity - good maintainability"
        elif complexity_score <= 10:
            assessment = "Medium complexity - consider refactoring"
        else:
            assessment = "High complexity - refactoring recommended"
        
        return {
            "score": complexity_score,
            "assessment": assessment,
            "recommendations": self._get_complexity_recommendations(complexity_score)
        }
    
    def _get_complexity_recommendations(self, score):
        """
        Get AI-friendly complexity recommendations
        """
        if score <= 5:
            return ["Function complexity is acceptable", "Consider adding more comprehensive tests"]
        elif score <= 10:
            return [
                "Consider breaking function into smaller methods",
                "Extract complex conditions into separate functions",
                "Add inline documentation for complex logic"
            ]
        else:
            return [
                "High complexity detected - immediate refactoring recommended",
                "Break into multiple functions with single responsibilities",
                "Consider using design patterns (Strategy, Command, etc.)",
                "Add comprehensive unit tests before refactoring"
            ]
    
    def generate_quality_report(self, file_path):
        """
        Generate comprehensive quality report for AI analysis
        """
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            report = {
                "file": file_path,
                "lines_of_code": len(content.split('\n')),
                "functions": self._extract_functions(content),
                "imports": self._extract_imports(content),
                "complexity_issues": [],
                "cross_platform_issues": [],
                "recommendations": []
            }
            
            # Analyze each function
            for func_name, func_code in report["functions"].items():
                complexity = self.analyze_function_complexity(func_code)
                if complexity["score"] > 7:
                    report["complexity_issues"].append({
                        "function": func_name,
                        "score": complexity["score"],
                        "recommendations": complexity["recommendations"]
                    })
            
            # Check for cross-platform issues
            platform_issues = self._check_cross_platform_issues(content)
            report["cross_platform_issues"] = platform_issues
            
            # Generate overall recommendations
            report["recommendations"] = self._generate_recommendations(report)
            
            return report
            
        except Exception as e:
            return {"error": f"Could not analyze {file_path}: {e}"}
    
    def _extract_functions(self, code):
        """
        Extract functions from code for analysis
        """
        functions = {}
        lines = code.split('\n')
        current_function = None
        current_code = []
        indent_level = 0
        
        for line in lines:
            if line.strip().startswith('def '):
                if current_function:
                    functions[current_function] = '\n'.join(current_code)
                
                current_function = line.strip().split('(')[0].replace('def ', '')
                current_code = [line]
                indent_level = len(line) - len(line.lstrip())
            elif current_function:
                line_indent = len(line) - len(line.lstrip())
                if line.strip() and line_indent > indent_level:
                    current_code.append(line)
                elif line.strip() and line_indent <= indent_level:
                    functions[current_function] = '\n'.join(current_code)
                    current_function = None
                    current_code = []
                else:
                    current_code.append(line)
        
        if current_function:
            functions[current_function] = '\n'.join(current_code)
        
        return functions
    
    def _check_cross_platform_issues(self, code):
        """
        Check for potential cross-platform compatibility issues
        """
        issues = []
        
        # Check for hardcoded path separators
        if '\\\\' in code or code.count('\\') > code.count('os.path.join'):
            issues.append({
                "type": "hardcoded_paths",
                "description": "Hardcoded path separators detected",
                "recommendation": "Use os.path.join() or pathlib for cross-platform paths"
            })
        
        # Check for platform-specific imports
        platform_specific = ['win32', 'winreg', 'AppKit', 'Foundation']
        for module in platform_specific:
            if f"import {module}" in code:
                issues.append({
                    "type": "platform_specific_import",
                    "description": f"Platform-specific import: {module}",
                    "recommendation": f"Wrap {module} import in platform check"
                })
        
        # Check for subprocess without shell considerations
        if 'subprocess.' in code and 'shell=' not in code:
            issues.append({
                "type": "subprocess_shell",
                "description": "Subprocess calls without shell parameter consideration",
                "recommendation": "Consider shell parameter for cross-platform compatibility"
            })
        
        return issues
```

### AI Development Assistant Integration

```python
class AIIntegrationHelper:
    """
    Helper class for integrating AI development tools
    """
    
    def __init__(self):
        self.context_cache = {}
        self.session_history = []
    
    def prepare_context_for_ai(self, task_type, target_files=None):
        """
        Prepare comprehensive context for AI assistance
        """
        context = {
            "task_type": task_type,
            "timestamp": time.time(),
            "project_info": self._get_project_info(),
            "relevant_files": {},
            "architecture_overview": self._get_architecture_overview(),
            "recent_changes": self._get_recent_changes(),
            "testing_status": self._get_testing_status()
        }
        
        # Include relevant file contents
        if target_files:
            for file_path in target_files:
                context["relevant_files"][file_path] = self._get_file_context(file_path)
        
        return context
    
    def _get_project_info(self):
        """
        Get current project information
        """
        return {
            "name": "LuneX",
            "version": "1.1.0",
            "description": "Roblox .rbxl export tool with binary support",
            "tech_stack": ["Python 3.7+", "tkinter", "Rust tools", "XML processing"],
            "platforms": ["Windows", "macOS", "Linux"],
            "main_files": ["Lune.py", "LuneX.py", "test_lunex.py"],
            "external_tools": ["rbx-util", "rbxlx-to-rojo"],
            "dependencies": ["tkinter", "xml.etree.ElementTree", "subprocess", "json"]
        }
    
    def _get_architecture_overview(self):
        """
        Get architecture overview for AI context
        """
        return {
            "gui_layer": "LuneX.py - tkinter-based user interface",
            "core_logic": "Lune.py - file processing and export engine",
            "external_integration": "external-tools/ - Rust-based conversion tools",
            "configuration": "JSON-based persistent configuration",
            "testing": "unittest-based automated testing",
            "documentation": "Comprehensive markdown documentation",
            "design_patterns": [
                "Configuration-driven behavior",
                "Plugin-style converter architecture", 
                "Cross-platform abstraction",
                "Error-first design"
            ]
        }
    
    def generate_ai_development_prompt(self, task_description, context=None):
        """
        Generate comprehensive AI development prompt
        """
        context = context or self.prepare_context_for_ai("development")
        
        prompt = f"""
# LuneX Development Task

## Task Description
{task_description}

## Project Context
- **Project**: {context['project_info']['name']} v{context['project_info']['version']}
- **Description**: {context['project_info']['description']}
- **Platforms**: {', '.join(context['project_info']['platforms'])}
- **Tech Stack**: {', '.join(context['project_info']['tech_stack'])}

## Architecture Overview
{context['architecture_overview']['gui_layer']}
{context['architecture_overview']['core_logic']}
{context['architecture_overview']['external_integration']}

## Design Principles
"""
        
        for principle in context['architecture_overview']['design_patterns']:
            prompt += f"- {principle}\n"
        
        prompt += f"""

## Development Requirements
1. **Cross-Platform Compatibility**: Ensure code works on Windows, macOS, and Linux
2. **Error Handling**: Implement comprehensive error handling with user-friendly messages
3. **Testing**: Include unit tests for new functionality
4. **Documentation**: Update relevant documentation
5. **Architecture Consistency**: Follow existing patterns and conventions

## Relevant Files
"""
        
        for file_path, file_info in context.get('relevant_files', {}).items():
            prompt += f"### {file_path}\n"
            prompt += f"Purpose: {file_info.get('purpose', 'Core functionality')}\n"
            prompt += f"Key Functions: {', '.join(file_info.get('key_functions', []))}\n\n"
        
        prompt += """
## Expected Deliverables
1. Complete implementation code
2. Unit tests for new functionality
3. Documentation updates
4. Integration instructions
5. Cross-platform testing notes

Please provide a comprehensive solution following LuneX architecture patterns.
"""
        
        return prompt
    
    def parse_ai_response(self, ai_response):
        """
        Parse AI response and extract actionable components
        """
        components = {
            "code_blocks": [],
            "file_changes": [],
            "test_cases": [],
            "documentation": [],
            "instructions": []
        }
        
        # Simple parsing logic - in practice, would use more sophisticated parsing
        lines = ai_response.split('\n')
        current_section = None
        current_content = []
        
        for line in lines:
            if line.startswith('```python'):
                current_section = "code"
                current_content = []
            elif line.startswith('```'):
                if current_section == "code":
                    components["code_blocks"].append('\n'.join(current_content))
                current_section = None
                current_content = []
            elif current_section:
                current_content.append(line)
            elif line.startswith('## ') or line.startswith('### '):
                # Section headers
                section_name = line.replace('#', '').strip().lower()
                if 'test' in section_name:
                    current_section = "test"
                elif 'doc' in section_name:
                    current_section = "documentation"
                elif 'instruction' in section_name:
                    current_section = "instructions"
            elif current_section in ["test", "documentation", "instructions"]:
                current_content.append(line)
        
        return components
```

## 🚀 Deployment & Distribution Strategies

### Cross-Platform Package Building

```python
class CrossPlatformBuilder:
    """
    Automated building and packaging for multiple platforms
    """
    
    def __init__(self):
        self.build_configs = {
            "Windows": {
                "python_cmd": "python",
                "package_format": "exe",
                "dependencies": ["pyinstaller", "tkinter"],
                "build_script": "build_windows.bat"
            },
            "Darwin": {  # macOS
                "python_cmd": "python3",
                "package_format": "app",
                "dependencies": ["py2app", "tkinter"],
                "build_script": "build_macos.sh"
            },
            "Linux": {
                "python_cmd": "python3",
                "package_format": "appimage",
                "dependencies": ["PyInstaller", "tkinter"],
                "build_script": "build_linux.sh"
            }
        }
    
    def build_for_platform(self, platform):
        """
        Build LuneX package for specific platform
        """
        config = self.build_configs.get(platform)
        if not config:
            print(f"❌ Unsupported platform: {platform}")
            return False
        
        print(f"🔨 Building LuneX for {platform}...")
        
        try:
            # Build external tools first
            self._build_external_tools(platform)
            
            # Build Python application
            self._build_python_app(platform, config)
            
            # Package everything
            self._create_package(platform, config)
            
            print(f"✅ Successfully built LuneX for {platform}")
            return True
            
        except Exception as e:
            print(f"❌ Build failed for {platform}: {e}")
            return False
    
    def _build_external_tools(self, platform):
        """
        Build Rust-based external tools for platform
        """
        rust_projects = [
            "external-tools/rojo-ecosystem/rbx-dom",
            "external-tools/rojo-ecosystem/rbxlx-to-rojo"
        ]
        
        for project_dir in rust_projects:
            if os.path.exists(project_dir):
                print(f"🔧 Building Rust project: {project_dir}")
                
                cmd = ["cargo", "build", "--release"]
                if platform == "Windows":
                    cmd.append("--target=x86_64-pc-windows-msvc")
                elif platform == "Darwin":
                    cmd.append("--target=x86_64-apple-darwin")
                else:  # Linux
                    cmd.append("--target=x86_64-unknown-linux-gnu")
                
                result = subprocess.run(cmd, cwd=project_dir, capture_output=True, text=True)
                if result.returncode != 0:
                    raise Exception(f"Rust build failed: {result.stderr}")
    
    def generate_build_scripts(self):
        """
        Generate platform-specific build scripts
        """
        # Windows batch script
        windows_script = """
@echo off
echo Building LuneX for Windows...

REM Install dependencies
pip install pyinstaller

REM Build external tools
cd external-tools\\rojo-ecosystem\\rbx-dom
cargo build --release --target=x86_64-pc-windows-msvc
cd ..\\..\\..

cd external-tools\\rojo-ecosystem\\rbxlx-to-rojo
cargo build --release --target=x86_64-pc-windows-msvc
cd ..\\..\\..

REM Build Python application
pyinstaller --onefile --windowed --name=LuneX LuneX.py

echo Build complete!
"""
        
        with open("build_windows.bat", 'w') as f:
            f.write(windows_script)
        
        # macOS shell script
        macos_script = """#!/bin/bash
echo "Building LuneX for macOS..."

# Install dependencies
pip3 install py2app

# Build external tools
cd external-tools/rojo-ecosystem/rbx-dom
cargo build --release --target=x86_64-apple-darwin
cd ../../..

cd external-tools/rojo-ecosystem/rbxlx-to-rojo
cargo build --release --target=x86_64-apple-darwin
cd ../../..

# Build Python application
python3 setup_macos.py py2app

echo "Build complete!"
"""
        
        with open("build_macos.sh", 'w') as f:
            f.write(macos_script)
        
        # Make executable
        os.chmod("build_macos.sh", 0o755)
        
        # Linux shell script
        linux_script = """#!/bin/bash
echo "Building LuneX for Linux..."

# Install dependencies
pip3 install PyInstaller

# Build external tools
cd external-tools/rojo-ecosystem/rbx-dom
cargo build --release --target=x86_64-unknown-linux-gnu
cd ../../..

cd external-tools/rojo-ecosystem/rbxlx-to-rojo
cargo build --release --target=x86_64-unknown-linux-gnu
cd ../../..

# Build Python application
pyinstaller --onefile --name=LuneX LuneX.py

echo "Build complete!"
"""
        
        with open("build_linux.sh", 'w') as f:
            f.write(linux_script)
        
        os.chmod("build_linux.sh", 0o755)
```

## Phase 1 Implementation: Foundation for AI-Assisted Development

The initial phase of development focused on building a robust, extensible foundation that is well-suited for future AI-assisted development and maintenance. The key achievements of this phase directly support our AI strategy:

### 1. Integration of Pre-Compiled Binaries for Cross-Platform Consistency

A core challenge in cross-platform development is ensuring that external dependencies and tools work reliably across different operating systems (Windows, macOS, Linux). Our integration of the Rust-based `rbx-util` for `.rbxl` to `.rbxlx` conversion is a prime example of our strategy to mitigate this.

- **Reliability:** By using pre-compiled binaries, we eliminate the need for users (or AI agents) to have a specific Rust or C++ development environment configured on their system. The tool is self-contained.
- **Performance:** The conversion is handled by a highly optimized, native binary, ensuring fast and efficient performance that a pure Python implementation would struggle to match.
- **AI-Friendliness:** An AI agent can easily verify the presence of the required executable and understand its simple command-line interface (`rbx-util convert <input> <output>`). This makes the conversion step a predictable and reliable building block in a larger, AI-driven workflow.

### 2. Comprehensive and Granular Documentation

A significant portion of the initial effort was dedicated to creating a detailed and well-structured documentation suite. This is not merely for human developers; it is a critical prerequisite for effective AI collaboration.

- **Structured Knowledge Base:** Documents like `ARCHITECTURE.md`, `CORE_LOGIC.md`, and `BINARY_RBXL_SUPPORT.md` serve as a structured knowledge base. An AI can "read" these documents to understand the project's design, core algorithms, and intended behavior without having to infer everything from the source code alone.
- **Reduced Ambiguity:** Clear documentation reduces the ambiguity that AI models often face when analyzing a codebase. When the AI needs to modify the file export process, it can consult `CORE_LOGIC.md` to understand the exact sequence of operations, from file type detection to final export.
- **Focused Prompts:** This allows for more precise and context-aware prompting. For example, instead of a generic prompt like "add a feature to the export process," we can provide a much more effective prompt: "Using the architecture described in `ARCHITECTURE.md` and the conversion process in `CORE_LOGIC.md`, add a pre-processing step after the `.rbxlx` conversion."

### 3. Modular and Decoupled Logic

The separation of concerns between `LuneX.py` (GUI, user interaction, configuration) and `Lune.py` (core file processing engine) is a deliberate architectural choice that benefits AI-driven development.

- **Targeted Modifications:** An AI agent tasked with "improving the GUI" can focus its analysis and changes on `LuneX.py` and `GUI_DEVELOPMENT.md` with minimal risk of breaking the core file parsing logic.
- **Testability:** This separation allows for more focused testing. The logic in `Lune.py` is highly testable with automated scripts (`test_lunex.py`), ensuring that any AI-generated modifications to the core engine can be validated quickly and reliably.

By completing this foundational work, we have created an environment where an AI can effectively understand, modify, and extend the LuneX utility. The next phases of development will build on this stable and well-documented base.
