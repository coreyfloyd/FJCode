//
//  KBCollectionExtensions.h
//
//  Created by Guy English on 25/02/08.
//  Copyright 2008 Kickingbear. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/NSObjCRuntime.h>
#import <objc/runtime.h>

/*
 
The real magic isn't apparent from the header files. KBCollectionExtensions extends valueForKeyPath:
with a set of new features.
 
- method calls

 NSArray *results = [myCollection valueForKeyPath: @"[collect].name"];
 
 Method calls go between []'s. In this case since there's no paramater given an implicit paramater is
 assume. The result of this expression is basically: [myCollection collect: @"name"] - the collect method
 iterates over the objects in the collection and gathers all the values for the key 'name'.
 
 You can have more complicated method calls:
 
 NSArray *results = [myCollection valueForKeyPath: @"[collect].name.[componentsSeparatedByString: ' ']"];
 
 The result of this expression is that componentsSeparatedByString: @" " will be called for the value of 'name'
 in each object in the collection. The resulting array of components will then be gathered by the 'collect' call.
 The end result is an array of subarrays containing the words of the name.
 
- inline predicates
 
 NSArray *results = [myCollection valueForKeyPath: @"[collect].{salary>100}.jobTitle"];
 
 Predicates can be specified between {}'s. The predicate string is used to create an NSPredicate which is then used
 to evaluate the object. If the object matches the predicate then it returns the value of the remainder of the keypath
 otherwise it returns nil. In this case we use the predicate to filter the collection based on a salary. Each object 
 is checked if it's salary property is greater than 100. If it is then the value of it's jobTitle property is returned.
 If it's not nil is returned. Collect gathers the results ignoring nil results. The end effect of this is that you'll
 get an array of all the job titles where salary is > 100.
 
- inline value transformers
 
 NSArray *results = [myCollection valueForKeyPath: @"[collect].<NSUnarchiveFromDataTransformerName>.imageData"];
 
 You may specify the name of a value transformer between <>'s. The value transformer is handed the value of the
 remainder of the keypath. In this case we use the unarchive from data value transformer and hand it some imageData.
 The result of the transformer is then collected by 'collect'. The resulting array would contain unarchived NSImage
 instances. You may specify any of the build in value transformers by their constants or you can use your own value
 transformers names.
 
 
- example:
 
NSArray *waitsAlbumCovers = [myRecordCollection valueForKeyPath: @"[collect].{artist=='Tom Waits'}.<NSUnarchiveDromDataTransformerName>.albumCoverImageData"];
 
 waitsAlbumCovers now conatins NSImage instances for each of the albums in my collection where 'Tom Waits' is the artist. Nifty, ain't it?
 
NSString *albumsTitles = [myRecordCollection valueForKeyPath: @"[concatenate: * withSeparator: ', '].{artist=='Tom Waits'}.albumTitle"];
 
 albumTitles contains a string of all Tom Wait's album titles separated with ', '. This example shows the use of a special place holder symbol.
 The '*' expands during evaluation to the remainder of the keypath. In this case the resulting call on the collection would look like:
 [myRecordCollection concatentate: @"{artist=='Tom Waits'}.albumTitle" withSeparator: @", "];
 The concatenate:withSeparator: method would then iterate over the contents of the collection and concatenate the value of
 {artist=='Tom Waits'}.albumTitle placing the separator in between. 
 
- NSObject becomes a collection
 
 KBCollectionExtensions also implements NSFastEnumeration on NSObject. This lets you treat any single object like a collection that can be iterated over.
 NSString *thisIsAnExample = @"My example string";
 for ( NSString *string in thisIsAnExample ) NSLog( @"%@", string );
 would result in "My example string" being printed out. This lets us do stuff like:
 NSArray *names = [myObject valueForKeyPath: @"[collect].{salary<100}.jobTitle"];
 and not worry if we're dealing with a single object or a collection.
 
 
- oh, and please consider the implementation more a proof of concept than anything else. there's tons and tons of things that could be optimized
 or made better in any number of ways. 
 
*/

void KBInitializeCollectionExtensions( void ); // call this in main before you do anything

@interface NSObject ( KBCollectionExtensions )  <NSFastEnumeration>

- (id) asCollection;
- (id) collect: (NSString*) keyPath;
- (id) concatenate: (NSString*) keyPath withSeparator: (NSString*) separator;
- (id) concatenate: (NSString*) keyPath;

@end

// dictionary needs to be treated slightly specially because of the way it behaves as a colection
@interface NSDictionary ( KBCollectionExtentions )
- (id) asCollection;
@end


