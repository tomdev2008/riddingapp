//
//  Weather.h
//  Ridding
//
//  Created by ; on 13-2-17.
//
//

#import "BasicObject.h"
#define keyWeather @"weather"
@interface Weather : BasicObject

@property (nonatomic) int tempMaxC;
@property (nonatomic) int tempMinC;
@property (nonatomic) NSMutableArray *weatherDesc;
@property (nonatomic) int windspeedKmph;
@property (nonatomic,copy) NSString *winddirection;


- (NSString*)weatherDescStr;

- (NSString*) windspeedKmphStr;

- (NSString*)winddirectionStr;
@end
