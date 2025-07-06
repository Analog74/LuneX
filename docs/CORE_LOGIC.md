# LuneX Core Logic Development Guide

## 🔧 Core Processing Engine Documentation

This guide provides comprehensive documentation for LuneX's core processing logic, designed to enable efficient AI-assisted development, debugging, and enhancement of the file processing pipeline.

## 🏗️ Core Engine Architecture

### Processing Pipeline Overview
```
Input File → Detection → Conversion → Parsing → Export → Output
     ↓           ↓           ↓          ↓        ↓        ↓
  .rbxl/.rbxlx → Binary? → .rbxlx → XML Tree → Structure → Files
```

### Component Hierarchy
```python
Lune.py (Core Engine)
├── File Detection System
│   ├── Binary Format Detection
│   ├── XML Format Validation
│   └── Format Classification
├── Conversion Pipeline
│   ├── External Tool Integration
│   ├── Fallback Conversion Methods
│   └── Error Recovery Strategies
├── XML Processing Engine
│   ├── DOM Tree Parsing
│   ├── Roblox Object Modeling
│   └── Property Extraction
├── Export System
│   ├── Rojo Mode Exporter
│   ├── Scripts-Only Exporter
│   └── Template Engine
└── Utility Systems
    ├── Path Management
    ├── Configuration Handling
    └── Error Reporting
```

## 📁 File Detection & Conversion System

### Binary Format Detection Engine

#### Detection Algorithm Implementation
```python
def convert_rbxl_to_xml(rbxl_path):
    """
    Multi-stage file format detection with robust error handling
    
    Detection Stages:
    1. Header Analysis - Read first 200 bytes for signatures
    2. XML Marker Detection - Look for <?xml declarations
    3. Binary Signature Detection - Check for Roblox binary markers
    4. UTF-8 Fallback - Attempt text parsing for edge cases
    5. Format Classification - Route to appropriate processor
    
    Args:
        rbxl_path (str): Path to input file
        
    Returns:
        str|None: Path to XML file (converted or original) or None on failure
    """
```

#### Format Signature Patterns
```python
# Binary format signatures
ROBLOX_BINARY_SIGNATURES = [
    b'<roblox!',      # Standard Roblox binary header
    b'RBLX',          # Alternative binary marker
    b'\x89RBLX',      # PNG-style signature variant
]

# XML format signatures  
XML_SIGNATURES = [
    b'<?xml',         # Standard XML declaration
    b'\xef\xbb\xbf<?xml',  # UTF-8 BOM + XML
    b'<roblox',       # Direct Roblox XML root
]

def detect_file_format(file_path, header_size=200):
    """
    Comprehensive format detection using multiple strategies
    
    Returns:
        tuple: (format_type: str, confidence: float, metadata: dict)
    """
    try:
        with open(file_path, 'rb') as f:
            header = f.read(header_size)
            
        # Check for XML signatures
        for signature in XML_SIGNATURES:
            if header.startswith(signature) or signature in header[:50]:
                return 'xml', 0.95, {'encoding': 'utf-8'}
        
        # Check for binary signatures
        for signature in ROBLOX_BINARY_SIGNATURES:
            if header.startswith(signature) or signature in header[:16]:
                return 'binary', 0.90, {'version': 'unknown'}
        
        # UTF-8 text fallback
        try:
            decoded = header.decode('utf-8')
            if '<?xml' in decoded[:100] or '<roblox' in decoded[:100]:
                return 'xml', 0.70, {'encoding': 'utf-8', 'method': 'fallback'}
        except UnicodeDecodeError:
            pass
            
        return 'unknown', 0.0, {'reason': 'no_signatures_found'}
        
    except Exception as e:
        return 'error', 0.0, {'error': str(e)}
```

### External Tool Integration System

#### Tool Discovery and Management
```python
class ConverterManager:
    """
    Manages external conversion tools with priority-based execution
    """
    
    def __init__(self):
        self.tools = []
        self.discover_tools()
    
    def discover_tools(self):
        """
        Discover available conversion tools in order of preference
        """
        # Local project tools (highest priority)
        self.register_local_tools()
        
        # System-installed tools
        self.register_system_tools()
        
        # Python library tools (lowest priority)
        self.register_python_tools()
    
    def register_local_tools(self):
        """Register tools bundled with project"""
        project_root = os.path.dirname(__file__)
        
        # rbx-util from rbx-dom
        rbx_util_path = os.path.join(
            project_root, "external-tools", "rojo-ecosystem", 
            "rbx-dom", "target", "release", "rbx-util"
        )
        
        if os.path.exists(rbx_util_path):
            self.tools.append(RbxUtilConverter(rbx_util_path, priority=100))
        
        # rbxlx-to-rojo
        rbxlx_to_rojo_path = os.path.join(
            project_root, "external-tools", "rojo-ecosystem",
            "rbxlx-to-rojo", "target", "release", "rbxlx-to-rojo"
        )
        
        if os.path.exists(rbxlx_to_rojo_path):
            self.tools.append(RbxlxToRojoConverter(rbxlx_to_rojo_path, priority=90))
    
    def register_system_tools(self):
        """Register system-installed conversion tools"""
        system_tools = [
            ('rbx-util', RbxUtilConverter, 80),
            ('rbxlx-to-rojo', RbxlxToRojoConverter, 70),
            ('rojo', RojoConverter, 60),
        ]
        
        for tool_name, converter_class, priority in system_tools:
            if self.is_tool_available(tool_name):
                self.tools.append(converter_class(tool_name, priority=priority))
    
    def convert_file(self, input_path, output_path):
        """
        Attempt conversion using available tools in priority order
        
        Returns:
            tuple: (success: bool, output_path: str, tool_used: str, error: str)
        """
        # Sort tools by priority (highest first)
        sorted_tools = sorted(self.tools, key=lambda t: t.priority, reverse=True)
        
        for tool in sorted_tools:
            try:
                print(f"🔄 Attempting conversion with {tool.name}...")
                
                success, result_path = tool.convert(input_path, output_path)
                
                if success and os.path.exists(result_path):
                    print(f"✅ Successfully converted using {tool.name}")
                    return True, result_path, tool.name, None
                else:
                    print(f"❌ Conversion failed with {tool.name}")
                    
            except Exception as e:
                print(f"❌ Error with {tool.name}: {e}")
                continue
        
        return False, None, None, "All conversion tools failed"
```

#### Converter Interface Design
```python
class ConverterInterface:
    """
    Abstract base class for conversion tools
    """
    
    def __init__(self, tool_path, priority=50):
        self.tool_path = tool_path
        self.priority = priority
        self.name = self.__class__.__name__
        self.timeout = 120  # Default 2-minute timeout
    
    def can_convert(self, input_path):
        """
        Check if this converter can handle the input file
        
        Returns:
            bool: True if converter can process this file
        """
        raise NotImplementedError
    
    def convert(self, input_path, output_path):
        """
        Perform the actual conversion
        
        Returns:
            tuple: (success: bool, output_path: str)
        """
        raise NotImplementedError
    
    def get_version(self):
        """
        Get tool version information
        
        Returns:
            str: Version string or "unknown"
        """
        try:
            result = subprocess.run([self.tool_path, '--version'], 
                                  capture_output=True, text=True, timeout=5)
            if result.returncode == 0:
                return result.stdout.strip()
        except:
            pass
        return "unknown"

class RbxUtilConverter(ConverterInterface):
    """
    rbx-util converter implementation
    """
    
    def can_convert(self, input_path):
        """rbx-util can convert binary .rbxl files"""
        format_type, confidence, _ = detect_file_format(input_path)
        return format_type == 'binary' and confidence > 0.8
    
    def convert(self, input_path, output_path):
        """
        Convert using rbx-util
        
        Command: rbx-util convert input.rbxl output.rbxlx
        """
        try:
            cmd = [self.tool_path, 'convert', input_path, output_path]
            
            result = subprocess.run(
                cmd, 
                capture_output=True, 
                text=True, 
                timeout=self.timeout,
                cwd=os.path.dirname(self.tool_path)
            )
            
            if result.returncode == 0:
                return True, output_path
            else:
                print(f"rbx-util stderr: {result.stderr}")
                return False, None
                
        except subprocess.TimeoutExpired:
            print(f"rbx-util conversion timed out after {self.timeout} seconds")
            return False, None
        except Exception as e:
            print(f"rbx-util conversion error: {e}")
            return False, None

class RbxlxToRojoConverter(ConverterInterface):
    """
    rbxlx-to-rojo converter implementation
    """
    
    def can_convert(self, input_path):
        """rbxlx-to-rojo can convert both binary and XML files"""
        format_type, confidence, _ = detect_file_format(input_path)
        return confidence > 0.7
    
    def convert(self, input_path, output_path):
        """
        Convert using rbxlx-to-rojo
        
        Note: This tool creates a full project structure, not just XML conversion
        """
        try:
            # Create temporary directory for rbxlx-to-rojo output
            temp_dir = output_path.replace('.rbxlx', '_temp_project')
            
            cmd = [self.tool_path, input_path, temp_dir]
            
            result = subprocess.run(
                cmd,
                capture_output=True,
                text=True,
                timeout=self.timeout
            )
            
            if result.returncode == 0:
                # Look for XML file in the generated project
                for root, dirs, files in os.walk(temp_dir):
                    for file in files:
                        if file.endswith('.rbxlx'):
                            xml_file = os.path.join(root, file)
                            # Copy to desired output location
                            shutil.copy2(xml_file, output_path)
                            # Clean up temporary directory
                            shutil.rmtree(temp_dir, ignore_errors=True)
                            return True, output_path
                
                # No XML file found in output
                shutil.rmtree(temp_dir, ignore_errors=True)
                return False, None
            else:
                print(f"rbxlx-to-rojo stderr: {result.stderr}")
                return False, None
                
        except Exception as e:
            print(f"rbxlx-to-rojo conversion error: {e}")
            return False, None
```

## 📊 XML Processing Engine

### Roblox Object Model
```python
class RobloxObject:
    """
    Represents a Roblox game object with properties and children
    """
    
    def __init__(self, class_name, name="", parent=None):
        self.class_name = class_name
        self.name = name
        self.parent = parent
        self.children = []
        self.properties = {}
        self.attributes = {}
        
    def add_child(self, child):
        """Add a child object"""
        child.parent = self
        self.children.append(child)
        
    def get_child_by_name(self, name):
        """Find child by name"""
        for child in self.children:
            if child.name == name:
                return child
        return None
        
    def get_children_by_class(self, class_name):
        """Find all children of specified class"""
        return [child for child in self.children if child.class_name == class_name]
    
    def get_full_path(self):
        """Get full hierarchical path to this object"""
        if self.parent is None:
            return self.name or self.class_name
        return f"{self.parent.get_full_path()}.{self.name or self.class_name}"
    
    def is_script(self):
        """Check if this object is a script"""
        script_classes = {
            'Script', 'LocalScript', 'ServerScript', 'StarterScript',
            'CoreScript', 'PlayerScript'
        }
        return self.class_name in script_classes
    
    def is_service(self):
        """Check if this object is a Roblox service"""
        service_classes = {
            'Workspace', 'Players', 'ReplicatedStorage', 'ServerStorage',
            'ServerScriptService', 'StarterPlayer', 'StarterPack', 'Teams',
            'Lighting', 'SoundService', 'UserInputService', 'TweenService'
        }
        return self.class_name in service_classes

class RobloxProperty:
    """
    Represents a Roblox object property with type information
    """
    
    def __init__(self, name, value, prop_type="string"):
        self.name = name
        self.value = value
        self.type = prop_type
        
    def get_lua_value(self):
        """Convert property value to Lua representation"""
        if self.type == "bool":
            return "true" if self.value else "false"
        elif self.type == "number":
            return str(self.value)
        elif self.type == "string":
            return f'"{self.value}"'
        elif self.type == "Vector3":
            x, y, z = self.value
            return f"Vector3.new({x}, {y}, {z})"
        elif self.type == "Color3":
            r, g, b = self.value
            return f"Color3.new({r}, {g}, {b})"
        else:
            return f'"{str(self.value)}"'  # Default to string
```

### XML Parsing Pipeline
```python
class RobloxXMLParser:
    """
    High-performance XML parser optimized for Roblox files
    """
    
    def __init__(self):
        self.root_object = None
        self.object_stack = []
        self.current_property = None
        
    def parse_file(self, xml_file_path):
        """
        Parse Roblox XML file into object hierarchy
        
        Returns:
            RobloxObject: Root object of the parsed hierarchy
        """
        try:
            tree = ET.parse(xml_file_path)
            root_element = tree.getroot()
            
            if root_element.tag != "roblox":
                raise ValueError("Invalid Roblox XML file - missing <roblox> root")
            
            # Find the main game object (usually first child)
            for child in root_element:
                if child.tag == "Item":
                    self.root_object = self.parse_item(child)
                    break
            
            if self.root_object is None:
                raise ValueError("No game objects found in XML file")
            
            return self.root_object
            
        except ET.ParseError as e:
            raise ValueError(f"XML parsing error: {e}")
        except Exception as e:
            raise ValueError(f"Failed to parse Roblox file: {e}")
    
    def parse_item(self, item_element, parent=None):
        """
        Parse an Item element into a RobloxObject
        """
        # Get class name from class attribute
        class_name = item_element.get("class", "Instance")
        
        # Create the object
        obj = RobloxObject(class_name, parent=parent)
        
        # Parse properties and children
        for child in item_element:
            if child.tag == "Properties":
                self.parse_properties(child, obj)
            elif child.tag == "Item":
                child_obj = self.parse_item(child, parent=obj)
                obj.add_child(child_obj)
        
        return obj
    
    def parse_properties(self, properties_element, obj):
        """
        Parse Properties element into object properties
        """
        for prop_element in properties_element:
            prop_name = prop_element.get("name", "")
            prop_type = prop_element.tag
            prop_value = self.parse_property_value(prop_element, prop_type)
            
            # Special handling for Name property
            if prop_name == "Name":
                obj.name = prop_value
            else:
                obj.properties[prop_name] = RobloxProperty(prop_name, prop_value, prop_type)
    
    def parse_property_value(self, prop_element, prop_type):
        """
        Parse property value based on type
        """
        if prop_type == "string":
            return prop_element.text or ""
        elif prop_type == "bool":
            return prop_element.text == "true"
        elif prop_type == "int" or prop_type == "float":
            return float(prop_element.text) if prop_element.text else 0
        elif prop_type == "Vector3":
            # Parse Vector3 from child elements
            x = float(prop_element.find("X").text) if prop_element.find("X") is not None else 0
            y = float(prop_element.find("Y").text) if prop_element.find("Y") is not None else 0
            z = float(prop_element.find("Z").text) if prop_element.find("Z") is not None else 0
            return (x, y, z)
        elif prop_type == "Color3":
            # Parse Color3 from child elements
            r = float(prop_element.find("R").text) if prop_element.find("R") is not None else 0
            g = float(prop_element.find("G").text) if prop_element.find("G") is not None else 0
            b = float(prop_element.find("B").text) if prop_element.find("B") is not None else 0
            return (r, g, b)
        else:
            # Default to string representation
            return prop_element.text or ""
```

## 🔄 Export System Architecture

### Export Mode Interface
```python
class ExportMode:
    """
    Abstract base class for export modes
    """
    
    def __init__(self, output_directory, options=None):
        self.output_dir = output_directory
        self.options = options or {}
        
    def export(self, root_object):
        """
        Export the parsed object hierarchy
        
        Args:
            root_object (RobloxObject): Root of the object hierarchy
            
        Returns:
            bool: Success status
        """
        raise NotImplementedError
    
    def get_description(self):
        """Get human-readable description of this export mode"""
        raise NotImplementedError

class RojoExportMode(ExportMode):
    """
    Rojo project structure export mode
    """
    
    def export(self, root_object):
        """
        Export as Rojo-compatible project structure
        """
        try:
            # Create src directory
            src_dir = os.path.join(self.output_dir, "src")
            os.makedirs(src_dir, exist_ok=True)
            
            # Generate project.json
            project_config = self.generate_project_json(root_object)
            project_path = os.path.join(self.output_dir, "default.project.json")
            
            with open(project_path, 'w') as f:
                json.dump(project_config, f, indent=2)
            
            # Export object hierarchy
            self.export_object_hierarchy(root_object, src_dir)
            
            print(f"✅ Rojo project exported to {self.output_dir}")
            return True
            
        except Exception as e:
            print(f"❌ Rojo export failed: {e}")
            return False
    
    def generate_project_json(self, root_object):
        """
        Generate Rojo project.json configuration
        """
        project_name = os.path.basename(self.output_dir)
        
        config = {
            "name": project_name,
            "tree": {
                "$className": root_object.class_name
            }
        }
        
        # Add service mappings
        for child in root_object.children:
            if child.is_service():
                service_path = self.get_service_path(child)
                if service_path:
                    config["tree"][child.name] = {"$path": service_path}
        
        return config
    
    def get_service_path(self, service_object):
        """
        Get the appropriate source path for a service
        """
        service_paths = {
            "ServerScriptService": "src/server",
            "ReplicatedStorage": "src/shared", 
            "StarterPlayer": "src/client",
            "Workspace": "src/workspace"
        }
        
        return service_paths.get(service_object.class_name, f"src/{service_object.name.lower()}")
    
    def export_object_hierarchy(self, obj, current_dir):
        """
        Recursively export object hierarchy to filesystem
        """
        for child in obj.children:
            if child.is_script():
                self.export_script(child, current_dir)
            elif child.children:  # Has children, create directory
                child_dir = os.path.join(current_dir, child.name)
                os.makedirs(child_dir, exist_ok=True)
                
                # Create init file if needed
                if any(c.is_script() for c in child.children):
                    init_path = os.path.join(child_dir, "init.lua")
                    with open(init_path, 'w') as f:
                        f.write(f"-- {child.name} module\nreturn {{}}\n")
                
                # Recursively export children
                self.export_object_hierarchy(child, child_dir)
    
    def export_script(self, script_obj, directory):
        """
        Export a script object to a .lua file
        """
        script_name = script_obj.name or "Script"
        
        # Determine file extension based on script type
        if script_obj.class_name == "LocalScript":
            filename = f"{script_name}.client.lua"
        elif script_obj.class_name == "ServerScript" or script_obj.class_name == "Script":
            filename = f"{script_name}.server.lua"
        else:
            filename = f"{script_name}.lua"
        
        script_path = os.path.join(directory, filename)
        
        # Get script source
        source_prop = script_obj.properties.get("Source")
        source_code = source_prop.value if source_prop else "-- Empty script"
        
        # Write script file
        with open(script_path, 'w', encoding='utf-8') as f:
            f.write(source_code)
        
        # Create metadata file
        meta_path = script_path + ".meta.json"
        metadata = {
            "className": script_obj.class_name,
            "originalName": script_obj.name,
            "properties": {name: prop.value for name, prop in script_obj.properties.items() if name != "Source"}
        }
        
        with open(meta_path, 'w') as f:
            json.dump(metadata, f, indent=2)

class ScriptsOnlyExportMode(ExportMode):
    """
    Scripts-only export mode - flat directory structure
    """
    
    def export(self, root_object):
        """
        Export all scripts to flat directory structure
        """
        try:
            scripts = self.collect_all_scripts(root_object)
            
            print(f"📄 Found {len(scripts)} scripts to export")
            
            for script in scripts:
                self.export_script_flat(script)
            
            # Generate project.json if requested
            if self.options.get("create_project_json", False):
                self.generate_simple_project_json()
            
            print(f"✅ Scripts exported to {self.output_dir}")
            return True
            
        except Exception as e:
            print(f"❌ Scripts-only export failed: {e}")
            return False
    
    def collect_all_scripts(self, obj, scripts=None):
        """
        Recursively collect all script objects
        """
        if scripts is None:
            scripts = []
            
        if obj.is_script():
            scripts.append(obj)
        
        for child in obj.children:
            self.collect_all_scripts(child, scripts)
        
        return scripts
    
    def export_script_flat(self, script_obj):
        """
        Export script to flat directory with metadata
        """
        script_name = script_obj.name or "Script"
        
        # Create unique filename to avoid conflicts
        base_name = f"{script_name}_{script_obj.class_name}"
        script_path = os.path.join(self.output_dir, f"{base_name}.lua")
        
        # Handle filename conflicts
        counter = 1
        while os.path.exists(script_path):
            script_path = os.path.join(self.output_dir, f"{base_name}_{counter}.lua")
            counter += 1
        
        # Export script content
        source_prop = script_obj.properties.get("Source")
        source_code = source_prop.value if source_prop else "-- Empty script"
        
        with open(script_path, 'w', encoding='utf-8') as f:
            f.write(source_code)
        
        # Export metadata
        meta_path = script_path.replace('.lua', '.meta.json')
        metadata = {
            "className": script_obj.class_name,
            "originalName": script_obj.name,
            "fullPath": script_obj.get_full_path(),
            "properties": {name: prop.value for name, prop in script_obj.properties.items() if name != "Source"}
        }
        
        with open(meta_path, 'w') as f:
            json.dump(metadata, f, indent=2)
    
    def generate_simple_project_json(self):
        """
        Generate simple project.json for scripts-only export
        """
        project_name = "scripts-only-project"
        
        config = {
            "name": project_name,
            "tree": {
                "$className": "DataModel",
                "ServerScriptService": {
                    "$path": "src"
                }
            }
        }
        
        project_path = os.path.join(self.output_dir, "default.project.json")
        with open(project_path, 'w') as f:
            json.dump(config, f, indent=2)
```

## 🛠️ Utility Systems

### Path Management
```python
class PathManager:
    """
    Cross-platform path handling with safety checks
    """
    
    @staticmethod
    def safe_filename(filename):
        """
        Convert filename to safe cross-platform version
        """
        # Remove/replace invalid characters
        invalid_chars = '<>:"/\\|?*'
        for char in invalid_chars:
            filename = filename.replace(char, '_')
        
        # Handle Windows reserved names
        reserved_names = {
            'CON', 'PRN', 'AUX', 'NUL',
            'COM1', 'COM2', 'COM3', 'COM4', 'COM5', 'COM6', 'COM7', 'COM8', 'COM9',
            'LPT1', 'LPT2', 'LPT3', 'LPT4', 'LPT5', 'LPT6', 'LPT7', 'LPT8', 'LPT9'
        }
        
        if filename.upper() in reserved_names:
            filename = f"_{filename}"
        
        # Limit length
        if len(filename) > 255:
            name, ext = os.path.splitext(filename)
            filename = name[:255-len(ext)] + ext
        
        return filename
    
    @staticmethod
    def ensure_directory(directory_path):
        """
        Ensure directory exists with proper error handling
        """
        try:
            os.makedirs(directory_path, exist_ok=True)
            return True
        except PermissionError:
            print(f"❌ Permission denied creating directory: {directory_path}")
            return False
        except Exception as e:
            print(f"❌ Failed to create directory {directory_path}: {e}")
            return False
    
    @staticmethod
    def get_temp_file(base_name, extension=".tmp"):
        """
        Generate safe temporary file path
        """
        temp_dir = tempfile.gettempdir()
        timestamp = int(time.time())
        temp_name = f"{base_name}_{timestamp}{extension}"
        return os.path.join(temp_dir, temp_name)

### Error Handling System
```python
class LuneXError(Exception):
    """Base exception for LuneX errors"""
    pass

class FileFormatError(LuneXError):
    """Raised when file format is invalid or unsupported"""
    pass

class ConversionError(LuneXError):
    """Raised when file conversion fails"""
    pass

class ExportError(LuneXError):
    """Raised when export process fails"""
    pass

class ErrorHandler:
    """
    Centralized error handling with user-friendly messages
    """
    
    @staticmethod
    def handle_exception(func):
        """
        Decorator for consistent error handling
        """
        def wrapper(*args, **kwargs):
            try:
                return func(*args, **kwargs)
            except FileFormatError as e:
                return False, f"File format error: {e}"
            except ConversionError as e:
                return False, f"Conversion failed: {e}"
            except ExportError as e:
                return False, f"Export failed: {e}"
            except Exception as e:
                return False, f"Unexpected error: {e}"
        return wrapper
    
    @staticmethod
    def format_error_message(error):
        """
        Format error message for user display
        """
        if isinstance(error, FileNotFoundError):
            return "File not found. Please check the file path and try again."
        elif isinstance(error, PermissionError):
            return "Permission denied. Please check file/directory permissions."
        elif isinstance(error, subprocess.TimeoutExpired):
            return "Operation timed out. The file may be too large or system is busy."
        else:
            return f"Error: {str(error)}"
```

## 🧪 Testing and Validation

### Unit Testing Framework
```python
import unittest
from unittest.mock import patch, MagicMock

class TestFileDetection(unittest.TestCase):
    """Test file format detection system"""
    
    def test_binary_detection(self):
        """Test binary .rbxl file detection"""
        # Mock file with binary signature
        mock_header = b'<roblox!\x00\x01\x02\x03'
        
        with patch('builtins.open', mock_open(read_data=mock_header)):
            format_type, confidence, metadata = detect_file_format('test.rbxl')
            
        self.assertEqual(format_type, 'binary')
        self.assertGreater(confidence, 0.8)
    
    def test_xml_detection(self):
        """Test XML .rbxlx file detection"""
        mock_header = b'<?xml version="1.0" encoding="UTF-8"?>\n<roblox'
        
        with patch('builtins.open', mock_open(read_data=mock_header)):
            format_type, confidence, metadata = detect_file_format('test.rbxlx')
            
        self.assertEqual(format_type, 'xml')
        self.assertGreater(confidence, 0.9)

class TestConversionPipeline(unittest.TestCase):
    """Test conversion system"""
    
    @patch('subprocess.run')
    def test_rbx_util_conversion(self, mock_subprocess):
        """Test rbx-util conversion process"""
        # Mock successful conversion
        mock_subprocess.return_value = MagicMock(returncode=0)
        
        converter = RbxUtilConverter('/fake/path/rbx-util')
        success, output_path = converter.convert('input.rbxl', 'output.rbxlx')
        
        self.assertTrue(success)
        mock_subprocess.assert_called_once()

class TestExportModes(unittest.TestCase):
    """Test export mode functionality"""
    
    def test_rojo_export_structure(self):
        """Test Rojo export creates correct structure"""
        # Create mock object hierarchy
        root = RobloxObject("DataModel")
        workspace = RobloxObject("Workspace", "Workspace")
        script = RobloxObject("Script", "TestScript")
        
        workspace.add_child(script)
        root.add_child(workspace)
        
        # Test export
        with tempfile.TemporaryDirectory() as temp_dir:
            exporter = RojoExportMode(temp_dir)
            success = exporter.export(root)
            
            self.assertTrue(success)
            self.assertTrue(os.path.exists(os.path.join(temp_dir, "default.project.json")))
            self.assertTrue(os.path.exists(os.path.join(temp_dir, "src")))
```

### Performance Profiling
```python
import cProfile
import pstats
from functools import wraps

def profile_function(func):
    """
    Decorator to profile function performance
    """
    @wraps(func)
    def wrapper(*args, **kwargs):
        profiler = cProfile.Profile()
        profiler.enable()
        
        result = func(*args, **kwargs)
        
        profiler.disable()
        stats = pstats.Stats(profiler)
        stats.sort_stats('cumulative')
        stats.print_stats(20)  # Top 20 functions
        
        return result
    return wrapper

# Usage:
@profile_function
def process_large_file(file_path):
    """Profile this function's performance"""
    return convert_and_export(file_path)
```

## 🚀 Enhancement Opportunities

### 1. Streaming XML Processing
```python
import xml.sax

class StreamingRobloxParser(xml.sax.ContentHandler):
    """
    Memory-efficient streaming parser for large files
    """
    
    def __init__(self, output_handler):
        self.output_handler = output_handler
        self.current_object = None
        self.object_stack = []
        
    def startElement(self, name, attrs):
        if name == "Item":
            class_name = attrs.get("class", "Instance")
            obj = RobloxObject(class_name)
            
            if self.current_object:
                self.current_object.add_child(obj)
            
            self.object_stack.append(self.current_object)
            self.current_object = obj
    
    def endElement(self, name):
        if name == "Item":
            # Process completed object
            self.output_handler.process_object(self.current_object)
            self.current_object = self.object_stack.pop()
```

### 2. Parallel Processing
```python
import concurrent.futures
import multiprocessing

class ParallelProcessor:
    """
    Multi-threaded processing for large projects
    """
    
    def __init__(self, max_workers=None):
        self.max_workers = max_workers or multiprocessing.cpu_count()
    
    def process_scripts_parallel(self, scripts, output_dir):
        """
        Process multiple scripts in parallel
        """
        with concurrent.futures.ThreadPoolExecutor(max_workers=self.max_workers) as executor:
            futures = []
            
            for script in scripts:
                future = executor.submit(self.process_single_script, script, output_dir)
                futures.append(future)
            
            # Collect results
            results = []
            for future in concurrent.futures.as_completed(futures):
                try:
                    result = future.result()
                    results.append(result)
                except Exception as e:
                    print(f"Script processing error: {e}")
            
            return results
```

### 3. Plugin Architecture
```python
class PluginManager:
    """
    Extensible plugin system for converters and exporters
    """
    
    def __init__(self):
        self.converters = []
        self.exporters = []
        self.plugins_dir = "plugins"
    
    def load_plugins(self):
        """
        Dynamically load plugins from plugins directory
        """
        if not os.path.exists(self.plugins_dir):
            return
        
        for file in os.listdir(self.plugins_dir):
            if file.endswith('.py'):
                self.load_plugin_file(os.path.join(self.plugins_dir, file))
    
    def register_converter(self, converter_class):
        """Register new converter plugin"""
        self.converters.append(converter_class)
    
    def register_exporter(self, exporter_class):
        """Register new exporter plugin"""
        self.exporters.append(exporter_class)
```

This comprehensive core logic documentation provides the foundation for AI-assisted development, enabling efficient enhancement, debugging, and maintenance of LuneX's processing pipeline across all platforms and use cases.
