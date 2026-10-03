# Troubleshooting

<details>
<summary><code>~/.local/bin</code> is not in PATH</summary>

Some distributions do not automatically include `~/.local/bin` in your `$PATH`.

**Some distributions only include it if the directory exists at login. In these cases, a reboot or logout+login should fix it.*

Check with:

```
echo $PATH | grep "$HOME/.local/bin"
```

If the directory is missing, append the following line to your shell configuration:

```
[ -d $HOME/.local/bin ] && export PATH="$HOME/.local/bin:$PATH"
```

- Bash: `~/.profile`
- Zsh: `~/.zprofile`

After editing the file(s), log out and back in.

</details>

<details>
<summary>Proton is not being detected</summary>

The script searches for the Proton version specified by `PROTON_VER`.

If it cannot be found:

- Verify that the version is installed.
- Change `PROTON_VER` to match an installed version.
- Install the desired Proton version from Steam.

To install Proton:

1. Open Steam.
2. Enable **Tools** in your library filter.
3. Search for the Proton version (for example, `Proton Experimental`).
4. Install it.

For GE-Proton (recommended), install it using your preferred Proton-GE installation method (ProtonPlus, ProtonUp-Qt, or manual installation).

</details>

<details>
<summary>Steam Runtime is not being detected</summary>

The script expects Steam Linux Runtime Sniper to exist. It is usually downloaded automatically after launching any Windows game.

If it is missing:

- Launch any Proton game from Steam. Steam should automatically download **Steam Linux Runtime - Sniper**.

Or install it manually:

1. Open Steam.
2. Enable **Tools** in your library filter.
3. Search for `Steam Linux Runtime 3.0 (sniper)`.
4. Install it manually.

</details>

<details>
<summary>Installing MangoHud</summary>

<details>
<summary>Ubuntu / Debian</summary>

```
sudo apt install mangohud
```

</details>

<details>
<summary>Fedora</summary>

```
sudo dnf install mangohud
```

</details>

<details>
<summary>Arch Linux</summary>

```
sudo pacman -S mangohud
```

</details>

<details>
<summary>openSUSE</summary>

```
sudo zypper install mangohud
```

</details>

If your distribution does not package MangoHud, install it from [the official GitHub releases](https://github.com/flightlessmango/MangoHud).

</details>

<details>
<summary>Other common problems</summary>

**Steam installed through Flatpak**

The script expects a standard Steam installation. If using the Flatpak version, `STEAM_ROOT` will likely need to be changed.

**Executable does not start**

Check:

- The executable is not corrupted.
- The required Visual C++ runtimes are installed.
- The application is compatible with your Proton version.

**Prefix issues**

Delete the application's Proton prefix and let it be recreated. By default, prefixes are stored in `~/.proton/`.

</details>
