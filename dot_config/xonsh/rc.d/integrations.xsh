import shutil
import subprocess

def _xonsh_integrations_exec_init(command):
    try:
        result = subprocess.run(command, text=True, capture_output=True)
        if result.returncode == 0 and result.stdout:
            execx(result.stdout)
    except Exception:
        pass

if shutil.which('starship'):
    _xonsh_integrations_exec_init(['starship', 'init', 'xonsh'])

if shutil.which('zoxide'):
    _xonsh_integrations_exec_init(['zoxide', 'init', 'xonsh'])

if shutil.which('atuin'):
    _xonsh_integrations_exec_init(['atuin', 'init', 'xonsh'])

if shutil.which('carapace'):
    _xonsh_integrations_exec_init(['carapace', '_carapace', 'xonsh'])

if shutil.which('direnv'):
    _xonsh_integrations_exec_init(['direnv', 'hook', 'xonsh'])

if shutil.which('mise'):
    _xonsh_integrations_exec_init(['mise', 'activate', 'xonsh'])

source ~/.config/television/shell/completion.xsh
