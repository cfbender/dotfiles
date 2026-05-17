import os
import shutil
import subprocess

aliases['grep'] = ['rg']
aliases['df'] = ['duf']
aliases['cat'] = ['bat']
aliases['dig'] = ['doggo']
aliases['pn'] = ['pnpm']
aliases['oc'] = ['ocx', 'oc']
aliases['im'] = ['iex', '-S', 'mix']
aliases['imp'] = ['iex', '-S', 'mix', 'phx.server']
aliases['yeehaw'] = ['zally.sh']

def _xonsh_aliases_run(cmd, **kwargs):
    return subprocess.run(cmd, **kwargs).returncode

def _xonsh_aliases_mt(args, stdin=None):
    if not args:
        return _xonsh_aliases_run(['mix', 'test'])
    pattern = args[0]
    matches = []
    for root in ('lib', 'test'):
        if not os.path.isdir(root):
            continue
        for dirpath, _, filenames in os.walk(root):
            for filename in filenames:
                path = os.path.join(dirpath, filename)
                if filename.endswith('_test.exs') and pattern in path:
                    matches.append(path)
                elif filename.endswith('_test.exs'):
                    try:
                        with open(path, encoding='utf-8') as handle:
                            for number, line in enumerate(handle, 1):
                                if pattern in line and ('test ' in line or 'describe ' in line):
                                    matches.append(f'{path}:{number}')
                    except OSError:
                        pass
    return _xonsh_aliases_run(['mix', 'test', *matches])

def _xonsh_aliases_mtw(args, stdin=None):
    return _xonsh_aliases_run('fswatch lib test | mix test --listen-on-stdin --stale', shell=True)

def _xonsh_aliases_gunwip(args, stdin=None):
    if _xonsh_aliases_run("git log -n 1 | grep -q -c '\\--wip--'", shell=True) == 0:
        return _xonsh_aliases_run(['git', 'reset', 'HEAD~1'])
    return 1

def _xonsh_aliases_gwip(args, stdin=None):
    _xonsh_aliases_run(['git', 'add', '-A'])
    deleted = subprocess.run(['git', 'ls-files', '--deleted'], text=True, capture_output=True)
    deleted_files = deleted.stdout.splitlines() if deleted.returncode == 0 else []
    if deleted_files:
        _xonsh_aliases_run(['git', 'rm', *deleted_files], stderr=subprocess.DEVNULL)
    return _xonsh_aliases_run(['git', 'commit', '--no-verify', '--no-gpg-sign', '-m', '--wip-- [skip ci]'])

def _xonsh_aliases_gr(args, stdin=None):
    current = subprocess.check_output(['git', 'rev-parse', '--abbrev-ref', 'HEAD'], text=True).strip()
    cmd = "git reflog | egrep -io 'moving from ([^[:space:]]+)' | awk '{ print $3 }' | awk ' !x[$0]++' | egrep -v '^[a-f0-9]{40}$' | head -n 100"
    branches = [line for line in subprocess.check_output(cmd, shell=True, text=True).splitlines() if line != current]
    if not branches:
        return 1
    selected = subprocess.run(['gum', 'filter', '--limit', '1', '--placeholder', 'select recent', '--height', '50'], input='\n'.join(branches), text=True, capture_output=True).stdout.strip()
    if selected:
        return _xonsh_aliases_run(['git', 'sw', selected])
    return 1

def _xonsh_aliases_gd(args, stdin=None):
    return _xonsh_aliases_run('git diff | diffnav', shell=True)

def _xonsh_aliases_gdp(args, stdin=None):
    return _xonsh_aliases_run('gh pr diff | diffnav', shell=True)

def _xonsh_aliases_gss(args, stdin=None):
    code = _xonsh_aliases_run(['gt', 'sync'])
    if code != 0:
        return code
    return _xonsh_aliases_run(['gt', 'submit', '--stack', '--update-only'])

def _xonsh_aliases_nup(args, stdin=None):
    return _xonsh_aliases_run(['nvim', '--headless', '+AstroUpdate', '+MasonToolsUpdateSync', '+qa'])

def _xonsh_aliases_bup(args, stdin=None):
    code = _xonsh_aliases_run(['brew', 'update'])
    if code != 0:
        return code
    return _xonsh_aliases_run(['brew', 'upgrade', '--cask', '--greedy'])

def _xonsh_aliases_pup(args, stdin=None):
    code = _xonsh_aliases_run(['sudo', 'pacman', '-Syu', '--noconfirm'])
    if code != 0:
        return code
    return _xonsh_aliases_run(['paru', '-Syu', '--noconfirm'])

def _xonsh_aliases_aup(args, stdin=None):
    code = _xonsh_aliases_run(['sudo', 'apt', 'update'])
    if code != 0:
        return code
    return _xonsh_aliases_run(['sudo', 'apt', 'upgrade', '-y'])

def _xonsh_aliases_say(message, color):
    if shutil.which('gum'):
        return _xonsh_aliases_run(['gum', 'style', '--foreground', color, '--bold', message])
    print(message)
    return 0

def _xonsh_aliases_fup(args, stdin=None):
    _xonsh_aliases_say('Updating neovim dependencies ...', '#40a02b')
    _xonsh_aliases_nup([])
    if shutil.which('brew'):
        _xonsh_aliases_say('Updating homebrew packages ...', '#df8e1d')
        _xonsh_aliases_bup([])
    elif shutil.which('pacman'):
        _xonsh_aliases_say('Updating pacman packages...', '#df8e1d')
        _xonsh_aliases_pup([])
    elif shutil.which('apt'):
        _xonsh_aliases_say('Updating apt packages...', '#df8e1d')
        _xonsh_aliases_aup([])
    else:
        _xonsh_aliases_say('Skipping system package update (no brew/pacman/apt found).', '#d20f39')
    _xonsh_aliases_say('Updating mise tools ...', '#209fb5')
    _xonsh_aliases_run(['mise', 'self-update'])
    _xonsh_aliases_run(['mise', 'up'])
    _xonsh_aliases_say('Updating skills...', '#7287fd')
    _xonsh_aliases_run(['bunx', 'skills', 'update', '-g'])
    _xonsh_aliases_say('All done! 🎉', '212')
    return 0

def _xonsh_aliases_sync_claret(args, stdin=None):
    claret = os.path.expanduser('~/code/github/claret.nvim/ports')
    chezmoi = os.path.expanduser('~/.local/share/chezmoi')
    copies = [('bat/ClaretDark.tmTheme', 'dot_config/bat/themes/Claret.tmTheme'), ('ghostty/claret-dark.conf', 'dot_config/ghostty/themes/claret'), ('kitty/claret.conf', 'dot_config/kitty/claret.conf'), ('opencode/claret.json', 'dot_config/opencode/themes/claret.json'), ('vicinae/claret-dark.toml', 'dot_local/share/vicinae/themes/claret-dark.toml'), ('yazi/claret-dark.yazi', 'dot_config/yazi/flavors/claret.yazi'), ('zellij/claret-dark.kdl', 'dot_config/zellij/themes/claret.kdl')]
    for src, dst in copies:
        source = os.path.join(claret, src)
        target = os.path.join(chezmoi, dst)
        if os.path.exists(source):
            if os.path.isdir(source):
                if os.path.exists(target):
                    shutil.rmtree(target)
                shutil.copytree(source, target)
            else:
                shutil.copy2(source, target)
            apply_target = '~/' + dst.replace('dot_', '.')
            _xonsh_aliases_run(['chezmoi', 'apply', apply_target])
            print(f'  ✓ {src} → {dst} (applied)')
        else:
            print(f'  ✗ {src} not found, skipping')
    _xonsh_aliases_run(['bat', 'cache', '--build'])
    print('\nNote: starship port is a palette fragment — merge manually if changed.')
    return 0

def _xonsh_aliases_zr(args, stdin=None):
    session = args[0] if args else None
    target = f"session '{session}'" if session else 'all sessions'
    confirmed = _xonsh_aliases_run(['gum', 'confirm', f'Reset {target}?']) == 0 if shutil.which('gum') else False
    if confirmed:
        if session:
            return _xonsh_aliases_run(['zellij', 'delete-session', session, '-f'])
        return _xonsh_aliases_run(['zellij', 'delete-all-sessions', '-y', '-f'])
    return 1

aliases['mt'] = _xonsh_aliases_mt
aliases['mtw'] = _xonsh_aliases_mtw
aliases['gunwip'] = _xonsh_aliases_gunwip
aliases['gwip'] = _xonsh_aliases_gwip
aliases['gr'] = _xonsh_aliases_gr
aliases['gd'] = _xonsh_aliases_gd
aliases['gdp'] = _xonsh_aliases_gdp
aliases['gss'] = _xonsh_aliases_gss
aliases['nup'] = _xonsh_aliases_nup
aliases['bup'] = _xonsh_aliases_bup
aliases['pup'] = _xonsh_aliases_pup
aliases['aup'] = _xonsh_aliases_aup
aliases['fup'] = _xonsh_aliases_fup
aliases['sync-claret'] = _xonsh_aliases_sync_claret
aliases['zr'] = _xonsh_aliases_zr
