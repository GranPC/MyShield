//
//  main.cpp
//  injector
//
//  Created by Gran PC on 17/10/14.
//  Copyright (c) 2014 PENISCorp. All rights reserved.
//

#import <AppKit/AppKit.h>
#import <Foundation/Foundation.h>

#import "mach_inject_bundle.h"
#import <mach/mach_error.h>

int main(int argc, const char * argv[])
{
    NSFileManager *filemgr = [[NSFileManager alloc] init];
    NSString *path = [[filemgr currentDirectoryPath] stringByAppendingString:@"/myshield.bundle"];
    
    if ( argv[ 1 ] == NULL ) return 1;
    pid_t twitter = atoi( argv[ 1 ] );
    
    mach_error_t err = mach_inject_bundle_pid( [path fileSystemRepresentation], twitter );
    if ( !err )
    {
        printf( "Success!\n" );
    }
    else
    {
        printf( "Failed! %i (%s) for path %s and PID %i\n", err, mach_error_string( err ), [path fileSystemRepresentation], twitter );
    }
    
    return 0;
}

