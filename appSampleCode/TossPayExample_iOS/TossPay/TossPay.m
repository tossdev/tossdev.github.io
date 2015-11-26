//
//  TossPay.m
//  TossPay
//
//  Created by mr.park on 2015. 8. 7..
//
//

#import "TossPay.h"

static tossSuccessBlock successCallbackBlock;
static NSURL * successCallbackURL;

@implementation TossPay

+(BOOL)isTossInstalled{
    
    NSString* tossScheme = @"supertoss://";
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:tossScheme]];
}


+(BOOL)launchTossAppWithPayToken:(NSString *)payToken sourceName:(NSString *)sourceName successURL:(NSURL *)successURL successBlock:(tossSuccessBlock)successBlock{
    
    NSAssert(payToken, @"payToken should be existed to launch Toss for pay");
    NSAssert([self isTossInstalled], @"launch Toss fail, Toss not installed. please check whether Toss is installed.");
    
    NSString *urlString = [NSString stringWithFormat:@"supertoss://x-callback-url/pay?payToken=%@", [self encodedString:payToken]];
   
    if(sourceName && successURL){
        
        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&x-source=%@&x-success=%@",[self encodedString:sourceName], [self encodedString:successURL.absoluteString]]];
    
        if(successBlock){
            
            successCallbackURL = successURL;
            successCallbackBlock = successBlock;
        }
    }
    
    return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}


#pragma mark - util


+(NSDictionary*)parseURLParams:(NSString *)query{
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    [pairs enumerateObjectsUsingBlock:^(NSString *pair, NSUInteger idx, BOOL *stop) {
        NSArray *comps = [pair componentsSeparatedByString:@"="];
        if ([comps count] == 2) {
            [result setObject:[comps[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:comps[0]];
        }
    }];
    
    return result;
}

+(BOOL)hadleTossCallback:(NSURL *)url{
    
    if(successCallbackURL && [url isEqual:successCallbackURL]){
     
        successCallbackBlock();
        
        successCallbackBlock = nil;
        successCallbackURL = nil;
    }
    
    return YES;
}

+(NSString*)encodedString:(NSString*)text{
    
    return [text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}


@end
