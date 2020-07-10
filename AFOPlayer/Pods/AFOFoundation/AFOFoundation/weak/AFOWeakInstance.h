//
//  AFOWeakInstance.h
//  AFOFoundation
//
//  Created by xueguang xian on 2018/1/26.
//  Copyright © 2018年 AFO Science Technology Ltd. All rights reserved.
//

#ifndef AFOWeakInstance_h
#define AFOWeakInstance_h

#define WeakObject(object) __weak typeof(object) weak##object = object;
#define StrongObject(object) __strong typeof(object)   object = weak##object;

#endif /* AFOWeakInstance_h */
