import subprocess
from pathlib import Path
import sys

# Check if the script is being run from a PyInstaller onefile executable
if hasattr(sys, '_MEIPASS'):
    # If so, set the script_path to the temporary directory where files are extracted
    script_path = Path(sys._MEIPASS)
else:
    # Otherwise, set it to the directory where the script is located
    script_path = Path(__file__).resolve().parent

# Define the path to the executable within the setup-files directory
launch_path = script_path / 'setup-files' / 'Deploy-Application.exe'

# Launch the executable
subprocess.call([str(launch_path)])
