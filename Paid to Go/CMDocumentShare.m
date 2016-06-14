//
//  CMDocumentShare.m
//  Jiji
//
//  Created by Esteban Vallejo on 15/1/15.
//  Copyright (c) 2015 Esteban Vallejo. All rights reserved.
//

#import "CMDocumentShare.h"

#define BASE_VIEW [[[[UIApplication sharedApplication] delegate] window] rootViewController].view

@implementation CMDocumentShare

- (void)shareImage:(UIImage *)image withCompletionBlock:(void (^)(NSError *))completionBlock {
  self.completionBlock = completionBlock;
  
  NSString *savePath  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/StudAppPic.jpeg"];
  NSData *imgData = UIImageJPEGRepresentation(image, 1);
  
  if (![imgData writeToFile:savePath atomically:YES]) {
    NSError *cantWriteError = [[NSError alloc]initWithDomain:@"Cant write file" code:901 userInfo:nil];
    if (self.completionBlock) self.completionBlock(cantWriteError);
    return;
  }
  
  NSURL *theFileURL = [NSURL fileURLWithPath:savePath];
  self.documentInteractor = [UIDocumentInteractionController interactionControllerWithURL:theFileURL];
  [self.documentInteractor setDelegate:self];
  [self.documentInteractor setName:@"StudApp"];
  
  if(![self.documentInteractor presentOpenInMenuFromRect:CGRectZero inView:[UIApplication sharedApplication].windows.firstObject animated:YES]) {
    //  if (![self.documentInteractor presentOptionsMenuFromRect:CGRectZero inView:BASE_VIEW animated:YES]) {
    NSError *cantShowError = [[NSError alloc]initWithDomain:@"Cant show interactor" code:902 userInfo:nil];
    if (self.completionBlock) self.completionBlock(cantShowError);
    return;
  }
}

- (void)shareVideo:(NSURL *)videoUrl withCompletionBlock:(void (^)(NSError *))completionBlock {
  if (completionBlock) {
    self.completionBlock = completionBlock;
  }
  
  self.documentInteractor = [UIDocumentInteractionController interactionControllerWithURL:videoUrl];
  [self.documentInteractor setDelegate:self];
  [self.documentInteractor setName:@"StudApp"];
  
  if(![self.documentInteractor presentOpenInMenuFromRect:CGRectZero inView:[UIApplication sharedApplication].windows.firstObject animated:YES]) {
    //  if (![self.documentInteractor presentOptionsMenuFromRect:CGRectZero inView:BASE_VIEW animated:YES]) {
    NSError *cantShowError = [[NSError alloc]initWithDomain:@"Cant show interactor" code:902 userInfo:nil];
    if (self.completionBlock) self.completionBlock(cantShowError);
    return;
  }
}

#pragma mark - Document Interactor delegate
- (void)documentInteractionController:(UIDocumentInteractionController *)controller
           didEndSendingToApplication:(NSString *)application {
  NSLog(@"Document Interactor did end sending to application %@", application);
  if (self.completionBlock) self.completionBlock(nil);
}

- (void)documentInteractionController:(UIDocumentInteractionController *)controller
        willBeginSendingToApplication:(NSString *)application {
  NSLog(@"Document Interactor will begin sending to application %@", application);
}

-(void)documentInteractionControllerWillPresentOpenInMenu:(UIDocumentInteractionController *)controller
{
    
}

@end
