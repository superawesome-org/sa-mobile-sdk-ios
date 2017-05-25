#import "SAAdMobExtras.h"
#import "SuperAwesome.h"

@implementation SAAdMobVideoExtra

- (id) init {
    if (self = [super init]) {
        _testEnabled = SA_DEFAULT_TESTMODE;
        _configuration = SA_DEFAULT_CONFIGURATION;
        _orientation = SA_DEFAULT_ORIENTATION;
        _parentalGateEnabled = SA_DEFAULT_PARENTALGATE;
        _closeButtonEnabled = SA_DEFAULT_CLOSEBUTTON;
        _closeAtEndEnabled = SA_DEFAULT_CLOSEATEND;
        _smallCLickEnabled = SA_DEFAULT_SMALLCLICK;
    }
    
    return self;
}

@end

@implementation SAAdMobCustomEventExtra

@synthesize trasparentEnabled = _trasparentEnabled;
@synthesize testEnabled = _testEnabled;
@synthesize parentalGateEnabled = _parentalGateEnabled;
@synthesize orientation = _orientation;
@synthesize configuration = _configuration;

- (id) init {
    _dict = [[NSMutableDictionary alloc] init];
    
    if (self = [super init]) {
        _testEnabled = SA_DEFAULT_TESTMODE;
        _configuration = SA_DEFAULT_CONFIGURATION;
        _parentalGateEnabled = SA_DEFAULT_PARENTALGATE;
        _orientation = SA_DEFAULT_ORIENTATION;
        _trasparentEnabled = SA_DEFAULT_BGCOLOR;
    }
    
    return self;
}

- (id)initWithObjects:(const id [])objects forKeys:(const id [])keys count:(NSUInteger)cnt {
    _dict = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys count:cnt];
    return self;
}
- (NSUInteger)count {
    return [_dict count];
}
- (id)objectForKey:(id)aKey {
    return [_dict objectForKey:aKey];
}
- (NSEnumerator *)keyEnumerator {
    return [_dict keyEnumerator];
}

- (void) setTrasparentEnabled:(BOOL)value {
    _trasparentEnabled = value;
    [_dict setObject:@(value) forKey:kKEY_TRANSPARENT];
}

- (void) setTestEnabled:(BOOL)value {
    _testEnabled = value;
    [_dict setObject:@(value) forKey:kKEY_TEST];
}

- (void) setConfiguration:(SAConfiguration)value {
    _configuration = value;
    [_dict setObject:@(value) forKey:kKEY_CONFIGURATION];
}

- (void) setParentalGateEnabled:(BOOL)value  {
    _parentalGateEnabled = value;
    [_dict setObject:@(value) forKey:kKEY_PARENTAL_GATE];
}

- (void) setOrientation:(SAOrientation)value {
    _orientation = value;
    [_dict setObject:@(value) forKey:kKEY_ORIENTATION];
}

@end
