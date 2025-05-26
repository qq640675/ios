//
//  SandPayGate.h
//  SandPayGate
//
//  Created by WGPawn on 2023/1/30.
//

#import <Foundation/Foundation.h>


//! Project version number for SandPayGate.
FOUNDATION_EXPORT double SandPayGateVersionNumber;

//! Project version string for SandPayGate.
FOUNDATION_EXPORT const unsigned char SandPayGateVersionString[];
 

#if __has_include(<SandPayGate/SandPayGateService.h>)

#import <SandPayGate/SandPayGateService.h>

#else
#import "SandPayGateService.h"

#endif
