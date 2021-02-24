/**
 * Axway Titanium
 * Copyright (c) 2009-present by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiNfcNDEFTagTechnology.h"
#import "TiNfcNdefMessageProxy.h"

@implementation TiNfcNDEFTagTechnology

- (id)_initWithPageContext:(id<TiEvaluator>)context andSession:(NFCTagReaderSession *)session andTag:(id<NFCNDEFTag>)tag
{
  if (self = [super _initWithPageContext:context]) {
    _tag = tag;
    session = session;
  }
  return self;
}

#pragma mark Public API's

- (void)connect:(id)unused
{
  [session connectToTag:_tag
      completionHandler:^(NSError *_Nullable error) {
        if (![self _hasListeners:@"didConnectNDEFTag"]) {
          return;
        }
        [self fireEvent:@"didConnectNDEFTag"
             withObject:@{
               @"errorCode" : NUMINTEGER([error code]),
               @"errorDescription" : [error localizedDescription],
               @"errorDomain" : [error domain],
               @"tag" : _tag
             }];
      }];
}

- (NSNumber *)available
{
  return NUMINT(_tag.available);
}

- (void)queryNDEFStatus
{

  [_tag queryNDEFStatusWithCompletionHandler:^(NFCNDEFStatus status, NSUInteger capacity, NSError *_Nullable error) {
    if (error == nil) {
      if (![self _hasListeners:@"didQueryNDEFStatus"]) {
        return;
      }
      [self fireEvent:@"didQueryNDEFStatus"
           withObject:@{
             @"errorCode" : NUMINTEGER([error code]),
             @"errorDescription" : [error localizedDescription],
             @"errorDomain" : [error domain]
           }];
    }
  }];
}

- (void)readNDEF:(id)args
{

  NSArray<NFCNDEFMessage *> *messages = [[args firstObject] valueForKey:@"message"];
  NSMutableSet<TiNfcNdefMessageProxy *> *result = [NSMutableSet setWithCapacity:messages.count];

  for (NFCNDEFMessage *message in messages) {
    [result addObject:[[TiNfcNdefMessageProxy alloc] _initWithPageContext:[self pageContext] andRecords:message.records]];
  }
  [_tag readNDEFWithCompletionHandler:^(NFCNDEFMessage *result, NSError *error) {
    if (error == nil) {
      if (![self _hasListeners:@"didReadNDEFMessage"]) {
        return;
      }
      [self fireEvent:@"didReadNDEFMessage"
           withObject:@{
             @"errorCode" : NUMINTEGER([error code]),
             @"errorDescription" : [error localizedDescription],
             @"errorDomain" : [error domain]
           }];
    }
  }];
}

- (void)writeNDEF:(id)args
{

  NSArray<NFCNDEFMessage *> *messages = [[args firstObject] valueForKey:@"messages"];
  NSMutableSet<TiNfcNdefMessageProxy *> *result = [NSMutableSet setWithCapacity:messages.count];
  for (NFCNDEFMessage *message in messages) {
    [result addObject:[[TiNfcNdefMessageProxy alloc] _initWithPageContext:[self pageContext] andRecords:message.records]];
  }
  NSLocale *locale = [NSLocale autoupdatingCurrentLocale];

  TiNfcNdefMessageProxy *message = [NFCNDEFPayload wellKnownTypeTextPayloadWithString:messages locale:locale];

  [_tag writeNDEF:message
      completionHandler:^(NSError *error) {
        if (error == nil) {
          if (![self _hasListeners:@"didWirteNDEFMessage"]) {
            return;
          }
          [self fireEvent:@"didWirteNDEFMessage"
               withObject:@{
                 @"errorCode" : NUMINTEGER([error code]),
                 @"errorDescription" : [error localizedDescription],
                 @"errorDomain" : [error domain]
               }];
        }
      }];
}

@end
