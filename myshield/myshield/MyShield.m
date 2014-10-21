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
    
    Class Stream = NSClassFromString( @"TwitterConcreteStatusesStream" );
    
    if ( !Stream )
    {
        NSLog( @"missing stream class! bailing!\n" );
        return;
    }
    
    // swizzle( Tweet, @selector( displayText ), [self class], @selector( override_displayText ) );
    swizzle( Tweet, @selector( isNotADummyStatus ), [self class], @selector( override_isNotADummyStatus ) );
    swizzle( Stream, @selector( addStatuses: ), [self class], @selector( override_addStatuses: ) );
    
    // this "dummy status" thing is actually quite fitting.
}



- ( NSString * ) override_displayText
{
    NSString *oldText = [self override_displayText];
    // return @"SWIZZLE THAT SHIZZLE, OH SHIT IT WORKS"];
    
    return oldText;
}

bool hasSubstring( NSString *haystack, NSString *needle, bool sensitive )
{
    const char *pHaystack;
    const char *pNeedle;
    
    if ( sensitive )
    {
        pHaystack = [haystack UTF8String];
        pNeedle = [needle UTF8String];
    }
    else
    {
        pHaystack = [[haystack lowercaseString] UTF8String];
        pNeedle = [[needle lowercaseString] UTF8String];
    }
    
    return strstr( pHaystack, pNeedle ) != NULL;
}

bool isGamerGate( id tweet, float *certainty )
{
    int bullshitThreshold = 50;
    int score = 0;
    
    NSString *text = [tweet text];
    
    if ( hasSubstring( text, @"mergate", false ) || hasSubstring( text, @"yourshield", false ) || hasSubstring( text, @"SJW", false ) )
        score = bullshitThreshold;
    
    // TODO: maybe a settings menu would be cool
    
    if ( hasSubstring( text, @"ethics", false ) )
        score += 10;
    
    if ( hasSubstring( text, @"LW", true ) )
        score += 10;
    
    if ( hasSubstring( text, @"corrupt", false ) && hasSubstring( text, @"journalism", false ) )
        score += 20;
    
    *certainty = ( float ) score / ( float ) bullshitThreshold;
    bool isGamerGate = *certainty > 0.8f;
    
    return isGamerGate;
}

- ( void ) override_addStatuses:( NSArray * ) statuses
{
    // statuses is an array of tweets
    // don't add gamergate tweets at all, so it doesn't show an unread counter
    NSMutableArray *array = [NSMutableArray arrayWithArray:statuses];
    
    if ( [statuses count] > 0 )
    {
        for ( id status in [array reverseObjectEnumerator] )
        {
            float certainty = 0.0f;
            
            if ( isGamerGate( status, &certainty ) )
            {
                NSLog(@"found gamergate tweet (certainty: %i%%); discarding!", (int) ( certainty * 100 ) );
                [array removeObject:status];
            }
        }
    }
    
    [self override_addStatuses:[NSArray arrayWithArray:array]]; // array array array
}

- ( BOOL ) override_isNotADummyStatus
{
    float certainty = 0.0f;
    
    if ( isGamerGate( self, &certainty ) )
    {
        NSLog(@"found gamergate tweet (certainty: %i%%); hiding!", (int) ( certainty * 100 ) );
        
        return NO;
    }
    
    return YES;
}


@end
