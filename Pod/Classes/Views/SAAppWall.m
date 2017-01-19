/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SAAppWall.h"
#import "SuperAwesome.h"
#import "SAParentalGate.h"

#if defined(__has_include)
#if __has_include(<SAModelSpace/SAResponse.h>)
#import <SAModelSpace/SAResponse.h>
#else
#import "SAResponse.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAModelSpace/SAAd.h>)
#import <SAModelSpace/SAAd.h>
#else
#import "SAAd.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAModelSpace/SACreative.h>)
#import <SAModelSpace/SACreative.h>
#else
#import "SACreative.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAModelSpace/SADetails.h>)
#import <SAModelSpace/SADetails.h>
#else
#import "SADetails.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAModelSpace/SAMedia.h>)
#import <SAModelSpace/SAMedia.h>
#else
#import "SAMedia.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAUtils/SAUtils.h>)
#import <SAUtils/SAUtils.h>
#else
#import "SAUtils.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAUtils/SAImageUtils.h>)
#import <SAUtils/SAImageUtils.h>
#else
#import "SAImageUtils.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAAdLoader/SALoader.h>)
#import <SAAdLoader/SALoader.h>
#else
#import "SALoader.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SASession/SASession.h>)
#import <SASession/SASession.h>
#else
#import "SASession.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAEvents/SAEvents.h>)
#import <SAEvents/SAEvents.h>
#else
#import "SAEvents.h"
#endif
#endif

/**
 * Internal class representing an app wall cell.
 * Subclass of UICollectionViewCell
 */
@interface SAAppWallCell : UICollectionViewCell

/**
 * Method to setup a cell in case a "big" layout is needed.
 * That's when the number of cells in the app wall is low and I need to fill
 * the space with something.
 *
 * @param imagePath the path, on disk, of where the image is
 * @param title     the associated title of the image (the ad's / app's name)
 */
- (void) setupForBigLayoutWithImagePath:(NSString*) imagePath
                               andTitle:(NSString*) title;

/**
 * Method to setup a cell in case a "small" layout is needed.
 * That's when the number of cells in the app wall is hight and I don't
 * need to fill in empty space.
 *
 * @param imagePath the path, on disk, of where the image is
 * @param title     the associated title of the image (the ad's / app's name)
 */
- (void) setupForSmallLayoutWithImagePath:(NSString*) imagePath
                                 andTitle:(NSString*) title;
@end

@interface SAAppWallCell ()

// private app wall cell variables
@property (nonatomic, strong) NSString      *imagePath;
@property (nonatomic, strong) NSString      *title;
@property (nonatomic, strong) UIImageView   *appIcon;
@property (nonatomic, strong) UILabel       *appTitle;
@end

@implementation SAAppWallCell

- (void) setupForSmallLayoutWithImagePath:(NSString*)imagePath
                                 andTitle:(NSString*)title {
    
    // get these two
    _imagePath = imagePath;
    _title = title;
    
    // re-arrange cell
    [self clearSubviews];
    [self arrangeSubviewsForSmallLayout];
}

- (void) setupForBigLayoutWithImagePath:(NSString *)imagePath
                               andTitle:(NSString *)title {
    
    // get these two
    _imagePath = imagePath;
    _title = title;
    
    // re-arrange cell
    [self clearSubviews];
    [self arrangeSubviewsForBigLayout];
}

/**
 * Method that clears subviews from an app wall cell
 */
- (void) clearSubviews {
    if (_appIcon) {
        [_appIcon removeFromSuperview];
        _appIcon = nil;
    }
    
    if (_appTitle) {
        [_appTitle removeFromSuperview];
        _appTitle = nil;
    }
}

/**
 * This method does the actual arrangement of a cell's layout in case of a 
 * small layout is needed.
 */
- (void) arrangeSubviewsForSmallLayout {
    
    NSString *imageUrl = [SAUtils filePathInDocuments:_imagePath];
    CGRect iconFrame = CGRectMake(15, 15, self.frame.size.width - 30, self.frame.size.width - 30);
    CGRect titleFrame = CGRectMake(0, self.frame.size.width, self.frame.size.width, self.frame.size.height - self.frame.size.width);
    
    _appIcon = [[UIImageView alloc] initWithFrame:iconFrame];
    _appIcon.backgroundColor = [UIColor whiteColor];
    _appIcon.layer.borderColor = [UIColor whiteColor].CGColor;
    _appIcon.layer.borderWidth = 2.0f;
    _appIcon.layer.cornerRadius = 7.5f;
    _appIcon.layer.masksToBounds = true;
    [_appIcon setImage:[UIImage imageWithContentsOfFile:imageUrl]];
    [self addSubview:_appIcon];
    
    _appTitle = [[UILabel alloc] initWithFrame:titleFrame];
    [_appTitle setText:_title];
    [_appTitle setNumberOfLines:0];
    [_appTitle setLineBreakMode:NSLineBreakByWordWrapping];
    [_appTitle setTextColor:[UIColor whiteColor]];
    [_appTitle setTextAlignment:NSTextAlignmentCenter];
    [_appTitle setFont:[UIFont boldSystemFontOfSize:12]];
    [self addSubview:_appTitle];
}

/**
 * This method does the actual arrangement of a cell's layout in case of a
 * big layout is needed.
 */
- (void) arrangeSubviewsForBigLayout {
    
    NSString *imageUrl = [SAUtils filePathInDocuments:_imagePath];
    CGRect iconFrame = CGRectMake(25, 25, self.frame.size.height - 50, self.frame.size.height - 50);
    CGRect titleFrame = CGRectMake(self.frame.size.height, 0, self.frame.size.width - self.frame.size.height - 10, self.frame.size.height);
    
    _appIcon = [[UIImageView alloc] initWithFrame:iconFrame];
    _appIcon.backgroundColor = [UIColor whiteColor];
    _appIcon.layer.borderColor = [UIColor whiteColor].CGColor;
    _appIcon.layer.borderWidth = 2.0f;
    _appIcon.layer.cornerRadius = 15.0f;
    _appIcon.layer.masksToBounds = true;
    [_appIcon setImage:[UIImage imageWithContentsOfFile:imageUrl]];
    [self addSubview:_appIcon];
    
    _appTitle = [[UILabel alloc] initWithFrame:titleFrame];
    [_appTitle setText:_title];
    [_appTitle setNumberOfLines:0];
    [_appTitle setLineBreakMode:NSLineBreakByWordWrapping];
    [_appTitle setTextColor:[UIColor whiteColor]];
    [_appTitle setTextAlignment:NSTextAlignmentLeft];
    [_appTitle setFont:[UIFont boldSystemFontOfSize:18]];
    [self addSubview:_appTitle];
}

@end

@interface SAAppWall () <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource>

// hold the current ad response and array of associated events
@property (nonatomic, strong) SAResponse                    *response;
@property (nonatomic, strong) NSMutableArray <SAEvents*>    *events;

// different UI elements: background iamge, close ,padlock, etc
@property (nonatomic, strong) UIImageView                   *backgroundImage;
@property (nonatomic, strong) UIButton                      *closeButton;
@property (nonatomic, strong) UIImageView                   *titleImgView;
@property (nonatomic, strong) UIButton                      *padlock;
@property (nonatomic, strong) UIImageView                   *header;

// collection view & associated flow layout
@property (nonatomic, strong) UICollectionView              *gamewall;
@property (nonatomic, strong) UICollectionViewFlowLayout    *layout;

// the parental gate
@property (nonatomic, strong) SAParentalGate                *gate;

// hold the prev status bar hidden or not
@property (nonatomic, assign) BOOL                          previousStatusBarHiddenValue;

@end

@implementation SAAppWall

// dictionary of responses
static NSMutableDictionary *responses;

// other static variables needed for state
static sacallback callback           = ^(NSInteger placementId, SAEvent event) {};
static BOOL isParentalGateEnabled    = SA_DEFAULT_PARENTALGATE;
static BOOL isTestingEnabled         = SA_DEFAULT_TESTMODE;
static SAConfiguration configuration = SA_DEFAULT_CONFIGURATION;

/**
 * Overridden UIViewController "viewDidLoad" method in which the ad is setup
 * and redrawn to look good.
 */
- (void) viewDidLoad {
    [super viewDidLoad];
    
    // get the status bar value
    _previousStatusBarHiddenValue = [[UIApplication sharedApplication] isStatusBarHidden];
    
    // set bg color
    self.view.backgroundColor = [UIColor whiteColor];
    
    // get main static vars into local ones
    __block sacallback _callbackL = [SAAppWall getCallback];
    
    // create events array
    _events = [@[] mutableCopy];
    for (SAAd *ad in _response.ads) {
        SAEvents *event = [[SAEvents alloc] init];
        [event setAd:ad];
        [_events addObject:event];
    }
    
    // callback
    _callbackL(_response.placementId, adShown);
    
    // scale
    // start adding subviews - start w/ background
    _backgroundImage = [[UIImageView alloc] initWithFrame:self.view.frame];
    [_backgroundImage setImage:[SAImageUtils gameWallBackground]];
    _backgroundImage.contentMode = UIViewContentModeCenter;
    [self.view addSubview:_backgroundImage];
    
    // start the collection view
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.minimumLineSpacing = 0;
    _layout.minimumInteritemSpacing = 0;
    _gamewall = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 107, self.view.frame.size.width, self.view.frame.size.height - 107)
                                   collectionViewLayout:_layout];
    [_gamewall setDataSource:self];
    [_gamewall setDelegate:self];
    _gamewall.clipsToBounds = false;
    [_gamewall setAlwaysBounceVertical:true];
    _gamewall.showsVerticalScrollIndicator = false;
    _gamewall.showsHorizontalScrollIndicator = false;
    [_gamewall registerClass:[SAAppWallCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_gamewall setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_gamewall];
    [_gamewall reloadData];
    
    // add the header
    _header = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 107)];
    [_header setImage:[SAImageUtils gameWallHeader]];
    _header.layer.masksToBounds = NO;
    _header.layer.shadowOffset = CGSizeMake(0, 7.5);
    _header.layer.shadowRadius = 5;
    _header.layer.shadowOpacity = 0.35;
    [self.view addSubview:_header];
    
    // add the title
    _titleImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [_titleImgView setImage:[SAImageUtils gameWallAppData]];
    _titleImgView.center = _header.center;
    [self.view addSubview:_titleImgView];
    
    // add the padlock
    _padlock = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 67, 25)];
    [_padlock setImage:[SAImageUtils padlockImage] forState:UIControlStateNormal];
    [_padlock addTarget:self action:@selector(padlockAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_padlock];
    
    // add the close button
    _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 70, 10, 60, 60)];
    [_closeButton setImage:[SAImageUtils gameWallClose] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [_closeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 40, 0)];
    [self.view addSubview:_closeButton];
}

/**
 * Overridden UIViewController "didReceiveMemoryWarning" method
 */
- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * Overridden UIViewController "viewWillAppear" method in which the status bar 
 * is set to hidden.
 *
 * @param animated whether the view will appear animated or not
 */
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

/**
 * Overridden UIViewController "viewDidAppear" method in which I send out all
 * neeeded events for the ad.
 * 
 * @param aniamted whether the view has appeared animated or not
 */
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // send events
    for (SAEvents *event in _events) {
        [event sendAllEventsForKey:@"impression"];
        [event sendAllEventsForKey:@"sa_impr"];
        [event sendViewableImpressionForDisplay:self.view];
    }
}

/**
 * Overridden UIViewController "viewWillDisappear" method in which I reset the
 * status bar state
 *
 * @param aniamted whether the view will disappeared animated or not
 */
- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:_previousStatusBarHiddenValue
                                            withAnimation:UIStatusBarAnimationNone];
}

/**
 * Overridden UIViewController "supportedInterfaceOrientations" method in which 
 * I set the supported orientations
 *
 * @return valid orientations for this view controller
 */
- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

/**
 * Overridden UIViewController "shouldAutorotateToInterfaceOrientation" method 
 * in which I set that the view controller should auto rotate
 *
 * @return true or false
 */
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

/**
 * Overridden UIViewController "prefersStatusBarHidden" method
 * in which I set that the view controller prefers a hidden status bar
 *
 * @return true or false
 */
- (BOOL) prefersStatusBarHidden {
    return true;
}

/**
 * Overridden UICollectionViewDelegate method that returns the number of
 * cells in the collection view.
 *
 * @param collectionView    the current instance of the calling collection view
 * @param section           current section to return the number of cells for
 * @return                  number of cells, equal to number of ads
 */
- (NSInteger) collectionView:(UICollectionView*) collectionView
      numberOfItemsInSection:(NSInteger) section {
    
    return [_response.ads count];
}

/**
 * Overridden UICollectionViewDelegate method that sets up a cell in the
 * collection view
 *
 * @param collectionView    the current instance of the calling collection view
 * @param indexPath         current index path to setup
 * @return                  a valid, setup, instance of a cell
 */
- (UICollectionViewCell*) collectionView:(UICollectionView*) collectionView
                  cellForItemAtIndexPath:(NSIndexPath*) indexPath {
    
    // get ad for index
    SAAd *ad = [_response.ads objectAtIndex:[indexPath row]];
    
    // get the actuall cell
    SAAppWallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier"
                                                                     forIndexPath:indexPath];
    
    // case for big layout (small nr of cells)
    if ([_response.ads count] <= 3) {
        [cell setupForBigLayoutWithImagePath:ad.creative.details.media.playableDiskUrl
                                    andTitle:ad.creative.name];
    }
    // case for small layout (large nr of cells)
    else {
        [cell setupForSmallLayoutWithImagePath:ad.creative.details.media.playableDiskUrl
                                      andTitle:ad.creative.name];
    }
    
    // setup bg color
    cell.backgroundColor = [UIColor clearColor];
    
    // return
    return cell;
}

/**
 * Overridden UICollectionViewDelegate method that returns the layout to be
 * appliead for the collection view, based on the number of cells / ads to
 * be displayed
 *
 * @param collectionView       the current instance of the calling 
 *                             collection view
 * @param collectionViewLayout the current layout for the collection view
 * @param indexPath            current index path to setup
 * @return                     the CGSize used to setup the layout
 */
- (CGSize) collectionView:(UICollectionView*) collectionView
                   layout:(UICollectionViewLayout*) collectionViewLayout
   sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // case for big layout (small nr of cells)
    if ([_response.ads count] <= 3) {
        CGFloat width = self.view.frame.size.width;
        return CGSizeMake(width, _gamewall.frame.size.height / 3.0);
    }
    // case for small layout (large nr of cells)
    else {
        CGFloat width = self.view.frame.size.width / 3.0f;
        return CGSizeMake(width, width + width / 3.0f);
    }
}

/**
 * Overridden UICollectionViewDelegate method that returns the edge
 * inset needed. Usually zero.
 *
 * @param collectionView       the current instance of the calling
 *                             collection view
 * @param collectionViewLayout the current layout for the collection view
 * @param section              current section to return the number
 *                             of cells for
 * @return                     a zeroed inset
 */
- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView
                         layout:(UICollectionViewLayout *)collectionViewLayout
         insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

/**
 * Overridden UICollectionViewDelegate method that the min inter item
 * spacing. It's zero.
 *
 * @param collectionView       the current instance of the calling
 *                             collection view
 * @param collectionViewLayout the current layout for the collection view
 * @param section              current section to return the number 
 *                             of cells for
 * @return                     always zero
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0;
}

/**
 * Overridden UICollectionViewDelegate method that handles selecting a 
 * cell at an index path
 *
 * @param collectionView    the current instance of the calling
 * @param indexPath         current index path to setup
 */
- (void) collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // get position
    NSInteger pos = [indexPath row];
    
    // get local var from static
    __block BOOL _isParentalGateEnabledL = [SAAppWall getIsParentalGateEnabled];
    
    // get the current ad
    SAAd *ad = [_response.ads objectAtIndex:pos];
    
    // either call the PG or goto click
    if (_isParentalGateEnabledL) {
        _gate = [[SAParentalGate alloc] initWithWeakRefToView:self andAd:ad andPosition:pos];
        [_gate show];
    } else {
        [self click:[indexPath row]];
    }
    
}

/**
 * Method that is called to close the ad
 */
- (void) close {
    
    // call delegate
    sacallback _callbackL = [SAAppWall getCallback];
    _callbackL(_response.placementId, adClosed);
    
    // remove current response
    [SAAppWall removeResponseFromLoadedResponses:_response];
    
    // destroy the gate
    if (_gate != nil) {
        _gate = nil;
    }
    
    // dismiss VC
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 * Method that is called when a user clicks / taps on an ad
 *
 * @param position  sent in by the collection view so I know which events to
 *                  send back to the ad server
 */
- (void) click: (NSInteger) position {
    
    // get ad
    SAAd *ad = [_response.ads objectAtIndex:position];
    // get event
    SAEvents *event = [_events objectAtIndex:position];
    
    // get local
    sacallback callbackL = [SAAppWall getCallback];
    
    callbackL(_response.placementId, adClicked);
    
    // call trackers
    NSString *_destinationURL = ad.creative.clickUrl;
    
    // send SA tracking evt
    if ([_destinationURL rangeOfString:@"ads.superawesome"].location == NSNotFound ||
        [_destinationURL rangeOfString:@"ads.staging.superawesome"].location == NSNotFound) {
        [event sendAllEventsForKey:@"sa_tracking"];
    }
    
    // send aux install event, if exists
    [event sendAllEventsForKey:@"install"];
    
    // go to URL
    if (_destinationURL) {
        NSURL *url = [NSURL URLWithString:_destinationURL];
        [[UIApplication sharedApplication] openURL:url];
    }
    
    NSLog(@"Going to %@", _destinationURL);
}

/**
 * Method called when the user clicks on a padlock
 */
- (void) padlockAction {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://ads.superawesome.tv/v2/safead"]];
}

+ (void) load:(NSInteger) placementId {
    
    // create dictionary
    if (responses == NULL) {
        responses = [@{} mutableCopy];
    }
    
    // if  there's no object around
    if ([responses objectForKey:@(placementId)] == NULL) {
        
        // set a placeholder
        [responses setObject:@(true) forKey:@(placementId)];
        
        // form a new session
        SASession *session = [[SASession alloc] init];
        [session setTestMode:isTestingEnabled];
        [session setConfiguration:configuration];
        [session setVersion:[[SuperAwesome getInstance] getSdkVersion]];
        
        // get the loader
        SALoader *loader = [[SALoader alloc] init];
        [loader loadAd:placementId withSession:session andResult:^(SAResponse *response) {
            
            // add to the array queue
            if ([response isValid]) {
                [responses setObject:response forKey:@(placementId)];
            }
            // remove
            else {
                [responses removeObjectForKey:@(placementId)];
            }
            
            // callback
            callback(placementId, [response isValid] ? adLoaded : adFailedToLoad);
        }];
        
    } else {
        callback (placementId, adFailedToLoad);
    }
}

+ (void) play:(NSInteger) placementId fromVC:(UIViewController*)parent {
    
    // find out if the ad is loaded
    SAResponse *responseL = [responses objectForKey:@(placementId)];
    
    // try to start the view controller (if there is one ad that's OK)
    if (responseL && responseL.format == SA_Appwall) {
        
        SAAppWall *newVC = [[SAAppWall alloc] init];
        newVC.response = responseL;
        [parent presentViewController:newVC animated:YES completion:nil];
        
    } else {
        callback(placementId, adFailedToShow);
    }
}

+ (BOOL) hasAdAvailable: (NSInteger) placementId {
    id object = [responses objectForKey:@(placementId)];
    return object != NULL && [object isKindOfClass:[SAResponse class]];
}

/**
 * Method that clears an ad from the dictionary of ads, once it has been played
 *
 * @param response the SAResponse object to be cleared
 */
+ (void) removeResponseFromLoadedResponses:(SAResponse*)response {
    [responses removeObjectForKey:@(response.placementId)];
}

+ (void) setCallback:(sacallback)call {
    callback = call ? call : callback;
}

+ (void) enableTestMode {
    [self setTestMode:true];
}

+ (void) disableTestMode {
    [self setTestMode:false];
}

+ (void) enableParentalGate {
    [self setParentalGate:true];
}

+ (void) disableParentalGate {
    [self setParentalGate:false];
}

+ (void) setConfigurationProduction {
    [self setConfiguration:PRODUCTION];
}

+ (void) setConfigurationStaging {
    [self setConfiguration:STAGING];
}

+ (void) setTestMode: (BOOL) value {
    isTestingEnabled = value;
}

+ (void) setParentalGate: (BOOL) value {
    isParentalGateEnabled = value;
}

+ (void) setConfiguration: (NSInteger) value {
    configuration = value;
}

+ (sacallback) getCallback {
    return callback;
}

+ (BOOL) getIsParentalGateEnabled {
    return isParentalGateEnabled;
}

@end
