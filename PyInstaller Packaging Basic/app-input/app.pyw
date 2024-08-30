# Entry point launching executable inside of a binary package

import subprocess
from pathlib import Path
script_path = Path(__file__).resolve().parent
launch_path = script_path / 'setup-files' / 'app.exe'
subprocess.call(f'"{launch_path}"')
