/*
        File: AAPLAppDelegate.m
    Abstract: The application-specific delegate class.
     Version: 2.12
    
    Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
    Inc. ("Apple") in consideration of your agreement to the following
    terms, and your use, installation, modification or redistribution of
    this Apple software constitutes acceptance of these terms.  If you do
    not agree with these terms, please do not use, install, modify or
    redistribute this Apple software.
    
    In consideration of your agreement to abide by the following terms, and
    subject to these terms, Apple grants you a personal, non-exclusive
    license, under Apple's copyrights in this original Apple software (the
    "Apple Software"), to use, reproduce, modify and redistribute the Apple
    Software, with or without modifications, in source and/or binary forms;
    provided that if you redistribute the Apple Software in its entirety and
    without modifications, you must retain this notice and the following
    text and disclaimers in all such redistributions of the Apple Software.
    Neither the name, trademarks, service marks or logos of Apple Inc. may
    be used to endorse or promote products derived from the Apple Software
    without specific prior written permission from Apple.  Except as
    expressly stated in this notice, no other rights or licenses, express or
    implied, are granted by Apple herein, including but not limited to any
    patent rights that may be infringed by your derivative works or by other
    works in which the Apple Software may be incorporated.
    
    The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
    MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
    THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
    FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
    OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
    
    IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
    OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
    SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
    INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
    MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
    AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
    STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
    POSSIBILITY OF SUCH DAMAGE.
    
    Copyright (C) 2014 Apple Inc. All Rights Reserved.
    
*/

#import "AAPLAppDelegate.h"
#import "FLEXManager.h"

@interface AAPLAppDelegate () <NSURLConnectionDataDelegate, NSURLConnectionDelegate>

@property (nonatomic, strong) NSTimer *repeatingLogExampleTimer;
@property (nonatomic, strong) NSMutableArray *connections;

@end

@implementation AAPLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[FLEXManager sharedManager] setNetworkDebuggingEnabled:YES];
    [self sendExampleNetworkRequests];
    self.repeatingLogExampleTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sendExampleLogMessage) userInfo:nil repeats:YES];
    return YES;
}

- (void)sendExampleLogMessage
{
    // To show off the system log viewer, send 20 example log messages at 1 second intervals.
    static NSInteger count = 0;
    NSLog(@"Example log %ld", (long)count++);
    if (count > 20) {
        [self.repeatingLogExampleTimer invalidate];
    }
}

#pragma mark - Networking Example

- (void)sendExampleNetworkRequests
{
    NSArray *requestURLStrings = @[ @"http://cdn.flipboard.com/serviceIcons/v2/social-icon-flipboard-96.png",
                                    @"http://lorempixel.com/400/400/",
                                    @"http://google.com",
                                    @"http://search.cocoapods.org/api/pods?query=FLEX&amount=1",
                                    @"https://api.github.com/users/Flipboard/repos",
                                    @"http://lorempixel.com/320/480/",
                                    @"http://info.cern.ch/hypertext/WWW/TheProject.html",
                                    @"https://api.github.com/emojis",
                                    @"http://lorempixel.com/1024/1024/",
                                    @"https://api.github.com/repos/Flipboard/FLEX/issues",
                                    @"https://cloud.githubusercontent.com/assets/516562/3971767/e4e21f58-27d6-11e4-9b07-4d1fe82b80ca.png",
                                    @"http://hipsterjesus.com/api?paras=1&type=hipster-centric&html=false",
                                    @"http://lorempixel.com/750/1334/" ];

    NSTimeInterval delayTime = 0.0;
    self.connections = [NSMutableArray array];
    for (NSString *urlString in requestURLStrings) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
            [self.connections addObject:[[NSURLConnection alloc] initWithRequest:request delegate:self]];
        });
        delayTime += 5.0;
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.connections removeObject:connection];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.connections removeObject:connection];
}

@end
