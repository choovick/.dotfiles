/* TuiosDaemon.app launcher: execs `tuios daemon` in-process so macOS Local Network Privacy attributes the
   daemon, and every pane process it spawns, to this app bundle (a grantable identity).
   A bare launch runs `tuios daemon`; any arguments are forwarded verbatim as tuios arguments, so
   `open -n -a TuiosDaemon --args --server lantest daemon --no-restore` starts a throwaway test daemon.
   stdout/stderr are appended to ~/Library/Logs/tuios-daemon.log because launchd/Finder give the app no
   terminal. */
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#ifndef TUIOS_BIN
#define TUIOS_BIN "/opt/homebrew/bin/tuios"
#endif

int main(int argc, char **argv) {
  const char *home = getenv("HOME");
  char logpath[512];
  snprintf(logpath, sizeof logpath, "%s/Library/Logs/tuios-daemon.log", home ? home : "/tmp");
  int log = open(logpath, O_WRONLY | O_CREAT | O_APPEND, 0644);
  if (log >= 0) {
    dup2(log, STDOUT_FILENO);
    dup2(log, STDERR_FILENO);
  }

  /* LaunchServices gives apps a minimal PATH; panes inherit the daemon's environment. */
  setenv("PATH", "/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin", 1);

  char *exec_args[255];
  int n = 0;
  exec_args[n++] = "tuios";
  if (argc == 1) {
    exec_args[n++] = "daemon";
  } else {
    for (int i = 1; i < argc && n < 253; i++) exec_args[n++] = argv[i];
  }
  exec_args[n] = NULL;
  execv(TUIOS_BIN, exec_args);
  perror("tuios-daemon-app: exec " TUIOS_BIN);
  return 1;
}
