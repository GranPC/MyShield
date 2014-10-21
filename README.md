MyShield
========

Tool to hide tweets containing certain keywords from Twitter for Mac.

Building
--------

Grab yourself a copy of mach\_inject from [GitHub](https://github.com/rentzsch/mach_inject) and build it, since you'll need `mach_inject_bundle.framework` (you may be able to find this on your search engine of choice as well).

Build the following projects in Xcode: `injector.xcodeproj` and `myshield.xcodeproj`. I used Xcode 5.0.2, but chances are it'll work on most relatively modern versions.

Downloads
---------

If you can't be bothered building it you can just download a copy from [PENISCorp](https://peniscorp.com/myshield_r2.dmg). Please make sure you're running a legit version (the SHA-1 checksum for "myshield_r2.dmg" should be `7f116a784cf8c34ff6f07e00a001c7bc8bfc877b`) -- and you might want to scan the files for good measure. You will need to run these files as root, so please make sure they're not compromised.

Usage
-----

Place the built/downloaded files in `/System/<some subdirectory>`. You need to place it in /System to allow Twitter (which is a sandboxed app) to read it. Put mach_inject in `<your chosen directory>/Frameworks/` (you will have to create that directory). Navigate to that folder in a terminal and run these commands:

    jesunoiMac:MyShield granpc$ sudo -s
    Password:
    root /System/MyShield # ps aux | grep Twitter
    granpc           1204   0.0  0.6  3074308 150700   ??  S     6:35PM   0:09.70 /Applications/Twitter.app/Contents/MacOS/Twitter -psn_0_81940
    root             1773   0.0  0.0  2432784    624 s005  S+    7:19PM   0:00.00 grep Twitter

If it's your first time using MyShield, run this command:

    root /System/MyShield # install_name_tool -add_rpath . injector 
    root /System/MyShield # chmod 755 injector 

Note the process ID (first number) for `/Applications/Twitter.app/Contents/MacOS/Twitter` -- in this case it is `1204`, and run the command `./injector <twitterProcessID>

    root /System/MyShield # ./injector 1204
    Success!

Refresh your timeline and you should no longer see blocked tweets.

*WARNING*: This is experimental software. It has only been tested on OS X 10.9.4 and OS X 10.9.5, running Twitter.app version 3.0.1 (not the latest -- although it will most likely work on the latest). By using it you agree that I will not be held responsible for any damage arising from its use.

If you run into any odd issues feel free to post an issue/[email me](mailto:gran.pc@gmail.com). 
