//
//  CMDocumentShare.h
//  Jiji
//
//  Created by Esteban Vallejo on 15/1/15.
//  Copyright (c) 2015 Esteban Vallejo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CMDocumentShare : NSObject <UIDocumentInteractionControllerDelegate>

@property (nonatomic, copy) void(^completionBlock)(NSError *);
@property (strong, nonatomic) UIDocumentInteractionController *documentInteractor;

- (void)shareImage:(UIImage *)image withCompletionBlock:(void(^)(NSError *error))completionBlock;
- (void)shareVideo:(NSURL *)videoUrl withCompletionBlock:(void(^)(NSError *error))completionBlock;

@end
