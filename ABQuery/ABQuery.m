/*
 *    Copyright 2003 Brendan Cully <brendan@kublai.com>
 *
 *    This program is free software; you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *     the Free Software Foundation; either version 2 of the License, or
 *     (at your option) any later version.
 * 
 *     This program is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *     GNU General Public License for more details.
 * 
 *     You should have received a copy of the GNU General Public License
 *     along with this program; if not, write to the Free Software
 *     Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111, USA.
 *
 */

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

int main (int argc, const char *argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    ABAddressBook *book = [ABAddressBook sharedAddressBook];
    ABSearchElement *firstNameSearch, *lastNameSearch, *emailSearch, *search;
    NSArray *searchTerms;
    NSArray *results;
    NSEnumerator *addressEnum;
    ABPerson *person;
    NSString *key = [NSString stringWithCString:argv[1]];

    firstNameSearch = [ABPerson searchElementForProperty:kABFirstNameProperty
		                  label:nil
		                  key:nil
				  value:key
                                  comparison:kABContainsSubStringCaseInsensitive];
    lastNameSearch = [ABPerson searchElementForProperty:kABLastNameProperty
		                  label:nil
		                  key:nil
				  value:key
                                  comparison:kABContainsSubStringCaseInsensitive];
    emailSearch = [ABPerson searchElementForProperty:kABEmailProperty
                              label:nil
			      key:nil
			      value:key
			      comparison:kABContainsSubStringCaseInsensitive];
    searchTerms = [NSArray arrayWithObjects:firstNameSearch, lastNameSearch, emailSearch, nil];
    search = [ABSearchElement searchElementForConjunction:kABSearchOr
                                children:searchTerms];
    results = [book recordsMatchingSearchElement:search];

    addressEnum = [results objectEnumerator];

    while (person = (ABPerson*)[addressEnum nextObject]) {
      NSString *fullName = [NSString stringWithFormat:@"%s %s", [[[person valueForProperty:kABFirstNameProperty] description] cString], [[[person valueForProperty:kABLastNameProperty] description] cString]];
      
      ABMultiValue *emails = [person valueForProperty:kABEmailProperty];
      int count = [emails count];
      int i;
      for (i = 0; i < count; i++) {
         NSString *email = [emails valueAtIndex:i];
	 printf("%s\t%s\t(AddressBook)\n", [email cString], [fullName cString]);
      }
    }

    [pool release];

    return 0;
}