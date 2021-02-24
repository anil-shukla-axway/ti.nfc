/**
 * Axway Titanium
 * Copyright (c) 2009-present by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiNfcNativeTagTechnologyProxy.h"
#import <CoreNFC/CoreNFC.h>
#import <TitaniumKit/TitaniumKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TiNfcNDEFTagTechnology : TiProxy {
  NFCNDEFReaderSession *session;
  id<NFCNDEFTag> _tag;
}

- (id)_initWithPageContext:(id<TiEvaluator>)context andSession:(NFCNDEFReaderSession *)session andTag:(id<NFCNDEFTag>)tag;

- (NSNumber *)available;

- (void)queryNDEFStatus;

- (void)readNDEF:(id)args;

- (void)writeNDEF:(id)args;

- (void)writeLock:(id)args;

@end

NS_ASSUME_NONNULL_END
