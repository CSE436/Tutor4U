//
//  ParseTransport.h
//  Tutor4U
//
//  Created by Zeddy Chirombe on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

#define T4U_SUCCESS 0

@interface ParseTransport : NSObject {
    PFObject *userProfile;
    PFObject *userAddress;
    PFObject *userRating;
    PFObject *tutorSession;
    PFObject *studentSession;

}

-(id)init;
-(int)setUserProfile:(NSString *)_tutor4u_id :(NSString *)_firstName :(NSString *)_lastName :(NSString *)_phoneNumber;
-(int)setUserAddress:(NSString *)_tutor4u_id :(NSString *)_streetAddr :(NSString *)_apt :(NSString *)_city :(NSString *)_state :(NSString *)_zipCode;
-(int)setUserRating:(NSString *)_tutor4u_id :(NSNumber *)_summedReviews :(NSNumber *)_totalReviews;
-(int)setTutorRating:(NSString *)_tutor4u_id :(NSNumber *)_summedReviews :(NSNumber *)_totalReviews;
-(int)uploadTutor:(NSString *)_tutor4u_id :(NSString *)_subject :(NSString *)_hourlyRate :(NSString *)_location :(NSString *)_rating;
-(int)uploadStudent:(NSString *)_tutor4u_id :(NSString *)_subject :(NSString *)_hourlyRate :(NSString *)_location :(NSString *)_rating;

-(PFObject *)getUserProfile:(NSString *)_tutor4u_id;
-(PFObject *)getUserAddress:(NSString *)_tutor4u_id;
-(PFObject *)getUserRating:(NSString *)_tutor4u_id;
-(PFObject *)getTutorRating:(NSString *)_tutor4u_id;
-(PFObject *)downloadTutor:(NSString *)_tutor4u_id;
-(PFObject *)downloadStudent:(NSString *)_tutor4u_id;
-(NSArray *)downloadTutors;
-(NSArray *)downloadStudents;

-(int)dropProfile;
-(int)dropTutor;
-(int)dropStudent;
-(void)logout;

+(void)pushChannelManagement;

@end
