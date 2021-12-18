fig-Forth and CDOS

Forth's basic unit of virtual memory is the "block". In this version of Forth,
a block contains 256 bytes. This is equivalent to one CDOS disk sector. The
physical location on the disk of block number zero is track zero, sector one.

There are 18 sectors per track. Thus:

    block 0 = track 0, sector 1
    block 1 = track 0, sector 2
    block 2 = track 0, sector 3
    ....
    block 17 = track 0, sector 18
    block 18 = track 1, sector 1
    block 19 = track 1, sector 2
    etc.

In general:

    block # = (track #) * 18 + (sector #) - 1

CDOS organizes files into clusters. There are six sectors per cluster; three
clusters per track. Forth doesn't recognize clusters, but it may be helpful
to know that:

    first block # in cluster = (cluster #) * 6

Therefore, cluster 0 contains blocks 0 - 5 and cluster 1 contains blocks 6 - 11
and so Forth. (ouch!)

Forth program code is stored in "Screens." A screen is 1024 bytes, and uses
four blocks to store its data. Thus screen zero starts with block zero at
track zero, sector one; screen two starts with block five at track zero,
sector five, etc.

What's the point of knowing exactly where on the disk your blocks and screens
are? Well, Forth doesn't recognize CDOS files. It has no knowledge of the disk
directory or the allocation table. Since the directory and allocation table
are stored in cluster zero (track zero, sectors one through six), if you store
something in screens zero or one you will overwrite parts of the directory
and/or allocation table that CDOS needs to find CDOS files on disk. You could
also easily overwrite any CDOS file on disk since Forth doesn't know which
sectors CDOS files occupy. The best way to handle this situation is to make
sure that CDOS files and Forth blocks remain physically separated on the
disk. Mike Weiblen's program HELPER.BA scans the allocation table to find
the lowest unoccupied cluster and then computes an "offset."

OFFSET is a Forth user variable that can be used in this installation to change
the reference location of blocks on disk. If we call the actual location on
disk as the "absolute block", then the "relative block" is the block number
you use to refer to that block of data. They're related like this:

    relative block # + offset = absolute block #

So, if your offset is 100, when you reference block zero you're actually
using block 100 on disk. By finding the lowest unoccupied cluster and setting
the offset accordingly, you will avoid writing over any CDOS files on disk.
This offset is automatically applied to all LIST, LOAD, and CLEAR operations,
so once it is set for that disk, you can proceed as usual.

The best way to maximize disk storage is to start with a freshly formatted
disk and put the files you want on it; for example FORTH.CO and HELPER.BA.
Then compute the offset for that disk, either with HELPER.BA or by examining
the allocation table with a disk utility tool. By using a freshly formatted 
disk, you'll ensure that the files are stored contiguously.

Write the offset for that disk on the label, so that when you use that disk
with Forth, you can set the offset and not have to worry about writing over
the directory or CDOS files. If you want to use the error messages, transfer
them to relative screens four and five.

Note that OFFSET is a user variable that is NOT initialized as a boot-up
literal. It will take on whatever 16 bit value happens to be in locations
56886/56887. So you must set it by nn OFFSET ! prior to using that disk.

See DISKPP.DO1 for more on CDOS disk format.

Tim Ekdom  72575,1473  Feb 27, 1986.
Thanks to Mike Weiblen for M-100 fig-Forth! And to the Forth Interest Group
for putting it in the public domain.

