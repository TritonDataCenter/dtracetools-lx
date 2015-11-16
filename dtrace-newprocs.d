#!/native/usr/sbin/dtrace -s
/*
 * Snoop new processes and arguments.
 *
 */
proc:::exec-success { trace(curpsinfo->pr_psargs); }
