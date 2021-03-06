//
//  LGBaiduOcrManager.m
//  Word
//
//  Created by Charles Cao on 2018/4/16.
//  Copyright © 2018年 Charles. All rights reserved.
//

#import "LGBaiduOcrManager.h"
#import "NSDate+Utilities.h"

static NSString *kHTBaiduOcrKey = @"kHTBaiduOcrKey";

static NSString *kHTBaiduOcrApiKey = @"bXYKXZ0KhpdrZsAbsq2MRPte";

static NSString *kHTBaiduOcrSecretKey = @"amZ3IMbbAjH2qStVvYGYstrrUfKfqrgu";

@implementation LGBaiduOcrManager

+ (void)requestWithImage:(UIImage *)image complete:(void (^)(NSString *))complete{
	
	[LGBaiduOcrManager reqeustBaiduOauthToken:^(NSString *access_token) {
		
        NSData *imageData = [LGBaiduOcrManager jpgDataWithImage:image sizeLimit:1024000];
        NSString *encodedImageStr = [imageData base64EncodedStringWithOptions:0];
        
		
		NSURLSession *session = [NSURLSession sharedSession];
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://aip.baidubce.com/rest/2.0/ocr/v1/general_basic?access_token=%@",access_token]];
		
        NSDictionary *bodyDic = @{
                                  @"probability" : @"true",
                                  @"detect_direction" : @"true",
                                  @"language_type" : @"ENG",
                                  @"image" : encodedImageStr
                                  };
		
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
		request.HTTPMethod = @"POST";
		[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
		[request setHTTPBody:[[self wwwFormWithDictionary:bodyDic] dataUsingEncoding:NSUTF8StringEncoding]];
		
		NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
			dispatch_async(dispatch_get_main_queue(), ^{
				if (error) {
					complete(@"");
					return;
				}
				NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
				
				if (dic[@"error_code"]) {
					NSInteger code = [dic[@"error_code"] integerValue];
					if (code == 100 || code == 110 || code == 111) {
						[LGBaiduOcrManager reqeustBaiduOauthToken:nil];
						complete(@"");
						return;
					}
                }else{
					NSArray *array = [dic objectForKey:@"words_result"];
					if (array.count > 0) {
						
						//置信度排序
						NSArray *tempArray = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
							CGFloat average1 = [((NSDictionary *)obj1)[@"probability"][@"average"] floatValue];
							CGFloat average2 = [((NSDictionary *)obj2)[@"probability"][@"average"] floatValue];
							return average1 < average2 ? NSOrderedDescending : NSOrderedAscending;
						}];
						
						complete(tempArray.firstObject[@"words"]);
					}else{
						complete(@"");
					}
					return;
                }
				complete(@"");
			});
		}];
		[dataTask resume];
	}];
}

+ (void)reqeustBaiduOauthToken:(void(^)(NSString *access_token))complete{
	
	LGBaiduTokenModel *tokenModel = [LGBaiduTokenModel mj_objectWithKeyValues:[[NSUserDefaults standardUserDefaults] objectForKey:kHTBaiduOcrKey]];
	if (tokenModel && tokenModel.isValid && complete) {
		complete(tokenModel.token);
	}else{
		
		NSURLSession *session = [NSURLSession sharedSession];
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://aip.baidubce.com/oauth/2.0/token?grant_type=client_credentials&client_id=%@&client_secret=%@&",kHTBaiduOcrApiKey,kHTBaiduOcrSecretKey]];
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
		request.HTTPMethod = @"POST";
		NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
			if (error == nil) {
				NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
				NSString *access_token = dic[@"access_token"];
				
				LGBaiduTokenModel *tokenModel = [LGBaiduTokenModel new];
				tokenModel.token = access_token;
				tokenModel.createTime = [[NSDate date] timeIntervalSince1970];
				[[NSUserDefaults standardUserDefaults]setObject:[tokenModel mj_keyValues] forKey:kHTBaiduOcrKey];
				if (complete) {
					complete(access_token);
				}
			}
		}];
		[dataTask resume];
	}
}

+ (NSData *)jpgDataWithImage:(UIImage *)image sizeLimit:(NSUInteger)maxSize {
    CGFloat compressionQuality = 1.0;
    NSData *imageData = nil;
    
    int i = 0;
    do{
        imageData = UIImageJPEGRepresentation(image, compressionQuality);
        compressionQuality -= 0.1;
        i += 1;
    }while(i < 3 && imageData.length > maxSize);
    return imageData;
}

+ (NSString *)wwwFormWithDictionary:(NSDictionary *)dict {
    NSMutableString *result = [[NSMutableString alloc] init];
    if (dict != nil) {
        for (NSString *key in dict) {
            if (result.length)
                [result appendString:@"&"];
            [result appendString:[self base64Escape:key]];
            [result appendString:@"="];
            [result appendString:[self base64Escape:dict[key]]];
        }
    }
    return result;
}


+ (NSString *)base64Escape:(NSString *)string {
    NSCharacterSet *URLBase64CharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"/+=\n"] invertedSet];
    return [string stringByAddingPercentEncodingWithAllowedCharacters:URLBase64CharacterSet];
}

@end


@implementation LGBaiduTokenModel

- (BOOL)isValid{
	if (self.token.length == 0) return NO;
	if ([[NSDate date]timeIntervalSince1970] - self.createTime < 3600 * 24 * 25 ) {
		return YES;
	}else{
		return NO;
	}
}

@end
