//
//  RNZenDeskSupport.m
//
//  Created by Patrick O'Connor on 8/30/17.
//

// RN < 0.40 suppoert
#if __has_include(<React/RCTBridge.h>)
#import <React/RCTConvert.h>
#else
#import "RCTConvert.h"
#endif

#import "RNZenDeskSupport.h"
#import <ZendeskSDK/ZendeskSDK.h>
@implementation RNZenDeskSupport

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(initialize:(NSDictionary *)config){
    NSString *appId = [RCTConvert NSString:config[@"appId"]];
    NSString *zendeskUrl = [RCTConvert NSString:config[@"zendeskUrl"]];
    NSString *clientId = [RCTConvert NSString:config[@"clientId"]];
    [[ZDKConfig instance]
     initializeWithAppId:appId
     zendeskUrl:zendeskUrl
     clientId:clientId];
}

RCT_EXPORT_METHOD(setupIdentity:(NSDictionary *)identity){
    dispatch_async(dispatch_get_main_queue(), ^{
        ZDKAnonymousIdentity *zdIdentity = [ZDKAnonymousIdentity new];
        NSString *email = [RCTConvert NSString:identity[@"customerEmail"]];
        NSString *name = [RCTConvert NSString:identity[@"customerName"]];
        if (email != nil) {
            zdIdentity.email = email;
        }
        if (name != nil) {
            zdIdentity.name = name;
        }
        [ZDKConfig instance].userIdentity = zdIdentity;

    });
}

RCT_EXPORT_METHOD(showHelpCenterWithOptions:(NSDictionary *)options) {
   NSDictionary *navbarAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [UIColor whiteColor] ,NSForegroundColorAttributeName, nil];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.97 green:0.10 blue:0.59 alpha:1.0]];
    [[UINavigationBar appearance] setTitleTextAttributes:navbarAttributes];
    [[UISearchBar appearance] setBarTintColor:[UIColor colorWithRed:208.0f/255.0f green:218.0f/255.0f blue:224.0f/255.0f alpha:1.0f]];
    //Style Support SDK
    ZDKTheme * theme = [ZDKTheme baseTheme];
    
    theme.fontName = @"Graphik";
    theme.boldFontName = @"Graphik-Medium";
    
    theme.primaryTextColor = [UIColor colorWithRed:0.08 green:0.09 blue:0.17 alpha:1.0];;
    theme.secondaryTextColor = [UIColor colorWithRed:0.36 green:0.37 blue:0.47 alpha:1.0];;
    theme.primaryBackgroundColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:1.0];
    theme.secondaryBackgroundColor = [UIColor colorWithRed:0.99 green:0.99 blue:0.99 alpha:1.0];
    theme.emptyBackgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.99 alpha:1.0];
    theme.metaTextColor = [UIColor colorWithRed:139.0f/255.0f green:139.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    theme.separatorColor = [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:241.0f/255.0f alpha:1.0f];
    theme.inputFieldTextColor = [UIColor colorWithRed:47.0f/255.0f green:46.0f/255.0f blue:63.0f/255.0f alpha:1.0f];
    theme.inputFieldBackgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    [theme apply];

    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        UIViewController *vc = [window rootViewController];
        ZDKHelpCenterOverviewContentModel *helpCenterContentModel = [ZDKHelpCenterOverviewContentModel defaultContent];
        helpCenterContentModel.hideContactSupport = [RCTConvert BOOL:options[@"hideContactSupport"]];
        if (helpCenterContentModel.hideContactSupport) {
            [ZDKHelpCenter setNavBarConversationsUIType:ZDKNavBarConversationsUITypeNone];
        }
        vc.modalPresentationStyle = UIModalPresentationFormSheet;
        [ZDKHelpCenter presentHelpCenterOverview:vc withContentModel:helpCenterContentModel];
    });
}

RCT_EXPORT_METHOD(showCategoriesWithOptions:(NSArray *)categories options:(NSDictionary *)options) {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        UIViewController *vc = [window rootViewController];
        ZDKHelpCenterOverviewContentModel *helpCenterContentModel = [ZDKHelpCenterOverviewContentModel defaultContent];
        helpCenterContentModel.groupType = ZDKHelpCenterOverviewGroupTypeCategory;
        helpCenterContentModel.groupIds = categories;
        helpCenterContentModel.hideContactSupport = [RCTConvert BOOL:options[@"hideContactSupport"]];
        if (helpCenterContentModel.hideContactSupport) {
            [ZDKHelpCenter setNavBarConversationsUIType:ZDKNavBarConversationsUITypeNone];
        }
        vc.modalPresentationStyle = UIModalPresentationFormSheet;
        [ZDKHelpCenter presentHelpCenterOverview:vc withContentModel:helpCenterContentModel];
    });
}

RCT_EXPORT_METHOD(showSectionsWithOptions:(NSArray *)sections options:(NSDictionary *)options) {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        UIViewController *vc = [window rootViewController];
        ZDKHelpCenterOverviewContentModel *helpCenterContentModel = [ZDKHelpCenterOverviewContentModel defaultContent];
        helpCenterContentModel.groupType = ZDKHelpCenterOverviewGroupTypeSection;
        helpCenterContentModel.groupIds = sections;
        helpCenterContentModel.hideContactSupport = [RCTConvert BOOL:options[@"hideContactSupport"]];
        if (helpCenterContentModel.hideContactSupport) {
            [ZDKHelpCenter setNavBarConversationsUIType:ZDKNavBarConversationsUITypeNone];
        }
        vc.modalPresentationStyle = UIModalPresentationFormSheet;
        [ZDKHelpCenter presentHelpCenterOverview:vc withContentModel:helpCenterContentModel];
    });
}

RCT_EXPORT_METHOD(showLabelsWithOptions:(NSArray *)labels options:(NSDictionary *)options) {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        UIViewController *vc = [window rootViewController];
        ZDKHelpCenterOverviewContentModel *helpCenterContentModel = [ZDKHelpCenterOverviewContentModel defaultContent];
        helpCenterContentModel.labels = labels;
        helpCenterContentModel.hideContactSupport = [RCTConvert BOOL:options[@"hideContactSupport"]];
        if (helpCenterContentModel.hideContactSupport) {
            [ZDKHelpCenter setNavBarConversationsUIType:ZDKNavBarConversationsUITypeNone];
        }
        vc.modalPresentationStyle = UIModalPresentationFormSheet;
        [ZDKHelpCenter presentHelpCenterOverview:vc withContentModel:helpCenterContentModel];
    });
}

RCT_EXPORT_METHOD(setLocale:(NSString *)locale) {
    [ZDKConfig instance].userLocale = locale;
}

RCT_EXPORT_METHOD(showHelpCenter) {
    [self showHelpCenterWithOptions:nil];
}

RCT_EXPORT_METHOD(showCategories:(NSArray *)categories) {
    [self showCategoriesWithOptions:categories options:nil];
}

RCT_EXPORT_METHOD(showSections:(NSArray *)sections) {
    [self showSectionsWithOptions:sections options:nil];
}

RCT_EXPORT_METHOD(showLabels:(NSArray *)labels) {
    [self showLabelsWithOptions:labels options:nil];
}

RCT_EXPORT_METHOD(callSupport:(NSDictionary *)customFields) {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        UIViewController *vc = [window rootViewController];

        NSMutableArray *fields = [[NSMutableArray alloc] init];

        for (NSString* key in customFields) {
            id value = [customFields objectForKey:key];
            [fields addObject: [[ZDKCustomField alloc] initWithFieldId:@(key.intValue) andValue:value]];
        }
        [ZDKConfig instance].customTicketFields = fields;
        [ZDKRequests presentRequestCreationWithViewController:vc];
    });
}

RCT_EXPORT_METHOD(supportHistory){
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        UIViewController *vc = [window rootViewController];
        [ZDKRequests presentRequestListWithViewController:vc];
    });
}
@end
