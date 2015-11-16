#!/native/usr/sbin/dtrace -s
/*
 * zonecalls.d  show top 25 syscalls by zone and process.
 *
 * USAGE: ./zonecalls.d [interval]      # default 1 sec
 *
 * 11-Nov-2015  Joyent          Updated for LX.
 */

#pragma D option quiet
#pragma D option defaultargs
#pragma D option bufsize=512k

inline int TOP = 25;

dtrace:::BEGIN
{
        interval = $1 ? $1 : 1;
}

dtrace:::BEGIN
{
        printf("Top %d syscalls by process. Output every %d secs.\n",
            TOP, interval);
        secs = interval;
}

lx-syscall:::entry
{
        @[execname, probefunc] = count();
        @["", "TOTAL"] = count();
}

profile:::tick-1sec
{
        secs--;
}

profile:::tick-1sec
/secs == 0/
{
        trunc(@, TOP + 1);
        printf("\n %-20s %-20s %s\n", "PROCESS", "SYSCALL",
            "COUNT");
        printa(" %-20s %-20s %@d\n", @);
        secs = interval;
        trunc(@);
}

dtrace:::END
{
        trunc(@);
}
