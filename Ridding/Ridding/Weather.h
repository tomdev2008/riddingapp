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
@property (nonatomic,retain) NSMutableArray *weatherIconUrls;
@property (nonatomic) int windspeedKmph;
@property (nonatomic,copy) NSString *winddirection;
@property (nonatomic,copy) NSString *url;


- (NSString*)weatherDescStr;

- (NSString*) windspeedKmphStr;

- (NSString*)winddirectionStr;

- (NSString*)urlFromUrl;

- (NSString*)subTitle;
@end
