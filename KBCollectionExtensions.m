//
//  KBCollectionExtensions.m
//
//  Created by Guy English on 25/02/08.
//  Copyright 2008 Kickingbear. All rights reserved.
//

#import "KBCollectionExtensions.h"

#import <objc/objc-runtime.h>


static IMP _originalValueForKeyPathMethod = NULL; // saved off implementation of the original valueForKeyPath method

@implementation NSObject ( KBCollectionExtentions ) 

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len;
{
	if ( state->state == 1 ) return 0;
	state->state = 1;
	state->mutationsPtr = (unsigned long*)self;
	state->itemsPtr = &self;
	return 1;
}

- (id) asCollection
{
	return self;
}

- (id) collect: (NSString*) keyPath
{
	NSMutableArray *result = [NSMutableArray array];
	for ( id object in [self asCollection] )
	{
		id value = [object valueForKeyPath: keyPath];
		if ( value != nil ) [result addObject: value];
	}
	
	return result;
}

- (id) concatenate: (NSString*) keyPath withSeparator: (NSString*) separator
{
	NSMutableArray *result = [NSMutableArray array];
	for ( id object in [self asCollection] )
	{
		id value = [object valueForKeyPath: keyPath];
		if ( value != nil ) [result addObject: value];
	}
	
	return [result componentsJoinedByString: separator];
}

- (id) concatenate: (NSString*) keyPath
{
	return [self concatenate: keyPath withSeparator: nil];
}

@end

@implementation NSDictionary ( KBCollectionExtentions )

- (id) asCollection
{
	return [NSArray arrayWithObject: self];
}

@end


// this class exists purely to hold the method implementation for valueForKeyPath which we later swizzle into NSObject.
@interface KBCollectionExtention : NSObject
{
}

@end

@implementation KBCollectionExtention

- (id) valueForKeyPath: (NSString*) keyPath
{
	NSArray *path = [keyPath componentsSeparatedByString: @"."];
	unsigned i, max;
	max = [path count];
	id value = self;
	for ( i = 0; i < max; i++ )
	{
		NSString *pathComponent = [path objectAtIndex: i];
		if ( [pathComponent hasPrefix: @"{"] )
		{
			NSString *predicateString = [pathComponent substringWithRange: NSMakeRange( 1, [pathComponent length]-2 )];
			NSPredicate *pred = [NSPredicate predicateWithFormat: predicateString];
			if ( [pred evaluateWithObject: self] )
			{
				NSString *pathArgument = [[path subarrayWithRange: NSMakeRange( i+1, max-(i+1) )] componentsJoinedByString: @"."];
				return [self valueForKeyPath: pathArgument];
			}
			else
			{
				return nil;
			}
		}
		else if ( [pathComponent hasPrefix: @"<"] )
		{
			NSDictionary *builtInLookup = [NSDictionary dictionaryWithObjectsAndKeys: [NSValueTransformer valueTransformerForName: NSNegateBooleanTransformerName], @"NSNegateBooleanTransformerName",  [NSValueTransformer valueTransformerForName: NSIsNilTransformerName], @"NSIsNilTransformerName",  [NSValueTransformer valueTransformerForName: NSIsNotNilTransformerName], @"NSIsNotNilTransformerName",  [NSValueTransformer valueTransformerForName: NSUnarchiveFromDataTransformerName], @"NSUnarchiveFromDataTransformerName", [NSValueTransformer valueTransformerForName: NSKeyedUnarchiveFromDataTransformerName], @"NSKeyedUnarchiveFromDataTransformerName", nil];
			NSString *transformerName = [pathComponent substringWithRange: NSMakeRange( 1, [pathComponent length]-2 )];
			NSValueTransformer *transformer = nil;
			if ( [builtInLookup objectForKey: transformerName] != nil )
			{
				transformer = [builtInLookup objectForKey: transformerName];
			}
			else
			{
				transformer = [NSValueTransformer valueTransformerForName: transformerName];
			}
			if ( transformer == nil ) return [self valueForKeyPath: keyPath];
			NSString *pathArgument = [[path subarrayWithRange: NSMakeRange( i+1, max-(i+1) )] componentsJoinedByString: @"."];
			id valueToTransform = [self valueForKeyPath: pathArgument];
			id newValue = [transformer transformedValue: valueToTransform];
			return newValue;
		}
		else if ( [pathComponent hasPrefix: @"["] )
		{
			NSString *pathArgument = [[path subarrayWithRange: NSMakeRange( i+1, max-(i+1) )] componentsJoinedByString: @"."];
			NSString *methodString = [pathComponent substringWithRange: NSMakeRange( 1, [pathComponent length]-2 )];
			NSScanner *scanner = [[NSScanner alloc] initWithString: methodString];
			BOOL isScanningArg = NO;
			NSMutableArray *pieces = [NSMutableArray array];
			NSMutableArray *args = [NSMutableArray array];
			while ( [scanner isAtEnd] == NO )
			{
				NSString *methodPiece = nil;
				if ( isScanningArg == NO )
				{
					if ( [scanner scanUpToCharactersFromSet: [NSCharacterSet characterSetWithCharactersInString: @": '"] intoString: &methodPiece] )
					{
						[pieces addObject: methodPiece];
					}
					[scanner scanCharactersFromSet: [NSCharacterSet characterSetWithCharactersInString: @": "] intoString: nil];
				}
				else
				{
					unsigned scanLocation = [scanner scanLocation];
					
					if ( [scanner scanString: @"'" intoString: nil] == YES )
					{
						NSString *stringValue = nil;
						NSCharacterSet *skippedCharacters = [scanner charactersToBeSkipped];
						[scanner setCharactersToBeSkipped: [NSCharacterSet characterSetWithCharactersInString: @""]];
						[scanner scanUpToString: @"'" intoString: &stringValue];
						[scanner setCharactersToBeSkipped: skippedCharacters];
						if ( stringValue != nil ) [args addObject: stringValue];
						[scanner scanString: @"'" intoString: nil];
					}
					else
					{
						[scanner setScanLocation: scanLocation];
						if ( [scanner scanString: @"*" intoString: nil] == NO )
						{
							if ( [scanner scanString: @"@" intoString: nil] == NO )
							{
								double value = 0;
								[scanner scanDouble: &value];
								[args addObject: [NSNumber numberWithDouble: value]];
							}
							else
							{
								[args addObject: @"@"];
							}
						}						
						else
						{
							[args addObject: @"*"];
						}
					}
				}
				isScanningArg = !isScanningArg;
			}
			
			[scanner release];
			NSString *selectorName = nil;
			if ( [pieces count] == 1 && [args count] == 0 )
			{
				selectorName = [[pieces objectAtIndex: 0] stringByAppendingString: @":"];
				[args addObject: @"*"];
			}
			else
			{
				selectorName = [[pieces componentsJoinedByString: @":"] stringByAppendingString: @":"];
			}
			SEL selector = NSSelectorFromString( selectorName );
			NSMethodSignature *signature = [value methodSignatureForSelector: selector];
			if ( signature == nil )
			{
				NSString *reason = [NSString stringWithFormat: @"%@ Does not implement %@.", [value class], selectorName];
				[[NSException exceptionWithName: @"Unimplemented Method" reason: reason userInfo: nil] raise];
				
			}
			NSInvocation *invocation = [NSInvocation invocationWithMethodSignature: signature];
			[invocation setSelector: selector];
			id evaluatedValue = nil;
			BOOL didEvaluate = NO;
			unsigned i, max;
			max = [args count];
			for ( i = 0; i < max; i++ )
			{
				id arg = [args objectAtIndex: i];
				
				if ( [arg isEqual: @"*"] ) arg = pathArgument;
				if ( [arg isEqual: @"@"] )
				{
					if ( didEvaluate == NO )
					{
						evaluatedValue = [value valueForKeyPath: pathArgument];
						didEvaluate = YES;
					}
					arg = evaluatedValue;
				}
				
				[invocation setArgument: &arg atIndex: i+2];
			}
			[invocation invokeWithTarget: value];
			id returnValue = nil;
			[invocation getReturnValue: &returnValue];
			return returnValue;
		}
		else
		{
			value = [value valueForKey: [path objectAtIndex: i]];		
		}
	}
	
	return value;
}

@end

// this swizzles in our new valueForKeyPath method
void KBInitializeCollectionExtensions( void )
{
	Method newValueForKeyPathMethod = class_getInstanceMethod( [KBCollectionExtention class], @selector( valueForKeyPath: ) );
	_originalValueForKeyPathMethod = class_replaceMethod( [NSObject class],  @selector( valueForKeyPath: ), method_getImplementation( newValueForKeyPathMethod ), "@^v^c" );
}
