#import "MJVersionUtils.h"

int MJOSXVersion(void) {
    static int v;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary * sv = [NSDictionary dictionaryWithContentsOfFile:@"/System/Library/CoreServices/SystemVersion.plist"];
        v = MJVersionFromString([sv objectForKey:@"ProductVersion"]);
    });
    return v;
}

int MJVersionFromString(NSString* str) {
    NSScanner* scanner = [NSScanner scannerWithString:str];
    int major;
    int minor;
    int bugfix = 0;
    [scanner scanInt:&major];
    [scanner scanString:@"." intoString:NULL];
    [scanner scanInt:&minor];
    if ([scanner scanString:@"." intoString:NULL]) {
        [scanner scanInt:&bugfix];
    }
    return major * 10000 + minor * 100 + bugfix;
}

int MJCurrentVersion(void) {
    NSString* ver = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    return MJVersionFromString(ver);
}
