#!/usr/bin/env python3

"""
Dotfiles Installer

Uses the repository directory structure to map files directly to the target environment.
Files under platform folders ('common', 'linux', 'macos') map directly to relative paths in $HOME.
Files and folders prefixed with 'dot-' (e.g. dot-config/, dot-tmux.conf) map to their hidden
equivalent in $HOME (e.g. .config/, .tmux.conf).

Preference: Hard link with automatic fallback to symlink.
Dependencies: Python 3 Standard Library only.

MIT License
Copyright (c) 2017-2026 MaT1g3R & contributors
"""

import argparse
import errno
import os
import platform
import shutil
import subprocess
import sys
import time
from pathlib import Path
from typing import Dict, List, Optional, Set, Tuple


HERE = Path(__file__).resolve().parent
HOME = Path.home()

# Files and directory names to ignore during discovery
IGNORED_NAMES: Set[str] = {
    ".DS_Store",
    ".git",
    ".gitignore",
    ".gitkeep",
    ".netrwhist",
    "Thumbs.db",
    "__pycache__",
}

IGNORED_SUFFIXES: Tuple[str, ...] = (
    "~",
    ".swp",
    ".swo",
    ".pyc",
)


def detect_platform() -> str:
    """Detect current operating system, normalized to 'linux' or 'macos'."""
    sys_name = platform.system().lower()
    if sys_name == "darwin":
        return "macos"
    if sys_name == "linux":
        return "linux"
    return sys_name


def should_ignore(path: Path) -> bool:
    """Determine whether a file or directory should be ignored."""
    if path.name in IGNORED_NAMES:
        return True
    if any(path.name.endswith(suffix) for suffix in IGNORED_SUFFIXES):
        return True
    return False


def map_dest_rel_path(rel_path: Path) -> Path:
    """
    Map repository relative path to destination relative path.
    Converts path segments starting with 'dot-' to start with '.'.
    e.g., 'dot-config/nvim/init.vim' -> '.config/nvim/init.vim'
          'dot-tmux.conf'            -> '.tmux.conf'
          'bin/dot-hosts.bak'        -> 'bin/.hosts.bak'
    """
    new_parts = [
        ("." + part[4:]) if part.startswith("dot-") else part
        for part in rel_path.parts
    ]
    return Path(*new_parts)


def discover_files(platform_dir: Path) -> List[Tuple[Path, Path, Path]]:
    """
    Recursively discover all files under platform_dir.
    Returns a list of (source_path, dest_rel_path, repo_rel_path) tuples.
    """
    results: List[Tuple[Path, Path, Path]] = []
    if not platform_dir.is_dir():
        return results

    for root, dirs, files in os.walk(platform_dir):
        # Prune ignored directories in-place
        dirs[:] = [d for d in dirs if not should_ignore(Path(d))]

        for file_name in files:
            file_path = Path(root) / file_name
            if not should_ignore(file_path):
                repo_rel_path = file_path.relative_to(platform_dir)
                dest_rel_path = map_dest_rel_path(repo_rel_path)
                results.append((file_path, dest_rel_path, repo_rel_path))

    # Sort files for deterministic execution order
    results.sort(key=lambda item: str(item[1]))
    return results


def check_link_status(src: Path, dest: Path) -> str:
    """
    Check the current status of dest relative to src.

    Returns:
        'hardlinked': dest is hard-linked to src (same device and inode)
        'symlinked': dest is a symlink pointing to src
        'broken_link': dest is a broken symlink
        'conflict': dest exists and is different from src
        'missing': dest does not exist
    """
    if dest.is_symlink():
        try:
            # Check if broken
            if not dest.exists():
                return "broken_link"
            if dest.resolve() == src.resolve():
                return "symlinked"
            return "conflict"
        except OSError:
            return "broken_link"

    if dest.exists():
        try:
            if os.path.samestat(src.stat(), dest.stat()):
                return "hardlinked"
            return "conflict"
        except OSError:
            return "conflict"

    return "missing"


def get_dest_device(dest: Path) -> Optional[int]:
    """Get the st_dev of dest or its nearest existing ancestor directory."""
    curr = dest if (dest.is_symlink() or dest.exists()) else dest.parent
    while curr != curr.parent:
        try:
            return curr.lstat().st_dev
        except OSError:
            curr = curr.parent
    return None


def is_same_filesystem(src: Path, dest: Path) -> bool:
    """Check if src and dest reside on the same filesystem (same st_dev)."""
    try:
        src_dev = src.stat().st_dev
        dest_dev = get_dest_device(dest)
        return dest_dev is not None and src_dev == dest_dev
    except OSError:
        return False


def clean_parent_symlinks(dest: Path, repo_root: Path, force: bool, dry_run: bool) -> bool:
    """
    Walk up ancestor directories of dest.
    If an ancestor is a broken symlink or an old directory symlink pointing into the repo,
    replace it with a real directory so individual files can be linked.
    """
    parent = dest.parent
    ancestors: List[Path] = []
    curr = parent
    while curr != curr.parent and curr != HOME.parent:
        ancestors.append(curr)
        curr = curr.parent

    for ancestor in reversed(ancestors):
        if ancestor.is_symlink():
            is_broken = not ancestor.exists()
            points_to_repo = False
            try:
                resolved = ancestor.resolve()
                points_to_repo = resolved == repo_root or repo_root in resolved.parents
            except OSError:
                is_broken = True

            if is_broken or points_to_repo:
                if not dry_run:
                    ancestor.unlink()
                    ancestor.mkdir(parents=True, exist_ok=True)
            elif force:
                if not dry_run:
                    ancestor.unlink()
                    ancestor.mkdir(parents=True, exist_ok=True)
            else:
                return False

    if not dry_run:
        parent.mkdir(parents=True, exist_ok=True)
    return True


def backup_path(path: Path, dry_run: bool) -> Optional[Path]:
    """Create a backup of path with a .bak timestamp suffix."""
    timestamp = time.strftime("%Y%m%d_%H%M%S")
    backup = path.with_name(f"{path.name}.bak.{timestamp}")
    if not dry_run:
        shutil.move(str(path), str(backup))
    return backup


def link_file(
    src: Path,
    dest: Path,
    symlink_only: bool,
    force: bool,
    backup: bool,
    dry_run: bool,
    verbose: bool,
) -> Tuple[str, str]:
    """
    Install a single file using hard link (or fallback/explicit symlink).

    Returns:
        (action, message) where action is one of:
        'HARDLINK', 'SYMLINK', 'FALLBACK_SYMLINK', 'UP_TO_DATE', 'CONFLICT', 'ERROR', 'DRY_RUN'
    """
    status = check_link_status(src, dest)

    # Already matching
    if status == "hardlinked" and not symlink_only:
        return "UP_TO_DATE", f"Already hard-linked: {dest}"
    if status == "symlinked" and symlink_only:
        return "UP_TO_DATE", f"Already symlinked: {dest}"

    # Target is already a symlink to src, but we prefer hardlinks
    if status == "symlinked" and not symlink_only:
        # If source is itself a symlink, keep as symlink
        if src.is_symlink():
            return "UP_TO_DATE", f"Already symlinked: {dest}"

        # If cross-filesystem, hard links cannot be created across filesystems
        if not is_same_filesystem(src, dest):
            return "UP_TO_DATE", f"Already symlinked (cross-filesystem, cannot hard-link): {dest}"

        if not dry_run:
            dest.unlink()
            try:
                os.link(src, dest)
                return "HARDLINK", f"Upgraded symlink to hard link: {dest} -> {src}"
            except OSError:
                # Re-create symlink if hard link fails
                dest.symlink_to(src.resolve())
                return "UP_TO_DATE", f"Already symlinked (hard link unsupported): {dest}"
        else:
            return "HARDLINK", f"[dry-run] Would upgrade symlink to hard link: {dest} -> {src}"

    # Handle broken symlink
    if status == "broken_link":
        if not dry_run:
            dest.unlink()

    # Handle conflict with existing file
    if status == "conflict":
        if backup:
            b_path = backup_path(dest, dry_run)
            msg_b = f"Backed up {dest} to {b_path}"
        elif force:
            if not dry_run:
                if dest.is_dir() and not dest.is_symlink():
                    shutil.rmtree(dest)
                else:
                    dest.unlink()
        else:
            return "CONFLICT", f"Target exists and differs: {dest} (use --force or --backup)"

    # Ensure parent directories are clean and exist
    try:
        clean_parent_symlinks(dest, HERE, force, dry_run)
    except Exception as e:
        return "ERROR", f"Failed preparing parent directories for {dest}: {e}"

    # Execute linking
    if dry_run:
        can_hardlink = not symlink_only and not src.is_symlink() and is_same_filesystem(src, dest)
        mode = "hard link" if can_hardlink else "symlink"
        return "DRY_RUN", f"[dry-run] Would install {dest} -> {src} via {mode}"

    if src.is_symlink():
        try:
            target = os.readlink(src)
            dest.symlink_to(target)
            return "SYMLINK", f"Replicated symlink: {dest} -> {target}"
        except OSError as e:
            return "ERROR", f"Failed replicating symlink {dest}: {e}"

    if symlink_only:
        try:
            dest.symlink_to(src.resolve())
            return "SYMLINK", f"Symlinked: {dest} -> {src}"
        except OSError as e:
            return "ERROR", f"Failed creating symlink {dest}: {e}"

    # Default: Try hard link first
    try:
        os.link(src, dest)
        return "HARDLINK", f"Hard-linked: {dest} -> {src}"
    except OSError as err:
        # Cross-device link or unsupported filesystem fallback to symlink
        try:
            dest.symlink_to(src.resolve())
            return "FALLBACK_SYMLINK", f"Symlinked (hard link fallback): {dest} -> {src}"
        except OSError as sym_err:
            return "ERROR", f"Failed hardlink ({err}) and symlink fallback ({sym_err}) for {dest}"


def setup_git_config(home_dir: Path, dry_run: bool, verbose: bool) -> None:
    """Configure global git ignore if .gitignore_global is installed."""
    gitig = home_dir / ".gitignore_global"
    if gitig.exists():
        cmd = ["git", "config", "--global", "core.excludesfile", str(gitig)]
        if dry_run:
            print(f"[dry-run] Would run: {' '.join(cmd)}")
        else:
            res = subprocess.run(cmd, capture_output=True, text=True)
            if res.returncode == 0:
                print(f"[INIT] Configured git global excludesfile: {gitig}")
            elif verbose:
                print(f"[INIT] Git config error: {res.stderr.strip()}", file=sys.stderr)


def run_init_scripts(active_platforms: List[str], dry_run: bool) -> None:
    """Run platform initialization scripts when --init is specified."""
    if "macos" in active_platforms:
        setup_mac = HERE / "setup" / "macos"
        for script_name in ("brew.sh", "macos.sh"):
            script_path = setup_mac / script_name
            if script_path.is_file():
                if dry_run:
                    print(f"[dry-run] Would execute setup script: bash {script_path}")
                else:
                    print(f"[INIT] Running {script_path}...")
                    subprocess.run(["bash", str(script_path)])


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Clean, minimal dotfiles installer mapping directories to $HOME.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""\
Directory Mapping:
  common/   -> $HOME/ (installed on all platforms)
  linux/    -> $HOME/ (installed on Linux)
  macos/    -> $HOME/ (installed on macOS)

Naming Convention:
  Files and folders prefixed with 'dot-' (e.g. dot-config/, dot-tmux.conf)
  map to their hidden counterpart in $HOME (e.g. .config/, .tmux.conf).

Linking Strategy:
  Uses hard links whenever supported by the filesystem, with automatic
  fallback to symbolic links (e.g. across partitions/filesystems).
""",
    )

    parser.add_argument(
        "targets",
        nargs="*",
        help="Specific platform directories to install (default: auto-detected, e.g. common + current OS).",
    )
    parser.add_argument(
        "-v", "--verbose",
        action="store_true",
        help="Verbose output (shows up-to-date and skipped files).",
    )
    parser.add_argument(
        "-q", "--quiet",
        action="store_true",
        help="Quiet mode (only print summary and errors).",
    )
    parser.add_argument(
        "-f", "--force",
        action="store_true",
        help="Force overwrite of conflicting destination files.",
    )
    parser.add_argument(
        "-b", "--backup",
        action="store_true",
        help="Create backup of conflicting destination files before overwriting.",
    )
    parser.add_argument(
        "-n", "--dry-run",
        action="store_true",
        help="Show what would be installed without making any changes.",
    )
    parser.add_argument(
        "-s", "--symlink-only",
        action="store_true",
        help="Always use symbolic links instead of attempting hard links.",
    )
    parser.add_argument(
        "-i", "--init",
        action="store_true",
        help="Run initial environment setup (e.g. git global config, macOS scripts).",
    )
    parser.add_argument(
        "--os",
        choices=["linux", "macos", "all"],
        help="Explicitly override OS detection ('linux', 'macos', or 'all').",
    )
    parser.add_argument(
        "--dest",
        type=Path,
        default=HOME,
        help="Destination directory root (default: $HOME).",
    )
    parser.add_argument(
        "--list",
        action="store_true",
        help="List all discoverable dotfiles without installing.",
    )

    args = parser.parse_args()

    # Determine available platform directories
    available_platforms = [
        d.name for d in HERE.iterdir()
        if d.is_dir() and d.name in {"common", "linux", "macos"}
    ]

    current_os = args.os if args.os else detect_platform()

    # Determine which platform directories to process
    if args.targets:
        selected_platforms = []
        for t in args.targets:
            t_lower = t.lower()
            if t_lower == "all":
                selected_platforms = ["common", "linux", "macos"]
                break
            elif t_lower in available_platforms:
                selected_platforms.append(t_lower)
            else:
                print(f"Error: Unknown target platform '{t}'. Available: {available_platforms}", file=sys.stderr)
                return 1
    elif current_os == "all":
        selected_platforms = ["common", "linux", "macos"]
    else:
        selected_platforms = ["common"]
        if current_os in available_platforms:
            selected_platforms.append(current_os)

    # Ensure uniqueness while preserving order
    active_platforms = list(dict.fromkeys(selected_platforms))

    if not args.quiet:
        print(f"Platform: {current_os} | Active targets: {', '.join(active_platforms)}")
        print(f"Destination: {args.dest}")
        print(f"Link mode: {'Symlink only' if args.symlink_only else 'Hard link (fallback to symlink)'}")
        print("-" * 60)

    # Discover files: (platform_name, src_path, dest_rel_path, repo_rel_path)
    all_files: List[Tuple[str, Path, Path, Path]] = []
    for platform_name in active_platforms:
        p_dir = HERE / platform_name
        for src_path, dest_rel_path, repo_rel_path in discover_files(p_dir):
            all_files.append((platform_name, src_path, dest_rel_path, repo_rel_path))

    if args.list:
        print(f"Found {len(all_files)} dotfile(s):")
        for p_name, src, dest_rel, repo_rel in all_files:
            target = args.dest / dest_rel
            status = check_link_status(src, target)
            print(f"  [{p_name:6}] {p_name}/{repo_rel} -> {target} ({status})")
        return 0

    counts: Dict[str, int] = {
        "HARDLINK": 0,
        "SYMLINK": 0,
        "FALLBACK_SYMLINK": 0,
        "UP_TO_DATE": 0,
        "CONFLICT": 0,
        "ERROR": 0,
        "DRY_RUN": 0,
    }

    for p_name, src_path, dest_rel_path, repo_rel_path in all_files:
        dest_path = args.dest / dest_rel_path
        action, msg = link_file(
            src=src_path,
            dest=dest_path,
            symlink_only=args.symlink_only,
            force=args.force,
            backup=args.backup,
            dry_run=args.dry_run,
            verbose=args.verbose,
        )

        counts[action] = counts.get(action, 0) + 1

        if action in {"HARDLINK", "SYMLINK", "FALLBACK_SYMLINK"}:
            if not args.quiet:
                print(f"[{action}] {msg}")
        elif action == "DRY_RUN":
            if not args.quiet:
                print(msg)
        elif action == "UP_TO_DATE":
            if args.verbose and not args.quiet:
                print(f"[OK] {msg}")
        elif action == "CONFLICT":
            print(f"[CONFLICT] {msg}", file=sys.stderr)
        elif action == "ERROR":
            print(f"[ERROR] {msg}", file=sys.stderr)

    # Post-install hooks / init
    if args.init:
        setup_git_config(args.dest, args.dry_run, args.verbose)
        run_init_scripts(active_platforms, args.dry_run)

    if not args.quiet:
        print("-" * 60)
        summary = (
            f"Done! Hard-linked: {counts['HARDLINK']}, "
            f"Symlinked: {counts['SYMLINK'] + counts['FALLBACK_SYMLINK']}, "
            f"Up-to-date: {counts['UP_TO_DATE']}, "
            f"Conflicts: {counts['CONFLICT']}, "
            f"Errors: {counts['ERROR']}"
        )
        if args.dry_run:
            summary += f" (Dry-run: {counts['DRY_RUN']} planned)"
        print(summary)

    return 1 if counts["ERROR"] > 0 else 0


if __name__ == "__main__":
    sys.exit(main())
