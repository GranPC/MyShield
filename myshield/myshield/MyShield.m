//
//  MyShield.m
//  myshield
//
//  Created by Gran PC on 17/10/14.
//  Copyright (c) 2014 PENISCorp. All rights reserved.
//

#import "MyShield.h"

#import <objc/runtime.h>

@implementation MyShield

void swizzle( Class class, SEL func, Class newclass, SEL newfunc )
{
    Method oldMethod = class_getInstanceMethod( class, func );
    Method newMethod = class_getInstanceMethod( newclass, newfunc );
    const char *oldEncoding = method_getTypeEncoding( oldMethod );
    const char *newEncoding = method_getTypeEncoding( newMethod );
    
    class_addMethod( class, newfunc, method_getImplementation( newMethod ), newEncoding );
    
    if ( !newMethod )
    {
        NSLog( @"Your override is null! You're gonna crash!" );
    }
    
    if ( !oldMethod )
    {
        NSLog( @"Didn't find a method with that selector!" );
    }
    
    NSLog( @"Old encoding: %s", oldEncoding );
    NSLog( @"New encoding: %s", newEncoding );
    
    newMethod = class_getInstanceMethod( class, newfunc );
    
    method_exchangeImplementations( oldMethod, newMethod );
}

+ ( void ) load
{
    NSLog( @"Loaded!" );
    
    Class Tweet = NSClassFromString( @"TwitterStatus" );
    
    if ( !Tweet )
    {
        NSLog( @"no class! bailing!\n" );
        return;
    }
    
    // swizzle( Tweet, @selector( displayText ), [self class], @selector( override_displayText ) );
    swizzle( Tweet, @selector( isNotADummyStatus ), [self class], @selector( override_isNotADummyStatus ) );
    
    // this "dummy status" thing is actually quite fitting.
}



- ( NSString * ) override_displayText
{
    NSString *oldText = [self override_displayText];
    // return @"SWIZZLE THAT SHIZZLE, OH SHIT IT WORKS"];
    
    return oldText;
}

bool hasSubstring( NSString *haystack, NSString *needle )
{
    return [haystack rangeOfString:needle options:NSCaseInsensitiveSearch].location != NSNotFound;
}

bool hasSubstring_Case( NSString *haystack, NSString *needle )
{
    return [haystack rangeOfString:needle].location != NSNotFound;
}

- ( BOOL ) override_isNotADummyStatus
{
    int bullshitThreshold = 50;
    int score = 0;
    
    NSString *text = [self text];

    if ( hasSubstring( text, @"mergate" ) || hasSubstring( text, @"yourshield" ) || hasSubstring( text, @"SJW" ) )
        score = bullshitThreshold;
    
    // TODO: maybe a settings menu would be cool
    
    if ( hasSubstring( text, @"ethics" ) )
        score += 10;
    
    if ( hasSubstring_Case( text, @"LW" ) )
        score += 10;
    
    if ( hasSubstring( text, @"corrupt" ) && hasSubstring( text, @"journalism" ) )
        score += 20;
    
    float certainty = ( float ) score / ( float ) bullshitThreshold;
    bool isGamerGate = certainty > 0.8f;
    
    if ( isGamerGate )
    {
        NSLog(@"found gamergate tweet (certainty: %i%%); hiding!", (int) ( certainty * 100 ) );
    }
    
    return !isGamerGate;
}


@end
