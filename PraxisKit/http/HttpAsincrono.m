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
  if (indicador != nil) {
    [indicador startAnimating];
  }
  objetoCallback = obj;
  okSelector = ok;
  errSelector = err;
  NSLog(@"Request: %@",url);
  NSURL* baseURL = [NSURL URLWithString:url];
  request = [NSURLRequest requestWithURL:baseURL];
  [self cancelar];
  connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
  statusCode = 0;
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

@end
