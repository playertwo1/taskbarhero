import ctypes
from ctypes import wintypes
import os
import sys

class STARTUPINFO(ctypes.Structure):
    _fields_ = [
        ('cb', wintypes.DWORD),
        ('lpReserved', wintypes.LPWSTR),
        ('lpDesktop', wintypes.LPWSTR),
        ('lpTitle', wintypes.LPWSTR),
        ('dwX', wintypes.DWORD),
        ('dwY', wintypes.DWORD),
        ('dwXSize', wintypes.DWORD),
        ('dwYSize', wintypes.DWORD),
        ('dwXCountChars', wintypes.DWORD),
        ('dwYCountChars', wintypes.DWORD),
        ('dwFillAttribute', wintypes.DWORD),
        ('dwFlags', wintypes.DWORD),
        ('wShowWindow', wintypes.WORD),
        ('cbReserved2', wintypes.WORD),
        ('lpReserved2', ctypes.c_char_p),
        ('hStdInput', wintypes.HANDLE),
        ('hStdOutput', wintypes.HANDLE),
        ('hStdError', wintypes.HANDLE),
    ]

class PROCESS_INFORMATION(ctypes.Structure):
    _fields_ = [
        ('hProcess', wintypes.HANDLE),
        ('hThread', wintypes.HANDLE),
        ('dwProcessId', wintypes.DWORD),
        ('dwThreadId', wintypes.DWORD),
    ]

def launch_on_default_desktop(cmd_line):
    si = STARTUPINFO()
    si.cb = ctypes.sizeof(STARTUPINFO)
    si.lpDesktop = "WinSta0\\Default"
    
    pi = PROCESS_INFORMATION()
    
    # CREATE_NEW_CONSOLE = 0x00000010, DETACHED_PROCESS = 0x00000008
    creation_flags = 0x00000010
    
    success = ctypes.windll.kernel32.CreateProcessW(
        None,
        cmd_line,
        None,
        None,
        False,
        creation_flags,
        None,
        None,
        ctypes.byref(si),
        ctypes.byref(pi)
    )
    
    if success:
        print(f"Launched on WinSta0\\Default with PID: {pi.dwProcessId}")
        ctypes.windll.kernel32.CloseHandle(pi.hProcess)
        ctypes.windll.kernel32.CloseHandle(pi.hThread)
        return True
    else:
        err = ctypes.windll.kernel32.GetLastError()
        print(f"Failed to launch. Win32 Error: {err}")
        return False

if __name__ == "__main__":
    local_app_data = os.environ.get("LOCALAPPDATA", "")
    emulator_exe = os.path.join(local_app_data, "Android", "Sdk", "emulator", "emulator.exe")
    avd_name = "Pixel_9"
    cmd = f'"{emulator_exe}" -avd {avd_name}'
    print(f"Starting emulator: {cmd}")
    launch_on_default_desktop(cmd)
