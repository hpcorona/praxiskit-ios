//
//  HttpAsincrono.h
//  Piconfirm
//
//  Created by Hilario Perez Corona on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "../augmented/NSObject_Utils.h"
#import "../JSON/SBJson.h"

@interface HttpAsincrono : NSObject {

  NSMutableData *responseData;
  NSURLRequest *request;
  NSURLConnection *connection;
  int statusCode;

  id objetoCallback;
  SEL okSelector;
  SEL errSelector;
  
  UIActivityIndicatorView *indicador;
  
}

- (id)init;
- (id)initWithView:(UIView*)view withCenter:(UIView*)viewCenter;
- (id)initWithIndicator:(UIActivityIndicatorView*)view;
- (void)peticion:(NSString*)url notificar:(id)obj siTodoBien:(SEL)ok error:(SEL)err;
- (void)peticionConRequest:(NSURLRequest*)req notificar:(id)obj siTodoBien:(SEL)ok error:(SEL)err;
- (void)peticionConAttach:(NSString*)url params:(NSDictionary*)_params paramAttach:(NSString*)_param attach:(NSData*)data notificar:(id)obj siTodoBien:(SEL)ok error:(SEL)err;
- (void)peticionConParams:(NSString*)url params:(NSDictionary*)_params notificar:(id)obj siTodoBien:(SEL)ok error:(SEL)err;
- (void)cancelar;

@end
