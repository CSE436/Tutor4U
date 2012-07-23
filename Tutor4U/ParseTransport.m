//
//  ParseTransport.m
//  Tutor4U
//
//  Created by Zeddy Chirombe on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ParseTransport.h"


@implementation ParseTransport


-(id)init {
    self = [super init];

    return self;
}

-(int)setUserProfile:(NSString *)_tutor4u_id :(NSString *)_firstName :(NSString *)_lastName :(NSString *)_phoneNumber
{
    userProfile = [PFObject objectWithClassName:@"userProfile"];
    [userProfile setObject:_tutor4u_id forKey:@"Tutor4uID"];
    [userProfile setObject:_firstName forKey:@"FirstName"];
    [userProfile setObject:_lastName forKey:@"LastName"];
    if ( _phoneNumber )
        [userProfile setObject:_phoneNumber forKey:@"PhoneNumber"];
    else 
        [userProfile setObject:[NSNull null] forKey:@"PhoneNUmber"];
    
    [userProfile save];
    
    return T4U_SUCCESS;
}

-(int)setUserAddress:(NSString *)_tutor4u_id :(NSString *)_streetAddr :(NSString *)_apt :(NSString *)_city :(NSString *)_state :(NSString *)_zipCode
{
    userAddress = [PFObject objectWithClassName:@"userAddress"];
    [userAddress setObject:_tutor4u_id forKey:@"Tutor4uID"];
    if ( _streetAddr )
        [userAddress setObject:_streetAddr forKey:@"StreetAddress"];
    else 
        [userProfile setObject:[NSNull null] forKey:@"StreetAddress"];
    if ( _apt ) 
        [userAddress setObject:_apt forKey:@"Apartment"];
    else 
        [userProfile setObject:[NSNull null] forKey:@"Apartment"];
    if ( _city )
        [userAddress setObject:_city forKey:@"City"];
    else 
        [userProfile setObject:[NSNull null] forKey:@"City"];
    if ( _state )
        [userAddress setObject:_state forKey:@"State"];
    else 
        [userProfile setObject:[NSNull null] forKey:@"State"];
    if ( _zipCode )
        [userAddress setObject:_zipCode forKey:@"ZipCode"];
    else 
        [userProfile setObject:[NSNull null] forKey:@"ZipCode"];
    [userAddress save];
    
    return T4U_SUCCESS;
}

-(int)uploadTutor:(NSString *)_tutor4u_id :(NSString *)_subject :(NSString *)_hourlyRate :(NSString *)_location :(NSString *)_rating
{
    tutorSession = [PFObject objectWithClassName:@"activeTutors"];
    [tutorSession setObject:_tutor4u_id forKey:@"Tutor4uID"];
    [tutorSession setObject:_subject forKey:@"Subject"];
    [tutorSession setObject:_hourlyRate forKey:@"HourlyRate"];
    [tutorSession setObject:_location forKey:@"Location"];
    [tutorSession setObject:_rating forKey:@"Rating"];
    [tutorSession save];
    
    return T4U_SUCCESS;
}
-(int)uploadStudent:(NSString *)_tutor4u_id :(NSString *)_subject :(NSString *)_hourlyRate :(NSString *)_location :(NSString *)_rating
{
    studentSession = [PFObject objectWithClassName:@"activeStudents"];
    if ( [PFUser currentUser] )
        [userProfile setObjectId:[PFUser currentUser].objectId];
    [studentSession setObject:_tutor4u_id forKey:@"Tutor4uID"];
    [studentSession setObject:_subject forKey:@"Subject"];
    [studentSession setObject:_hourlyRate forKey:@"HourlyRate"];
    [studentSession setObject:_location forKey:@"Location"];
    [studentSession setObject:_rating forKey:@"Rating"];  
    [studentSession save];
    
    return T4U_SUCCESS;
}


-(PFObject *)getUserProfile:(NSString *)_tutor4u_id
{     
    if(userProfile == nil) {
        PFQuery *query = [PFQuery queryWithClassName:@"userProfile"];
        [query whereKey:@"Tutor4uID" equalTo:_tutor4u_id];
        userProfile = [query getFirstObject];
        if(userProfile == nil) 
            return nil;
    }
    return userProfile;
}
-(PFObject *)getUserAddress:(NSString *)_tutor4u_id
{
    if(userAddress == nil) {
        PFQuery *query = [PFQuery queryWithClassName:@"userAddress"];
        [query whereKey:@"Tutor4uID" equalTo:_tutor4u_id];
        userAddress = [query getFirstObject];
    }
    return userAddress;
}
-(PFObject *)downloadTutor:(NSString *)_tutor4u_id
{
    PFQuery *query = [PFQuery queryWithClassName:@"activeTutors"];
    [query whereKey:@"Tutor4uID" equalTo:_tutor4u_id];
    PFObject *myObj = [query getFirstObject];
    return myObj;
}
-(PFObject *)downloadStudent:(NSString *)_tutor4u_id
{
    PFQuery *query = [PFQuery queryWithClassName:@"activeStudents"];
    [query whereKey:@"Tutor4uID" equalTo:_tutor4u_id];
    PFObject *myObj = [query getFirstObject];
    return myObj;
}
-(NSArray *)downloadTutors
{
    PFQuery *query = [PFQuery queryWithClassName:@"activeTutors"];
    [query whereKey:@"Tutor4uID" notEqualTo:@""];
    query.limit = 10;
    [query orderByDescending:@"Rating"];
    return [query findObjects];
}
-(NSArray *)downloadStudents
{
    PFQuery *query = [PFQuery queryWithClassName:@"activeStudents"];
    [query whereKey:@"Tutor4uID" notEqualTo:@""];
    query.limit = 20;
    [query orderByDescending:@"Rating"];
    return [query findObjects];
}



-(int)dropProfile
{
    [userProfile deleteInBackground];
    [userAddress deleteInBackground];
    //[userBanking deleteInBackground]; When available - 
    return T4U_SUCCESS;
}
-(int)dropTutor
{
    [tutorSession deleteInBackground];
    return T4U_SUCCESS;
}
-(int)dropStudent
{
    [studentSession deleteInBackground];
    return T4U_SUCCESS;
}

-(void)logout 
{
    [PFUser logOut];
}
@end



