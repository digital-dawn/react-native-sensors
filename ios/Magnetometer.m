
//  Magnetometer.m


#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>
#import "Magnetometer.h"

@implementation Magnetometer

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

- (id) init {
    self = [super init];
    NSLog(@"Magnetometer");

    if (self) {
        self->_motionManager = [[CMMotionManager alloc] init];
        //Accelerometer
        if([self->_motionManager isMagnetometerAvailable])
        {
            NSLog(@"Magnetometer available");
            /* Start the accelerometer if it is not active already */
            if([self->_motionManager isMagnetometerActive] == NO)
            {
                NSLog(@"Magnetometer active");
            } else {
                NSLog(@"Magnetometer not active");
            }
        }
        else
        {
            NSLog(@"Magnetometer not available!");
        }
    }
    return self;
}

RCT_EXPORT_METHOD(setUpdateInterval:(double) interval) {
    NSLog(@"setUpdateInterval: %f", interval);
    double intervalInSeconds = interval / 1000;

    [self->_motionManager setMagnetometerUpdateInterval:intervalInSeconds];
}

RCT_EXPORT_METHOD(getUpdateInterval:(RCTResponseSenderBlock) cb) {
    double interval = self->_motionManager.magnetometerUpdateInterval;
    NSLog(@"getUpdateInterval: %f", interval);
    cb(@[[NSNull null], [NSNumber numberWithDouble:interval]]);
}

RCT_EXPORT_METHOD(getData:(RCTResponseSenderBlock) cb) {
    double x = self->_motionManager.magnetometerData.magnetometer.x;
    double y = self->_motionManager.magnetometerData.magnetometer.y;
    double z = self->_motionManager.magnetometerData.magnetometer.z;
    double timestamp = self->_motionManager.magnetometerData.timestamp;

    NSLog(@"getData: %f, %f, %f, %f", x, y, z, timestamp);

    cb(@[[NSNull null], @{
                 @"x" : [NSNumber numberWithDouble:x],
                 @"y" : [NSNumber numberWithDouble:y],
                 @"z" : [NSNumber numberWithDouble:z],
                 @"timestamp" : [NSNumber numberWithDouble:timestamp]
             }]
       );
}

RCT_EXPORT_METHOD(startUpdates) {
    NSLog(@"startUpdates");
    [self->_motionManager startMagnetometerUpdates];

    /* Receive the accelerometer data on this block */
    [self->_motionManager startMagnetometerUpdatesToQueue:[NSOperationQueue mainQueue]
                                               withHandler:^(CMAccelerometerData *magnetometerData, NSError *error)
     {
         double x = magnetometerData.magnetometer.x;
         double y = magnetometerData.magnetometer.y;
         double z = magnetometerData.magnetometer.z;
         double timestamp = accelerometerData.timestamp;
         NSLog(@"startMagnetometerUpdates: %f, %f, %f, %f", x, y, z, timestamp);

         [self.bridge.eventDispatcher sendDeviceEventWithName:@"Magnetometer" body:@{
                                                                                   @"x" : [NSNumber numberWithDouble:x],
                                                                                   @"y" : [NSNumber numberWithDouble:y],
                                                                                   @"z" : [NSNumber numberWithDouble:z],
                                                                                   @"timestamp" : [NSNumber numberWithDouble:timestamp]
                                                                               }];
     }];

}

RCT_EXPORT_METHOD(stopUpdates) {
    NSLog(@"stopUpdates");
    [self->_motionManager stopMagnetometerUpdates];
}

@end
