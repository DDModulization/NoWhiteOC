//
//  NWTabBarC.m
//  NWBase
//
//  Created by deepindo on 2019/10/31.
//

#import "NWTabBarC.h"
#import "NWHomeController.h"
#import "NWMessageController.h"
#import "NWMeController.h"

@interface NWTabBarC ()

@end

@implementation NWTabBarC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addChildControllers];
    }
    return self;
}

- (void)addChildControllers {
    
    NWHomeController *homeVC = [NWHomeController new];
    UINavigationController *homeNav = [self addChildController:homeVC
                                                     withTitle:@"首页"
                                                  andItemImage:nil];
    
    NWMessageController *messageVC = [NWMessageController new];
    UINavigationController *messageNav = [self addChildController:messageVC
                                                        withTitle:@"消息"
                                                     andItemImage:nil];
    
    NWMeController *meVC = [NWMeController new];
    UINavigationController *meNav = [self addChildController:meVC
                                                   withTitle:@"我的"
                                                andItemImage:nil];
    
    //为tabBarVC添加子导航控制器
    self.viewControllers = @[homeNav,messageNav,meNav];
}

- (UINavigationController *)addChildController:(UIViewController *)vc withTitle:(NSString *)titleStr andItemImage:(NSString *)imgStr {
    
    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:vc];
    navC.tabBarItem.title = titleStr;
    //navC.tabBarItem.image = [UIImage imageNamed:imgStr];
    
    NSDictionary *titleTextDict = @{NSForegroundColorAttributeName:[UIColor blueColor]};
    [navC.tabBarItem setTitleTextAttributes:titleTextDict forState:UIControlStateNormal];
    
//    NSString *selectedImageStr = [NSString stringWithFormat:@"%@_selected",imgStr];
//    UIImage *selectedImage = [UIImage imageNamed:selectedImageStr];
//    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    navC.tabBarItem.selectedImage = selectedImage;
    
    return navC;
}

@end
