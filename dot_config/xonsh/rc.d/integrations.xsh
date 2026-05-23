import shutil
import subprocess


def _xonsh_integrations_patch_atuin_xonsh(init_script):
    old = """        atuin history end --exit @(rtn) --duration @(nanos) -- $ATUIN_HISTORY_ID > /dev/null 2>&1"""
    new = """        exit_code = rtn if rtn is not None else 0
        if exit_code < 0:
            exit_code = 128 + abs(exit_code)
        subprocess.run(
            [
                'atuin', 'history', 'end',
                '--exit', str(exit_code),
                '--duration', str(nanos),
                '--', $ATUIN_HISTORY_ID,
            ],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            check=False,
        )"""
    return init_script.replace(old, new)


def _xonsh_integrations_exec_init(command):
    try:
        result = subprocess.run(command, text=True, capture_output=True)
        if result.returncode == 0 and result.stdout:
            init_script = result.stdout
            if command == ['atuin', 'init', 'xonsh']:
                init_script = _xonsh_integrations_patch_atuin_xonsh(init_script)
            execx(init_script)
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
