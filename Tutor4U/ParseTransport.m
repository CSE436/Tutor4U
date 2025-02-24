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

//
// Check if we have a current user.
// If not unsubscribe from all channels
//
+(void)pushChannelManagement {
    if ( [PFUser currentUser] == nil ) {
        NSSet* subscribedChannels = [PFPush getSubscribedChannels:nil];
        for ( NSString* channel in [subscribedChannels allObjects] ) {
            [PFPush unsubscribeFromChannelInBackground:channel];
        }
    }
}


-(int)setUserProfile:(NSString *)_tutor4u_id :(NSString *)_firstName :(NSString *)_lastName :(NSString *)_phoneNumber
{
    userProfile =  [self getUserProfile:[PFUser currentUser].username];   
    
    if ( userProfile == nil )
        userProfile = [PFObject objectWithClassName:@"userProfile"];
    [userProfile setObject:_tutor4u_id forKey:@"Tutor4uID"];
    [userProfile setObject:_firstName forKey:@"FirstName"];
    [userProfile setObject:_lastName forKey:@"LastName"];
    if ( _phoneNumber )
        [userProfile setObject:_phoneNumber forKey:@"PhoneNumber"];
    else 
        [userProfile setObject:[NSNull null] forKey:@"PhoneNumber"];
    
    [userProfile save];
    
    return T4U_SUCCESS;
}

-(int)setUserAddress:(NSString *)_tutor4u_id :(NSString *)_streetAddr :(NSString *)_apt :(NSString *)_city :(NSString *)_state :(NSString *)_zipCode
{
    userAddress =  [self getUserAddress:[PFUser currentUser].username];
    if ( userAddress == nil )
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

-(int)setUserRating:(NSString *)_tutor4u_id :(NSNumber *)_summedReviews :(NSNumber *)_totalReviews
{
    userRating = [self getUserRating:[PFUser currentUser].username];
    if ( userRating == nil )
        userRating = [PFObject objectWithClassName:@"tutorRating"];
    [userRating setObject:_tutor4u_id forKey:@"Tutor4uID"];
    if ( _summedReviews )
        [userRating setObject:_summedReviews forKey:@"SumOfReviews"];
    else 
        [userRating setObject:[NSNull null] forKey:@"SumOfReviews"];
    
    if ( _totalReviews )
        [userRating setObject:_totalReviews forKey:@"ReviewsCount"];
    else 
        [userRating setObject:[NSNull null] forKey:@"ReviewsCount"];
    [userRating save];
    
    return T4U_SUCCESS;
}
-(int)setTutorRating:(NSString *)_tutor4u_id :(NSNumber *)_summedReviews :(NSNumber *)_totalReviews
{
    PFObject *tutorRating = [self getUserRating:_tutor4u_id];
    if ( tutorRating == nil) 
        tutorRating = [PFObject objectWithClassName:@"tutorRating"];
    [tutorRating setObject:_tutor4u_id forKey:@"Tutor4uID"];
    if ( _summedReviews )
        [tutorRating setObject:_summedReviews forKey:@"SumOfReviews"];
    else 
        [tutorRating setObject:[NSNull null] forKey:@"SumOfReviews"];
    
    if ( _totalReviews )
        [tutorRating setObject:_totalReviews forKey:@"ReviewsCount"];
    else 
        [tutorRating setObject:[NSNull null] forKey:@"ReviewsCount"];
    [tutorRating save];
    
    return T4U_SUCCESS;
}


-(int)uploadTutor:(NSString *)_tutor4u_id :(NSString *)_subject :(NSString *)_hourlyRate :(NSString *)_location :(NSString *)_rating
{
    tutorSession = [self downloadTutor:_tutor4u_id];
    if ( !tutorSession) 
        tutorSession = [PFObject objectWithClassName:@"activeTutors"];
    
    [tutorSession setObject:_tutor4u_id forKey:@"Tutor4uID"];
    
    NSLog(@"uploadTutor");
    
    if ( _subject != nil && [_subject length] > 0 )
        [tutorSession setObject:_subject forKey:@"Subject"];
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"ERROR:  You must state what subject you wish to tutor for" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return 1;
    }
    
    if ( _hourlyRate ) {
        [tutorSession setObject:_hourlyRate forKey:@"HourlyRate"];
    } else {
        [tutorSession setObject:[NSNull null] forKey:@"HourlyRate"];
    }
    
    if ( _location )
        [tutorSession setObject:_location forKey:@"Location"];
    else 
        [tutorSession setObject:[NSNull null] forKey:@"Location"];
    
    if ( _rating )
        [tutorSession setObject:_rating forKey:@"Rating"];
    else {
        [tutorSession setObject:[NSNull null] forKey:@"Rating"];
    }
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

-(PFObject *)getUserRating:(NSString *)_tutor4u_id
{
    if(userRating == nil) {
        PFQuery *query = [PFQuery queryWithClassName:@"tutorRating"];
        [query whereKey:@"Tutor4uID" equalTo:_tutor4u_id];
        userRating = [query getFirstObject];
    }
    return userRating;
}

-(PFObject *)getTutorRating:(NSString *)_tutor4u_id
{
    PFQuery *query = [PFQuery queryWithClassName:@"tutorRating"];
    [query whereKey:@"Tutor4uID" equalTo:_tutor4u_id];
    PFObject *tutorRating = [query getFirstObject];
    return tutorRating;
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
    tutorSession = [self downloadTutor:[PFUser currentUser].username];
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



