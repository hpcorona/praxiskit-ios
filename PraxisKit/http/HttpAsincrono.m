//
//  HttpAsincrono.m
//  Piconfirm
//
//  Created by Hilario Perez Corona on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HttpAsincrono.h"

@implementation HttpAsincrono

- (id)init {
  self = [super init];
  if (self) {
    responseData = [NSMutableData data];
    request = nil;
    connection = nil;
    objetoCallback = nil;
    indicador = nil;
  }
  return self;
}

- (id)initWithView:(UIView*)view withCenter:(UIView*)viewCenter {
  self = [super init];
  if (self) {
    [self setupData];
    indicador = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicador.center = viewCenter.center;
    indicador.hidesWhenStopped = YES;
    indicador.color = [UIColor blackColor];
    
    [view addSubview:indicador];
  }
  return self;
}

- (id)initWithIndicator:(UIActivityIndicatorView *)view {
  self = [super init];
  if (self) {
    [self setupData];
    indicador = view;
  }
  return self;
}

- (void)setupData {
  responseData = [NSMutableData data];
  request = nil;
  connection = nil;
  objetoCallback = nil;
  indicador = nil;
}

- (void)peticion:(NSString *)url notificar:(id)obj siTodoBien:(SEL)ok error:(SEL)err {
    NSURL* baseURL = [NSURL URLWithString:url];
    NSURLRequest* request = [NSURLRequest requestWithURL:baseURL];
    [self peticionConRequest:request notificar:obj siTodoBien:ok error:err];
}

- (void)cancelar {
  if (connection != nil) {
    [connection cancel];
  }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
  [responseData setLength:0];
  statusCode = [(NSHTTPURLResponse*)response statusCode];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  if (indicador) {
    [indicador stopAnimating];
  }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
  if (errSelector != nil) {
    [objetoCallback performSelector:errSelector withObject:error];
  }
#pragma clang diagnostic pop
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  if (indicador) {
    [indicador stopAnimating];
  }
  if (statusCode >= 400) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    NSLog(@"Error %d",statusCode);
    if (errSelector != nil) {
      [objetoCallback performSelector:errSelector withObject:[NSError errorWithDomain:[NSString stringWithFormat:@"Error del servidor %d",statusCode] code:statusCode userInfo:nil]];
    }
#pragma clang diagnostic pop
    return;
  }
  
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
  NSLog(@"Respuesta %@",[responseData UTF8String]);
  [objetoCallback performSelector:okSelector withObject:responseData];
#pragma clang diagnostic pop
}


- (void)peticionConRequest:(NSURLRequest*)req notificar:(id)obj siTodoBien:(SEL)ok error:(SEL)err {
    [self cancelar];
    if (indicador != nil) {
        [indicador startAnimating];
    }
    objetoCallback = obj;
    okSelector = ok;
    errSelector = err;
    NSLog(@"Request: %@",[req description]);
    request = req;
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    statusCode = 0;
}

- (void)peticionConAttach:(NSString*)url params:(NSDictionary*)_params paramAttach:(NSString*)_param attach:(NSData*)data notificar:(id)obj siTodoBien:(SEL)ok error:(SEL)err {
    NSURLRequest* req = [self crearRequestConAttach:data url:url dataParam:_param params:_params];
    [self peticionConRequest:req notificar:obj siTodoBien:ok error:err];
}

- (void)peticionConParams:(NSString*)url params:(NSDictionary*)_params notificar:(id)obj siTodoBien:(SEL)ok error:(SEL)err {
	NSURL *tumblrURL = [NSURL URLWithString:url];
	NSMutableURLRequest *tumblrPost = [NSMutableURLRequest requestWithURL:tumblrURL];
	[tumblrPost setHTTPMethod:@"POST"];
	
	//Add the header info
	NSString *stringBoundary = @"AquiTerminaElRequest";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
	[tumblrPost addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	//create the body
	NSMutableData *postBody = [NSMutableData data];
	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	//add key values from the NSDictionary object
	NSEnumerator *keys = [_params keyEnumerator];
	int i;
	for (i = 0; i < [_params count]; i++) {
		NSString *tempKey = [keys nextObject];
		[postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",tempKey] dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData:[[NSString stringWithFormat:@"%@",[_params objectForKey:tempKey]] dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	}
    
	//add the body to the post
	[tumblrPost setHTTPBody:postBody];
    
    [self peticionConRequest:tumblrPost notificar:obj siTodoBien:ok error:err];
}

- (NSURLRequest*)crearRequestConAttach:(NSData*)data url:(NSString*)url dataParam:(NSString*)_param params:(NSDictionary*)_params {
	NSURL *tumblrURL = [NSURL URLWithString:url];
	NSMutableURLRequest *tumblrPost = [NSMutableURLRequest requestWithURL:tumblrURL];
	[tumblrPost setHTTPMethod:@"POST"];
	
	//Add the header info
	NSString *stringBoundary = @"AquiTerminaElRequest";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
	[tumblrPost addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	//create the body
	NSMutableData *postBody = [NSMutableData data];
	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	//add key values from the NSDictionary object
	NSEnumerator *keys = [_params keyEnumerator];
	int i;
	for (i = 0; i < [_params count]; i++) {
		NSString *tempKey = [keys nextObject];
		[postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",tempKey] dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData:[[NSString stringWithFormat:@"%@",[_params objectForKey:tempKey]] dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	}
    
	//add data field and file data
	[postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"upload.data\"\r\n",_param] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[NSData dataWithData:data]];
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	//add the body to the post
	[tumblrPost setHTTPBody:postBody];
    
	return tumblrPost;
}

@end
